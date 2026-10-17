# Measuring the SN2 runtime dispatch

What we want to know:

- **Integrity** (rx2800 Tukwila, hprx Montecito): does the combined kernel
  cost anything compared with the same tree built with `IA64_SGI_SN2=n`?
  Target: no benchmark regresses by more than 1% with a 95% CI that excludes 0.
- **Altix** (pople): what the combined kernel costs compared with the
  `IA64_SGI_SN2_ONLY` build.  Reported, and accepted.

All three boxes netboot the same kernel and NFS root from 10.40.0.121, so the
tools and results under `/opt/machvec-bench` are shared, split by host.

## Files

| File | Runs on | What |
|--|--|--|
| `mv-static.sh <base-tree> <cand-tree>` | workstation | vmlinux/module size, bloat-o-meter, count of `ia64_sn2_platform` tests |
| `mvbench/` | target (module) | ITC cycles/op for the bare test, `readl` vs `readl_relaxed` (control), `inb`, `mmiowb`, IPI round trip |
| `build-mvbench.sh <tree>` | workstation | builds `mvbench.ko` for that kernel, installs it and the scripts in the NFS root |
| `tlbbench.c` | target (built there) | `mprotect` toggling with the mm live on two CPUs, i.e. the global TLB purge |
| `mvbench.sh <label> [reps]` | target | runs everything, writes `results.csv` per boot |
| `mvbench-compare.py <base> <cand>` | anywhere | medians, IQR, bootstrap CI, verdicts |

`mvbench.sh` also runs lmbench (`lat_syscall null`, `lat_ctx`,
`lat_pagefault`, `lat_mmap`, `lat_proc fork/exec`) and `hackbench -pTl 4000`
when they are found, under `perf stat -e cycles,instructions` when `perf` is
installed (ia64 PMU support is in linux-ia64 since 7.2).  Instruction counts
are much less noisy than wall time.  `iperf3` runs when `IPERF_SERVER` is set,
and a read-only `fio` 4k random-read runs when `FIO_DEV` is set (HP disks only;
pople has none).

The `readl` target defaults to BAR0 of the NIC carrying the NFS root, at a
register that is safe to read repeatedly (tg3: offset 0, the PCI ID mirror;
e1000/e1000e/igb: STATUS).  The IPI and TLB tests use CPU 0 and the last CPU
(`MVB_FAR_CPU`), which should be on another socket/node; check with
`lscpu`/`numactl -H` and override if not.

## Protocol

1. Build each kernel with the **same compiler** (`IA64_GCC_VERSION=16.2.0`) and
   the same config apart from the platform options
   (`src/machvec/cfg/{generic,combined,sn2only}.config`):
   ```
   cp ../cfg/<mode>.config .config
   IA64_GCC_VERSION=16.2.0 KSRC=src/machvec/linux-sn2-7.3 ia64-build.sh mv-<mode>
   IA64_GCC_VERSION=16.2.0 sn2-kernel-tools/machvec/bench/build-mvbench.sh src/machvec/linux-sn2-7.3
   ```
   Keep each build's tree state (or vmlinux) for `mv-static.sh`.
2. Point the box's netboot entry at `vmlinuz-mv-<mode>` (back up the config
   first) and boot.
3. Check `dmesg | grep 'ia64: platform'`, then run
   `/opt/machvec-bench/mvbench.sh <mode>` on an otherwise idle box.
4. Alternate kernels across boots, A B A B, with at least two boots each.
5. Compare, for example:
   ```
   mvbench-compare.py results/rx2800/generic results/rx2800/combined
   mvbench-compare.py results/pople/sn2only  results/pople/combined
   ```
6. Write the numbers and conclusions to `../RESULTS.md`.
