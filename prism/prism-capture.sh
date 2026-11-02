#!/bin/bash
# Run as root on the Prism: write one read-only report of this boot.  Works on
# both T2 and SLES9, so the two can be diffed.
#
#   prism-capture.sh [label]
#
# Writes $OUTDIR/capture-<label>-<release>-<date>.txt, default OUTDIR is
# /root/prism-captures.  Copy that file back to prism/logs/ on the workstation.
#
# Nothing here writes to hardware or reads a BAR, the ROM or SAL error logs.
# The sections are ordered safest first and each one is synced to disk before
# the next, because TIO has never been run with some of these paths: if the box
# dies, the report so far survives and its last header names the culprit.

LABEL=${1:-boot}
OUTDIR=${OUTDIR:-/root/prism-captures}
REL=$(uname -r)
OUT=$OUTDIR/capture-$LABEL-$REL-$(date +%Y%m%d-%H%M%S).txt

mkdir -p "$OUTDIR" || exit 1
: > "$OUT" || exit 1

have() { type "$1" >/dev/null 2>&1; }

# TIMEOUT stays empty where the box has no timeout(1), as old SLES9 installs may
TIMEOUT=
have timeout && TIMEOUT="timeout 60"

section() {
	{
		echo
		echo "===== $* ====="
	} >> "$OUT"
	sync
}

# run <command>: skipped if the program isn't there
run() {
	have "$1" || return 0
	section "$*"
	$TIMEOUT "$@" >> "$OUT" 2>&1
}

# show <file...>: each file that exists and is readable
show() {
	local f
	for f in "$@"; do
		[ -r "$f" ] && [ -f "$f" ] || continue
		section "$f"
		$TIMEOUT cat "$f" >> "$OUT" 2>&1
	done
}

# the first lspci that accepts these flags: SLES9's pciutils predates some
lspci_first() {
	have lspci || return 0
	local flags
	for flags in "$@"; do
		if lspci $flags > /dev/null 2>&1; then
			section "lspci $flags"
			$TIMEOUT lspci $flags >> "$OUT" 2>&1
			return
		fi
	done
}

card_dirs() {
	local d
	for d in /sys/bus/pci/devices/*; do
		[ -r "$d/class" ] || continue
		case $(cat "$d/class") in
			0x0300*) echo "$d" ;;
		esac
	done
}

section "summary"
{
	echo "label:   $LABEL"
	echo "date:    $(date)"
	echo "release: $REL"
	echo "cmdline: $(cat /proc/cmdline)"
	echo "cpus:    $(grep -c '^processor' /proc/cpuinfo)"
	echo "nodes:   $(ls -d /sys/devices/system/node/node* 2>/dev/null | wc -l)"
	echo "dsdt:    $(dmesg | grep 'DSDT OEM Rev' | tail -1)"
	echo "sal:     $(dmesg | grep 'SAL .*version' | tail -1)"
	# not a bare MCA: every boot prints "MCA related initialization done"
	echo "errors:  $(dmesg | grep -c -E 'Oops|BUG:|Kernel panic|Call Trace|Fatal TIO')"
} >> "$OUT"

section "dmesg lines worth reading first"
dmesg | grep -n -i -E 'tio|sgi|sn2|agp|radeon|drm|vga|console:|firmware|oops|bug:|panic|fail|error' >> "$OUT"

section "os"
{ cat /etc/os-release 2>/dev/null || cat /etc/SuSE-release 2>/dev/null; } >> "$OUT"
run uname -a
show /proc/cmdline /proc/version

section "dmesg"
dmesg >> "$OUT" 2>&1

show /proc/meminfo /proc/buddyinfo /proc/modules /proc/filesystems /proc/mounts /proc/partitions
show /etc/fstab /boot/grub/grub.cfg
run ls -la /boot
run ls -la /boot/efi/EFI /boot/efi/EFI/boot
run ls -la /lib/modules
run ls -la /lib/firmware/radeon
run lsblk -f
run blkid
run findmnt
run ip addr
run ip route
run ifconfig -a
run systemctl --no-pager --failed
run efibootmgr -v

section "cpuinfo, first cpu"
sed '/^$/q' /proc/cpuinfo >> "$OUT" 2>&1

lspci_first -tv -t
lspci_first -nnk -nn -n
lspci_first "-vvvnn -xxx" "-vvvn -xxx" "-vvv -xxx"
show /proc/iomem /proc/ioports /proc/interrupts /proc/zoneinfo

# config-space and sysfs attributes only, never rom or resource<n>
for d in $(card_dirs); do
	section "card $d"
	for a in vendor device subsystem_vendor subsystem_device class irq enable \
		 boot_vga numa_node local_cpulist dma_mask_bits \
		 consistent_dma_mask_bits resource; do
		[ -r "$d/$a" ] || continue
		echo "$a: $(cat "$d/$a")" >> "$OUT" 2>&1
	done
	[ -L "$d/driver" ] &&
		echo "driver: $(basename "$(readlink "$d/driver")")" >> "$OUT"
done

show /proc/driver/agpgart
for f in /sys/class/drm/card*-*/status; do
	show "$f"
done

show /sys/devices/system/node/node*/meminfo /sys/devices/system/node/node*/distance
run numactl --hardware

# last, because these reach SN2 code that walks the TIO cnodes
for f in /proc/sgi_sn/*; do
	case ${f##*/} in
		sn_topology|sn_force_interrupt|sn_linkstats) ;;
		*) show "$f" ;;
	esac
done
show /proc/sgi_sn/sn_topology

sync
echo "$OUT"
