#!/bin/bash
# mvbench.sh - run the machvec benchmark suite on the target (pople, rx2800,
# hprx).  All three netboot the same NFS root, so this script, the tools and
# the results directory are shared; results are split by host and boot.
#
#   mvbench.sh <label> [reps]
#
# <label> names the kernel under test (e.g. "generic", "combined", "sn2only").
# Results: $MVB_OUT/<host>/<label>/boot-<boot_id>/results.csv plus raw logs.
#
# Optional environment:
#   MVB_OUT       results root            (default /opt/machvec-bench/results)
#   MVB_TOOLS     where tlbbench/hackbench live (default /opt/machvec-bench)
#   LMBENCH_BIN   lmbench bin directory   (default: first match of a few guesses)
#   MVB_BDF/MVB_OFF/MVB_BAR   MMIO register for mvbench readl (default: the
#                 netboot NIC, offset chosen per driver; see pick_mmio)
#   MVB_WSCRATCH  writable scratch register offset for the mmiowb test
#   MVB_PORT      I/O port for the inb test
#   MVB_CPU       CPU to run single-CPU benchmarks on      (default 0)
#   MVB_FAR_CPU   CPU on another socket/node for IPI/TLB   (default: last
#                 online CPU, after MVB_SMT)
#   MVB_SMT       "off" (default) takes every hardware thread but the first
#                 of each core offline for the run and brings it back at the
#                 end, so a benchmark thread never shares its core (CGMT on
#                 Montecito/Tukwila); "on" leaves the CPUs alone
#   MVB_ONLY      space-separated bench names to run (e.g. "lat_proc
#                 lat_proc_exec"); default all
#   IPERF_SERVER  run iperf3 against this host
#   FIO_DEV       run a read-only fio random-read test on this block device
#
# CSV columns: host,label,kernel,boot,bench,metric,unit,better,rep,value

set -u
LABEL=${1:?usage: mvbench.sh <label> [reps]}
REPS=${2:-10}
HERE=$(cd "$(dirname "$0")" && pwd)
MVB_OUT=${MVB_OUT:-/opt/machvec-bench/results}
MVB_TOOLS=${MVB_TOOLS:-/opt/machvec-bench}
MVB_CPU=${MVB_CPU:-0}
MVB_SMT=${MVB_SMT:-off}

# ---- SMT ------------------------------------------------------------------
SMT_OFFLINED=""
smt_restore() {
	local c
	for c in $SMT_OFFLINED; do echo 1 > /sys/devices/system/cpu/cpu$c/online; done
}
if [ "$MVB_SMT" = off ]; then
	for t in /sys/devices/system/cpu/cpu[0-9]*/topology/thread_siblings_list; do
		c=${t#/sys/devices/system/cpu/cpu}; c=${c%%/*}
		first=$(sed 's/[,-].*//' "$t")
		[ "$c" != "$first" ] && [ -w /sys/devices/system/cpu/cpu$c/online ] || continue
		echo 0 > /sys/devices/system/cpu/cpu$c/online && SMT_OFFLINED="$SMT_OFFLINED $c"
	done
	trap smt_restore EXIT
	trap 'exit 1' INT TERM
fi
MVB_FAR_CPU=${MVB_FAR_CPU:-$(sed 's/.*[,-]//' /sys/devices/system/cpu/online)}

HOST=$(hostname -s)
KREL=$(uname -r)
BOOT=$(cut -c1-8 /proc/sys/kernel/random/boot_id)
DIR=$MVB_OUT/$HOST/$LABEL/boot-$BOOT
mkdir -p "$DIR"
CSV=$DIR/results.csv
[ -f "$CSV" ] || echo "host,label,kernel,boot,bench,metric,unit,better,rep,value" > "$CSV"

want() { [ -z "${MVB_ONLY:-}" ] || [[ " $MVB_ONLY " == *" $1 "* ]]; }
log() { echo "[mvbench] $*" | tee -a "$DIR/run.log" >&2; }
row() { # bench metric unit better rep value
	echo "$HOST,$LABEL,$KREL,$BOOT,$1,$2,$3,$4,$5,$6" >> "$CSV"
}
lastnum() { # last numeric token in the input
	tr -s ' \t:=' '\n' | grep -E '^-?[0-9]+(\.[0-9]+)?$' | tail -1
}
PERF=$(command -v perf || true)

# ---- metadata -------------------------------------------------------------
{
	echo "date: $(date -Is)"
	echo "host: $HOST"
	echo "kernel: $(uname -a)"
	echo "cmdline: $(cat /proc/cmdline)"
	echo "cpus: $(nproc)  far_cpu: $MVB_FAR_CPU  smt: $MVB_SMT (offlined:${SMT_OFFLINED:- none})"
	grep -m1 'model name\|^family' /proc/cpuinfo
	free -m | sed -n 2p
	dmesg | grep -m2 -E 'ia64: platform|SGI|OEM ID'
	[ -r /proc/config.gz ] && echo "config md5: $(zcat /proc/config.gz | md5sum)"
} > "$DIR/meta.txt" 2>&1
log "host=$HOST kernel=$KREL boot=$BOOT -> $DIR"

# ---- mvbench.ko ------------------------------------------------------------
pick_mmio() {
	# Default: BAR0 of the NIC carrying the NFS root, at a register that is
	# safe to read repeatedly.
	local ifc dev drv
	[ -n "${MVB_BDF:-}" ] && return
	ifc=$(ip -o route get 10.40.0.121 2>/dev/null | sed -n 's/.* dev \([^ ]*\).*/\1/p')
	[ -n "$ifc" ] || return
	dev=$(basename "$(readlink -f /sys/class/net/$ifc/device)")
	drv=$(basename "$(readlink -f /sys/class/net/$ifc/device/driver)")
	case $drv in
	tg3)			MVB_OFF=${MVB_OFF:-0x0} ;;  # PCI config mirror (vendor/device)
	e1000|e1000e|igb)	MVB_OFF=${MVB_OFF:-0x8} ;;  # STATUS
	*)	log "mvbench: no safe register known for driver $drv, skipping readl"; return ;;
	esac
	MVB_BDF=$dev
	log "mvbench: readl target $MVB_BDF ($drv) bar ${MVB_BAR:-0} off $MVB_OFF"
}

