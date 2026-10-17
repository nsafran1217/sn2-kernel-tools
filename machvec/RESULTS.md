# SN2 runtime machvec — benchmark results (2026-10-16)

Branch `sn2-machvec-7.3` (worktree `src/machvec/linux-sn2-7.3`), gcc 16.2.0
with T2's ia64 patches. Raw data: `src/machvec/results/<host>/<kernel>/boot-*/`.
Compare with `bench/mvbench-compare.py --exclude lat_proc <base> <cand>`.

## Summary

- **Integrity, combined vs generic:** no measurable change in MMIO, syscall,
  page fault, mmap, TLB-purge or hackbench cost. Per-op instruction counts
  move by at most 0.3%. The one measurable cost is the **best-case
  context-switch round trip on rx2800: +2% (3.61 → 3.69 µs)**, in both boots
  of both combined kernels. hprx's lat_ctx is too bimodal to resolve 2%.
- **Altix, combined vs SN2-only:** lat_ctx +2.5%, IPI +0.7%; fork, exec and
  everything else within noise. **With the PDA `mmiowb` (commit `38c29fc484be`), lat_ctx drops
  to +0.7%.** The cost on SN2 was the flag test in every `spin_unlock()`.
- **Text size on the HP config:** combined +3.5% (+865 KB) over generic;
  with the PDA `mmiowb`, +3.1% (+750 KB). Most of it is cold code: the
  inlined SN2 PIO wait after every unlock.
- Generic (`SN2=n`) is identical to master-epic apart from 688 bytes of init
  code.

## Kernels

| Label | Host | Tree | Config |
|--|--|--|--|
| hp-epic | rx2800, hprx | linux-ia64 master-epic `67a35586068b` | T2 7.2.8 |
| hp-generic | rx2800, hprx | `51de71278c87`, `SN2=n` | T2 7.2.8 |
| hp-combined | rx2800, hprx | `51de71278c87`, `SN2=y` | T2 7.2.8 + SN2 |
| hp-mvpda | rx2800, hprx | `38c29fc484be`, `SN2=y` | T2 7.2.8 + SN2 |
| sn2only | pople | `51de71278c87`, `SN2_ONLY=y` | `cfg/sn2only` |
| combined | pople | `51de71278c87`, `SN2=y` | `cfg/combined` |
| mvpda | pople | `38c29fc484be`, `SN2=y` | `cfg/mvpda` |

hp-epic vs hp-generic is the **noise control**: the two run the same code
apart from SN2-layer init changes. Any difference between them is boot-to-boot
variation, and differences elsewhere have to exceed it to count.

## Method, and what went wrong on the way

- Each kernel was booted at least twice, in ABBA order (HP: epic, generic,
  combined, mvpda, mvpda, combined, generic, epic). Each boot runs
  `mvbench.sh <label> 10`. pople: 5 boots each of sn2only and combined, 2 of
  mvpda.
- **CGMT (hardware threads) invalidated the first HP run.** Both boxes run
  with threads on: rx2800 has 16 CPUs on 8 Tukwila cores, and hprx has 4 on 2
  Montecito cores. A busy sibling thread doubles `lat_syscall` (0.148 → 0.300
  µs on rx2800). One boot lost 6.7% of lat_pagefault's wall time to it.
  `mvbench.sh` now defaults to `MVB_SMT=off`, which takes every thread but the
  first of each core offline for the run. With the sibling offline, runs are
  tight. lat_syscall costs 1.5–1.8% more than with an idle sibling, the same
  for every kernel. That data is kept as `results/*-cgmt` and is not used here.
  Turning threads off in firmware (`cpuconfig threads off`) would be cleaner.
- **lat_proc (fork, exec) under `perf stat` measured perf, not fork.** With
  inherited counters every child exit takes about 28 ms on pople and almost
  exactly 40 ms on the HPs. Without perf, or with `perf stat -i`, it takes
  415 µs. A software event shows the same, so the cost is in perf's
  inherited-event teardown rather than the PMU driver. It is excluded below.
  `mvbench.sh` now uses `-i` for lat_proc, and a separate fork-only pople run
  is below.
- **lmbench instruction totals are not per op.** lmbench runs each test for a
  fixed time. `mvbench-compare.py` therefore derives `<metric>.ipo` =
  instructions × latency / cycles, which is instructions per op divided by
  the clock in MHz, for the single-threaded tests (syscall, pagefault, mmap).
  It is the lowest-noise signal here: the control moves it by ≤0.45%.
- **lat_ctx is bimodal** on the HPs. A round trip takes 3.6 µs or 10–21 µs
  on rx2800, and about 5 µs or about 15 µs on hprx, depending on how the
  wakeup lands, presumably on the idle state of the target CPU. Medians jump
  between modes, so the **minimum** is used. Its instruction totals are also
  timing-dependent: system-wide, hp-mvpda ran *fewer* instructions per
  context switch than hp-generic (43.5k vs 47.5k).
