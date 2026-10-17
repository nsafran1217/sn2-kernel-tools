#!/bin/bash
# One-time setup on a target (the NFS root is shared, so once is enough):
# build hackbench, lmbench and tlbbench from /opt/machvec-bench/src with
# the native gcc, and say which T2 packages are still missing.
set -eu
B=/opt/machvec-bench
cd $B

gcc -O2 -Wall -pthread -o $B/hackbench src/hackbench/hackbench.c
gcc -O2 -pthread -o $B/tlbbench tlbbench.c

# Binaries only (make results would start the interactive lmbench run);
# they land in src/lmbench/bin/<os>/.  -k: lat_mem_pingpong uses x86 asm
# and fails on ia64; only the binaries below are needed.
make -k -C src/lmbench/src || true
ln -sfn src/lmbench $B/lmbench
for b in lat_syscall lat_ctx lat_pagefault lat_mmap lat_proc; do
	ls $B/lmbench/bin/*/$b
done

for p in perf:perf fio:fio iperf3:iperf; do
	command -v ${p%%:*} >/dev/null || echo "missing ${p%%:*}: t2 inst ${p##*:}"
done