run_mvbench() {
	want mvbench || return
	local ko=$MVB_TOOLS/mvbench/$KREL/mvbench.ko args=""
	if [ ! -f "$ko" ]; then
		log "mvbench: $ko missing (build-mvbench.sh), skipping"
		return
	fi
	pick_mmio
	[ -n "${MVB_BDF:-}" ] && args="bdf=$MVB_BDF bar=${MVB_BAR:-0} off=$((MVB_OFF))"
	[ -n "${MVB_WSCRATCH:-}" ] && args="$args wscratch=$((MVB_WSCRATCH))"
	[ -n "${MVB_PORT:-}" ] && args="$args port=$((MVB_PORT))"
	rmmod mvbench 2>/dev/null
	mount -t debugfs none /sys/kernel/debug 2>/dev/null
	insmod "$ko" $args ipi_cpu=$MVB_FAR_CPU || { log "mvbench: insmod failed"; return; }
	for r in $(seq 1 "$REPS"); do
		taskset -c "$MVB_CPU" cat /sys/kernel/debug/mvbench/run | tee -a "$DIR/mvbench.log" |
		while read -r line; do
			case $line in
			test=*)
				t=$(echo "$line" | sed 's/.*test=\([^ ]*\).*/\1/')
				med=$(echo "$line" | sed 's/.*median=\([^ ]*\).*/\1/')
				mn=$(echo "$line" | sed 's/.*min=\([^ ]*\).*/\1/')
				row mvbench "$t" itc/op lower "$r" "$med"
				row mvbench "$t.min" itc/op lower "$r" "$mn"
				;;
			esac
		done
	done
	rmmod mvbench
}

# ---- tlbbench -------------------------------------------------------------
run_tlbbench() {
	want tlbbench || return
	local bin=$MVB_TOOLS/tlbbench
	if [ ! -x "$bin" ] || [ "$HERE/tlbbench.c" -nt "$bin" ]; then
		gcc -O2 -pthread -o "$bin" "$HERE/tlbbench.c" || { log "tlbbench: build failed"; return; }
	fi
	"$bin" -a "$MVB_CPU" -b "$MVB_FAR_CPU" -r "$REPS" | tee -a "$DIR/tlbbench.log" |
	while read -r line; do
		r=$(echo "$line" | sed 's/.*rep=\([0-9]*\).*/\1/')
		row tlbbench mprotect_far ns/op lower "$r" "$(echo "$line" | lastnum)"
	done
}