- `perf record` produces no samples on these kernels: the ia64 PMU driver
  counts but does not deliver overflow samples. That ruled out profiling the
  lat_ctx difference.

## Integrity (SMT off, 2 boots per kernel, 20 samples)

Change in median, with the bootstrap 95% CI. `*` means beyond 1% with a CI
excluding 0 in the worse direction. The **epic→generic column is the noise
floor**.

### rx2800 (2× Itanium 9340, 8 cores used)

| metric | generic | epic→generic (noise) | generic→combined | generic→mvpda |
|--|--|--|--|--|
| readl (ITC/op) | 1266 | −0.49% | −0.06% | −0.02% |
| readl_relaxed | 1265 | −0.50% | −0.04% | −0.05% |
| IPI round trip | 10850 | +1.27% | −1.16% | −1.10% |
| tlbbench mprotect_far (ns) | 5374 | −1.61% [−3.0,+0.5] | +2.31% [+1.2,+4.0]* | +2.94% [+1.0,+5.9]* |
| lat_syscall ipo | 0.2634 | +0.36% | −0.32% | −0.30% |
| lat_pagefault ipo | 1.715 | −0.10% [−3.9,+4.0] | −1.70% | +2.44% [+0.4,+4.6]* |
| lat_mmap ipo | 1137 | −0.06% | +0.31% | +0.30% |
| lat_syscall (µs) | 0.1509 | +1.96%* | −1.39% | −0.86% |
| lat_pagefault (µs) | 1.111 | −0.05% [−6.3,+6.6] | −2.63% | +3.69%* |
| lat_mmap (µs) | 832 | −2.29% | +0.78% | +2.76%* |
| hackbench (s) | 6.569 | +0.71% | −1.06% | +0.43% |
| lat_ctx min per boot (µs) | 3.61 / 3.62 | epic 3.63 / 3.64 | 3.70 / 3.69 | 3.69 / 3.68 |

### hprx (Itanium 9020, 2 cores used)

| metric | generic | epic→generic (noise) | generic→combined | generic→mvpda |
|--|--|--|--|--|
| readl (ITC/op) | 537.4 | +0.00% | +0.00% | +0.00% |
| readl_relaxed | 537.3 | −0.00% | +0.00% | +0.00% |
| IPI round trip | 1889 | +3.39%* | −0.66% | −4.86% |
| tlbbench mprotect_far (ns) | 6240 | −1.10% | +0.58% | +0.58% |
| lat_syscall ipo | 0.3219 | +0.45% | −0.22% | −0.31% |
| lat_pagefault ipo | 2.013 | +0.01% | +0.44% | +0.15% |
| lat_mmap ipo | 1393 | −0.09% | +0.30% | +0.24% |
| lat_syscall (µs) | 0.1777 | +0.91% | +0.11% | +0.17% |
| lat_pagefault (µs) | 1.261 | −0.12% | +1.33%* | +0.54% |
| lat_mmap (µs) | 1005 | −2.33% | +3.98%* | +3.03%* |
| hackbench (s) | 16.3 | +1.77%* | +0.38% | −1.22% |
| lat_ctx min per boot (µs) | 4.76 / 12.55 | epic 5.47 / 4.79 | 5.00 / 4.93 | 4.89 / 5.03 |

### Reading the HP numbers

- **MMIO:** `readl` and the undispatched `readl_relaxed` are identical on all
  four kernels (within 0.06%). The flag test costs nothing measurable next to
  a 1266-cycle (rx2800) or 537-cycle (hprx) PCI read. `is_sn2` alone measures
  0.46 → 1.38 ITC (rx2800) and 0.28 → 0.84 (hprx), about 2–3 core cycles.
- **Per-op instructions (ipo)** for syscall, pagefault and mmap move by at
  most ±0.3% on hprx, which is within the control's ±0.45%, with one
  exception. lat_mmap ipo is +0.30% on both boxes and both combined kernels,
  so it is probably real but tiny: lat_mmap is unlock-heavy. rx2800's
  pagefault ipo is noisy in the control as well (CI ±4%).
- **Flagged wall-time changes** (rx2800 tlbbench +2.3%/+2.9%, lat_mmap
  +2.8%; hprx lat_mmap +4.0%/+3.0%, lat_pagefault +1.3%) are the same size as
  the control's (epic→generic lat_mmap −2.3% on both boxes, lat_syscall +2.0%,
  IPI +3.4%, hackbench +1.8%), and their per-op instruction counts didn't
  move. With two boots per kernel they can't be told apart from boot-to-boot
  layout effects.
