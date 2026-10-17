# SN2 runtime machvec — handoff (updated 2026-10-16)

Goal: one ia64 kernel that boots on both SGI Altix (SN2) and HP Integrity, with
no measurable cost on Integrity (any cost goes to SN2). Also an opt-in
`IA64_SGI_SN2_ONLY` build with no runtime cost, and the generic `SN2=n` build
identical to upstream. GPU-layer commits are excluded for now. `DESIGN.md` has
the design; `bench/README.md` has the measurement protocol.

## Where things are

| What | Where |
|--|--|
| Kernel branch | `sn2-machvec-7.3` in `src/mainline/linux-sn2`, worktree `src/machvec/linux-sn2-7.3`, on `master-epic-sn2` (`9d2082de92b7`) |
| Mode configs | `sn2-kernel-tools/configs/7.3-epic-sn2-combined.config`, `7.3-epic-generic.config` (gcc 16.2); working copies in `src/machvec/cfg/` |
| Build/collect helper | `src/machvec/build-matrix.sh` (`deploy <mode>`, `base <name> <rev> <mode>`, `collect`) |
| Build artifacts for static comparisons | `src/machvec/artifacts/{combined,sn2only,generic,sn2base,upstream}` |
| Toolchain | `tools/gcc-16.2.0-nolibc/ia64-linux` (gcc 16.2.0 + binutils 2.47 with T2's ia64 patches), built by `sn2-kernel-tools/build-cross-gcc.sh`; select it with `IA64_GCC_VERSION=16.2.0` |
| Bench harness | `machvec/bench/` (see its README); installed on the shared NFS root at `/opt/machvec-bench` (the target's `/root` is not writable from the boot server) |
| Bench sources (lmbench, hackbench) | `src/machvec/benchsrc/`, copied to `/opt/machvec-bench/src` and built there by `mvbench-setup.sh` (already done) |
| Old patches (7.0 series, jump-label attempt) | `machvec/OLD/` |

### Commit series (all build in all three modes)

Rebased onto `master-epic-sn2` and rewritten as a clean series on
2026-10-16 (old head `2b40e700a6a3`; same final tree as after the rebase):

```
1c1ece802bde sn2: test the platform at run time in qla1280, qla2xxx and mspec
6bdf781128b8 sn2: dispatch mmiowb() and the IRQ/vector mapping at run time (PDA test folded in)
2132a274c0b9 sn2: dispatch port I/O and readX() at run time
69b26039c1a5 sn2: dispatch IPIs and global TLB purges at run time
bb842f2924b3 sn2: test the platform at run time in the arch init hooks (incl. sn_timer_interrupt())
b2c2d8e11057 sn2: add runtime platform detection and IA64_SGI_SN2_ONLY
b9638f628a2a sn2: replace ia64_platform_is() with ia64_is_sn2()
85fcb2d20a24 make zone_dma32 work ... (cherry-pick of GPU-layer 8f8f9696915e: SWIOTLB/ZONE_DMA32 + SN2 MAX_DMA_ADDRESS)
```

Changed since the 13th (fcfc4050317a → 795f2c81aacb): `pda_percpu` is now
exported. Modules reference it through the inlined `mmiowb()`, so the
combined modpost had failed. Nothing is pushed or tagged.

### Tooling in `sn2-kernel-tools`

- `ia64-build.sh`: `KSRC=<tree>` builds a tree other than the main one;
  `DEPLOY="netboot <host>..."` picks the targets (`netboot` is the default,
  a host name installs on a grub-booted HP box through `deploy-host.sh`,
  `none` deploys nothing). The release string is computed after the build:
  before, it came from the previous build's `include/config/kernel.release`,
  so after a config change `System.map-<release>` was uploaded under the
  wrong name.
- `setup_cross.sh`: `IA64_GCC_VERSION` picks the toolchain (default still
  14.2.0); `build-cross-gcc.sh` builds the gcc 16.2 one with T2's patches.
- `deploy-host.sh` / `boot-host.sh`: install a kernel on an HP box as a grub
  menu entry, and boot an entry.
- `machvec/bench/`: the benchmark harness (see its README); `RESULTS.md` has
  the results. `configs/7.3-epic-{sn2-combined,generic}.config` are the
  mode configs.

## Boot server (10.40.0.121)

| elilo label | Kernel | Release |
|--|--|--|
| `mv-combined` | `vmlinuz-mv-combined` | `7.3.0-rc3-epic1-SN2-MV-51de71278c87-ia64` |
| `mv-sn2only` | `vmlinuz-mv-sn2only` | `7.3.0-rc3-epic1-SN2-ONLY-51de71278c87-ia64` |
| `mv-generic` | `vmlinuz-mv-generic` | `7.3.0-rc3-epic1-GENERIC-13e814547f54-ia64` (same generic code as HEAD) |

- The `mv-*` entries copy the `test` label's options (`panic=0` etc.).
  `elilo.conf` was backed up first as `elilo.conf.bak-20261016-100523`.
- **Kernels are selected by changing `default=` in `elilo.conf`.** All three
  machines read the same file, so the default applies to whichever boots
  next. `bench/ab-pople.sh` changes it, and leaves it at the last label it
  booted.
- `mvbench.ko` is installed for all three releases under
  `/opt/machvec-bench/mvbench/<release>/`.
- Superseded module dirs from the 13th that can be deleted:
  `lib/modules/7.3.0-rc3-epic1-SN2-GPU-13e814547f54-ia64`,
  `…-SN2-ONLY-13e814547f54-ia64`, `…-SN2-MV-7c8159e85598-ia64` and
  `…-SN2-ONLY-7c8159e85598-ia64`.

## Hardware

- pople has **1 C-brick (001c02) + I/O brick 001r10** since 2026-10-16: 2
  CPUs, 3.8 GB, 1 node. The L2 is nl4r
  (`ALTIX_L2_HOST=nl4r ALTIX_L2_PORT=23 ALTIX_IST_L2=nl4r`).
- **perf is not installed** in the NFS root; the user will install it. Until
  then results have no cycle or instruction counts. fio and iperf3 are also
  missing (`t2 inst fio iperf`).
- rx2800 and hprx have not been powered up yet.

## Results so far

### Boot tests on pople (2026-10-16)

- **`mv-combined`: boots** (156 s from power-off). It logs
  `ia64: platform SN2 (ACPI OEM ID 'SGI')`. Its err/warn lines are identical
  to the last 7.3 GPU-kernel boot (20261010-204153), apart from the expected
  `drm` modprobe line. The 7 swiotlb "Failed to allocate … tlb structure"
  lines were already there (they come from the adopted SWIOTLB/ZONE_DMA32
  commit on a 3.8 GB, 1-node box).
- **`mv-sn2only`: boots** (121 s reboot), with the same warnings.
- Smoke run of the full bench suite on combined (3 reps): everything works.
  `is_sn2` costs 3.00 ITC cycles per op against 1.33 for an empty loop.
  `readl` on the tg3 is about 3720 cycles, `readl_relaxed` about 3127, and an
  IPI round trip about 4650.

### Static (gcc 16.2)

- **Generic (`SN2=n`) vs upstream `v7.3-rc3-epic1`:** +169 bytes. The only
  real difference comes from the existing SN2 layer: `ia64_mca_register_cpev`
  is non-static unconditionally, so it's no longer inlined into
  `ia64_mca_late_init`. That's a cold path; it could be made static when
  `!CONFIG_IA64_SGI_SN2`.
- **SN2-only vs the SN2 layer (`bb527618b1e4`):** the only differences are
  init code and removal of the dead `__sn_*` wrappers.
- **Combined vs generic:** text is 30.19 MB against 28.98 MB (+4.2%):
  - SN2 code itself, about 375 KB;
  - 3751 flag tests in vmlinux and about 19.6k in modules;
  - the inlined SN2 `mmiowb` wait in every unlock site, about 460 KB of cold
    code.
- **98 functions lost leaf status** on HP: MMIO and port-I/O users (the SN2
  `readX` path calls `sn_dma_flush`), plus `irq_complete_move` (inlined
  `ia64_send_ipi`, one `alloc` per interrupt). Spin-unlock paths are leaves
  again.
- **The static key was a bad fit without jump labels.** Every site was an
  `ld4.acq`; it is now a plain `__read_mostly bool`.
- **Driver and console fixes:** qla1280, qla2xxx and mspec now test the
  platform at run time. The stray `return 0` in `early_console_setup()` is
  fixed.

## Status (2026-10-16 evening)

**Benchmarks are done; see `RESULTS.md`.** In short:
- Integrity: no measurable change except about +2% on the best-case
  context-switch round trip on rx2800 (hprx can't resolve it).
- Altix: combined costs +2.5% on lat_ctx; the PDA `mmiowb` (measured as
  `38c29fc484be`, now folded into `6bdf781128b8`) brings that to +0.7%.
  fork and exec are unchanged.
- Combined HP text is +3.1% (hp-mvpda), mostly the cold inlined SN2 PIO wait.

State of the boxes:
- rx2800 and hprx are back on `default=0` (7.2.8-t2), with all CPUs online.
  Their grub entries hp-epic, hp-generic, hp-combined and hp-mvpda stay
  installed. HP results are in `/opt/machvec-bench/results` there, and the
  invalid CGMT run is in `results-cgmt-20261016`.
- pople's elilo `default` is `mv-sn2only`, the last loop's label. `mv-mvpda`
  was added (backup `elilo.conf.bak-20261016-144337`).

## Next steps

1. Decide on the remaining Integrity cost (RESULTS.md, "Conclusions"):
   jump labels, an out-of-line cold SN2 wait via a `br.cond` stub, or a
   per-CPU flag for the IPI/IRQ paths.
2. Optionally: threads off in HP firmware; more lat_ctx boots, or an
   in-kernel context-switch microbenchmark.
3. Two SN2-layer bugs found during review (lost 5.4 machvec hooks: timer
   tick / SHub1 lost-interrupt WAR, and PIO drain on migration), boot-tested
   on pople: `sn2-kernel-tools/diff/sn2-7.3/lost-hooks.md`, patches in
   `lost-hooks/`; now in `master-epic-sn2` (`e13906a6780a`, `9d2082de92b7`).
   Legacy PCI is left unhooked on purpose (restoring it MCAs). This series
   is rebased onto them, with the timer call made an `ia64_is_sn2()` test.
4. Housekeeping: obsolete module dirs on the boot server (SN2-GPU-13e8,
   SN2-ONLY-13e8, SN2-MV-7c81, SN2-ONLY-7c81). Reset pople's elilo default
   once you've chosen the test kernel.

## Open decisions

- Whether to make gcc 16.2 the default in `setup_cross.sh` (it affects the GPU
  tree's builds too).
- Jump labels: deferred until the benchmarks show a need.
- GPU layer: its `#ifdef CONFIG_IA64_SGI_SN2` hunks in ttm/drm/amdgpu must
  become runtime tests before it can sit on this series.
- Once the series is tested: fold it into `master-epic-sn2`, update the tags
  and the `diff/sn2-7.3/` patches, per the porting procedure.