# ---- perf-wrapped userspace benchmarks -----------------------------------
# run_timed <bench> <metric> <unit> <better> <cmd...>: the last number of
# the command's output is the metric; perf adds cycles and instructions.
# PERF_OPTS adds perf stat options (lat_proc uses -i: with inherited
# counters every child exit costs perf event teardown, ~28 ms on pople, so
# fork+exit would measure that instead of fork).
run_timed() {
	local bench=$1 metric=$2 unit=$3 better=$4 r out
	shift 4
	want "$bench" || return 0
	for r in $(seq 1 "$REPS"); do
		if [ -n "$PERF" ]; then
			out=$($PERF stat ${PERF_OPTS:-} -x, -e cycles,instructions -o "$DIR/perf.tmp" -- "$@" 2>&1)
			awk -F, -v b="$bench" -v m="$metric" '$3 ~ /^(cycles|instructions)/ && $1 ~ /^[0-9]+$/ {
				sub(/:.*/, "", $3); print b "," m "." $3 "," $1 }' "$DIR/perf.tmp" |
			while IFS=, read -r bb mm v; do row "$bb" "$mm" count lower "$r" "$v"; done
		else
			out=$("$@" 2>&1)
		fi
		echo "$out" >> "$DIR/$bench.log"
		row "$bench" "$metric" "$unit" "$better" "$r" "$(echo "$out" | lastnum)"
	done
}

find_lmbench() {
	local d
	[ -n "${LMBENCH_BIN:-}" ] && { echo "$LMBENCH_BIN"; return; }
	for d in /root/lmbench/bin/* /root/perftest/lmbench/bin/* /usr/src/lmbench/bin/* \
		 /opt/machvec-bench/lmbench/bin/*; do
		[ -x "$d/lat_syscall" ] && { echo "$d"; return; }
	done
}

run_lmbench() {
	local lb tmpf
	lb=$(find_lmbench)
	if [ -z "$lb" ]; then log "lmbench: not found (set LMBENCH_BIN), skipping"; return; fi
	tmpf=/tmp/mvbench.$$
	dd if=/dev/zero of=$tmpf bs=1M count=64 status=none
	run_timed lat_syscall null us lower taskset -c "$MVB_CPU" "$lb/lat_syscall" null
	run_timed lat_ctx 2p_0k us lower taskset -c "$MVB_CPU,$MVB_FAR_CPU" "$lb/lat_ctx" -s 0 2
	run_timed lat_pagefault file us lower taskset -c "$MVB_CPU" "$lb/lat_pagefault" $tmpf
	run_timed lat_mmap 64m us lower taskset -c "$MVB_CPU" "$lb/lat_mmap" 64m $tmpf
	PERF_OPTS=-i run_timed lat_proc fork us lower taskset -c "$MVB_CPU" "$lb/lat_proc" fork
	PERF_OPTS=-i run_timed lat_proc_exec exec us lower taskset -c "$MVB_CPU" "$lb/lat_proc" exec
	rm -f $tmpf
}

run_hackbench() {
	local hb=$MVB_TOOLS/hackbench
	[ -x "$hb" ] || hb=$(command -v hackbench || true)
	if [ -z "$hb" ]; then log "hackbench: not found, skipping"; return; fi
	run_timed hackbench pipe_threads s lower "$hb" -pTl 4000
}

run_iperf() {
	[ -n "${IPERF_SERVER:-}" ] || return
	command -v iperf3 >/dev/null || { log "iperf3: not installed, skipping"; return; }
	for r in $(seq 1 "$REPS"); do
		out=$(iperf3 -c "$IPERF_SERVER" -t 10 -f m 2>&1)
		echo "$out" >> "$DIR/iperf3.log"
		row iperf3 tx Mbit/s higher "$r" "$(echo "$out" | grep sender | awk '{print $(NF-3)}')"
	done
}

run_fio() {
	[ -n "${FIO_DEV:-}" ] || return
	command -v fio >/dev/null || { log "fio: not installed, skipping"; return; }
	for r in $(seq 1 "$REPS"); do
		out=$(fio --name=rr --filename="$FIO_DEV" --readonly --direct=1 --rw=randread \
			--bs=4k --ioengine=libaio --iodepth=32 --runtime=20 --time_based \
			--output-format=terse 2>&1)
		echo "$out" >> "$DIR/fio.log"
		# terse v3: field 8 = read IOPS
		row fio randread_4k iops higher "$r" "$(echo "$out" | tail -1 | cut -d';' -f8)"
	done
}

run_mvbench
run_tlbbench
run_lmbench
run_hackbench
run_iperf
run_fio
rm -f "$DIR/perf.tmp"
log "done: $(($(wc -l < "$CSV") - 1)) rows in $CSV"