- **lat_ctx (rx2800):** in every combined boot the fast mode is 0.07–0.09 µs
  slower than in every generic and epic boot, about +2%, or about 120
  cycles per round trip. That is the one Integrity cost that looks real. The
  per-switch path pays the dispatch in `ia64_send_ipi()` (reschedule IPI),
  `local_vector_to_irq()`/`irq_to_vector()` in the interrupt path, and
  the `mmiowb()` test in each unlock. It also carries the larger cold
  footprint. hprx can't resolve it.

## Altix (pople, Madison, no threads)

| metric | sn2only | sn2only→combined | sn2only→mvpda | combined→mvpda |
|--|--|--|--|--|
| readl (ITC/op) | 3722 | +0.00% | +0.81%† | +0.81%† |
| readl_relaxed | 3127 | +0.00% | −0.99%† | −0.99%† |
| IPI round trip | 4752 | +0.73% | +1.99%* | +1.26%* |
| tlbbench mprotect_far (ns) | 9890 | −0.95% | +0.23% | +1.19% |
| lat_ctx (µs) | 12.38 | **+2.50%*** | **+0.73%** | −1.73% |
| lat_syscall (µs) | 0.1677 | −0.95% | −0.48% | +0.48% |
| lat_pagefault (µs) | 1.337 | +0.45% | −0.80% | −1.25% |
| lat_mmap (µs) | 1182 | −0.13% | +0.42% | +0.55% |
| syscall / pagefault / mmap ipo | | +0.0 / −0.3 / +0.3% | +0.06 / −0.19 / −0.06% | |
| hackbench (s) | 20.0 | +0.28% [−2.3,+4.9] | −0.22% | −0.50% |

† Constant offsets with no spread, opposite in sign, on an undispatched
accessor: code alignment in that `mvbench.ko` build, not the kernel.

pople's lat_ctx is not bimodal (IQR 0.05 µs), so the median is usable.
combined's +2.5% comes with +2.2% instructions; mvpda's +0.7% comes with
+0.8%. The PDA `mmiowb` removed about 70% of the SN2 cost.

### fork / exec without perf inheritance (pople)

`MVB_ONLY="lat_proc lat_proc_exec"`, `perf stat -i` (counters on the parent
only), 20 reps per boot, 2 boots per kernel in ABCCBA order. Data in
`src/machvec/results-fork/pople/`.

| metric | sn2only | sn2only→combined | sn2only→mvpda |
|--|--|--|--|
| fork+exit (µs) | 417.2 | −0.34% [−0.78,+0.07] | −0.92% [−1.39,−0.31] |
| fork+execve (µs) | 439.8 | +0.03% [−0.30,+0.39] | +0.02% [−0.36,+0.40] |
| fork instructions (parent) | 8.062e8 | +0.01% | −0.02% |

fork and exec cost the same on all three Altix kernels. The TLB-purge
dispatch in `__flush_tlb_range()` doesn't show. This was not re-run on the
HPs, where lat_proc was excluded.

## Static size (HP config)

| | text | ia64_sn2_platform refs in vmlinux.o |
|--|--|--|
| hp-epic | 24,458,011 | 0 |
| hp-generic | 24,458,699 (+688 B) | 0 |
| hp-combined | 25,323,838 (+3.54%) | 5523 |
| hp-mvpda | 25,208,414 (+3.07%) | 539 |

Of combined's growth, about 174 KB is SN2 code and about 685 KB is growth in
1821 existing functions, typically +240 bytes. That growth is the inlined SN2
PIO-status wait loop placed after the return in every function that unlocks
a spinlock. It never runs on HP but takes up I-cache and TLB reach. The PDA
`mmiowb` removed the flag loads, but the cold loop is still there (+575 KB in
1795 functions).

## Conclusions and next steps

1. **Take the PDA `mmiowb` (`38c29fc484be`).** It is strictly better on both
   platforms. It boots on pople and on both HPs, with the same warnings as
   combined.
2. **Integrity's remaining cost is about 2% on a best-case context-switch round
   trip (rx2800)**, with no change in MMIO or the other paths. If that has to
   reach zero, the candidates are:
   - **Jump labels** (`HAVE_ARCH_JUMP_LABEL`). They remove the flag loads in
     `ia64_send_ipi()`, the IRQ/vector mapping and the I/O accessors. This is
     the deferred decision; this result is the evidence it asked for.
   - **Move the cold SN2 wait loop out of line** without costing leaf status,
     for example an asm stub reached by `br.cond` with a return in a scratch
     branch register, as the pre-2.6.26 ia64 spinlock contention path did.
     That would recover most of the 575 KB of cold text.
   - **A per-CPU copy of the platform flag** for the IPI/IRQ paths: one
     fixed-address load, like the PDA test.
3. Re-run lat_ctx with more boots, or as an in-kernel microbenchmark, to
   pin the 2% down. A firmware threads-off setting would remove the offline
   overhead.
4. Look at the perf inherited-counter exit cost (about 40 ms per child exit)
   and the missing sampling support in the ia64 PMU driver. Both belong to the
   upstream perf work, not this series.
