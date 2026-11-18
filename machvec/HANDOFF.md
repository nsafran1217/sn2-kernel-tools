# SN2 runtime machvec — handoff (updated 2026-11-15)

Goal: one ia64 kernel that boots on both SGI Altix (SN2) and HP Integrity, with
no measurable cost on Integrity (any cost goes to SN2). Also an opt-in
`IA64_SGI_SN2_ONLY` build with no runtime cost, and the generic `SN2=n` build
identical to upstream. GPU-layer commits are excluded for now. `DESIGN.md` has
the design; `bench/README.md` has the measurement protocol.

## Upstream series (2026-11-17)

**Update 2026-11-17, later: 32 commits, tip `7e590d8bf8dd`** (GPU branch
`b606ad343b92`).  These differ from the tested `97a20e158fbc`/`797d21ba170c`
only in commit 20, where the message and the iomv.c comment now say the PIO
WC->UC fixup is untested on SHub2 and may not be needed there.  The SN2 platform
parts of the GPU work (branch `sn2-gpu-arch-move`) are now in the series:
the pcibr_dmamap_ate32() parenthesis fix is folded into "Restore DMA support
and the PIC bridge provider", and three new patches follow the Kconfig commit:
pfnmap WC->UC for PIO space (with an `ia64_is_sn2()` test so a combined
kernel leaves HP alone), the display-device flush in `sn_dma_map_phys()`, and
direct32 coherent allocations for display devices.  On `sn2-upstream-tree`
they are the scratch commits "SCRATCH: patch ..."; `mkseries.py` gained
`patch(..., scratch="<subject>")` for patches that split a restored file
(an earlier owner gets the file as it was before the first scratch commit;
any other commit touching the file afterwards is an error).  Branch
`sn2-upstream-gpu` (worktree `src/machvec/wt-gpu`) = `sn2-upstream` + the
three DRM commits (TTM WC, r300 MC 0, UVD memset_io), which stay out of the
PR.  That tree booted on pople as `mv-gpu` (ELILO label) and passed three
glmark2 passes with PIC prefetch cleared by hand.  The 32-commit tip booted on
pople 2026-11-17: `mv-combined` cold and `mv-sn2only` by reboot, both "platform
SN2", kernel err/warn identical to the 0796 boot (sn2only adds two systemd
pids.max lines), PLX window kept, DVD found, SATA 129-132 MB/s, mspectest
PASSED, snsc l2cmd answers.  combined was `degraded` only because the
`xfs_scrub_all` timer fired after downtime and its script lacks python dbus.
`check-series.sh` at `97a20e158fbc` (2026-11-17): every commit builds, generic
up to commit 18 and combined from 19 on; the only warnings are the 6
`-Wunused-value` ones in `drivers/scsi/dc395x.c` (not ours).  Log:
`src/machvec/check-series-97a2.log`.
Notes in `src/machvec/stage/pople-97a2/`.  elilo default back to `test`.
HP and bohr not re-run at this tip.

**GPU branch `797d21ba170c` (series + 3 DRM commits), 2026-11-17:** pople
`mv-gpu` combined: UVD IB test passes, glmark2 1715/1608/1621, 6.43M fences,
no ATE exhaustion (prefetch cleared by hand).  rx2800 `hp-gpu` grub entry
(hp-combined config): "platform generic", PCI state as the 0796 kernel
(MSI data and one SlotPowerLimit differ); amdgpu on its RX 550 (Lexa):
IB tests pass, SDMA benchmarks at forced `high` clocks and an on-screen
glmark2 equal to 0796 and 7.2.8-t2 (3594 / 3582 / 3552).  Notes in
`src/machvec/stage/rx2800-gpu/` (`gputest.sh` there).  rx2800 is back on
`default=0`.

amdgpu SDMA benchmarks (debugfs `amdgpu_benchmark`, forced `high` clocks,
1 MB moves): pople GTT->VRAM 68 MB/s with PIC prefetch cleared, 178 MB/s
with it on (PROM default); VRAM->GTT 204 MB/s either way; VRAM->VRAM
6.4-6.5 GB/s.  rx2800 RX 550: 2595 / 1506 / 9039 MB/s.  pople's sweep levels
off at 74 MB/s (prefetch cleared) from 512 KB moves up.  Benchmark 3 (the
sweep) takes about 30 min on pople and can't be interrupted (the writer
sits in D state in dma_fence_default_wait); only a reboot stops it.
Results in `src/machvec/stage/pople-97a2/gpu-bench*.txt`.

The SN2 layer and this work are re-split into one series for a linux-ia64
PR: branch `sn2-upstream` (29 commits on `master-epic` `076c06dc04ba`,
tip `0796593e51a6`), worktree `src/machvec/linux-sn2-upstream` (kept on
that branch for reading).  It is generated: fix code on the scratch branch
`sn2-upstream-tree` (worktree `src/machvec/linux-sn2-tree`), then run
`src/machvec/mkseries.py` (patch list and messages in `series-def.py`).
`build-up.sh <mode> [rev]` builds in a per-mode worktree (`wt-<mode>`;
ia64 can't build with `O=`), `check-series.sh` builds every commit.
Draft PR text: `PR-sn2-upstream.md` here.

Tree changes against `bed7d1f396b3`: SN2 prototypes in `asm/machvec.h`
(no `#ifdef`/`extern` in generic ia64 C files), `acpi_arch_init()` instead
of the `drivers/acpi/bus.c` hunk, all SN2 driver options in
`drivers/sn/Kconfig`, missing-prototype and readq `-Wformat` warnings
fixed, dead `sn_irq_to_vector()`/`sn_local_vector_to_irq()` dropped (their
range check is in the inline `irq_to_vector()`), the `ZONE_DMA32` ifdefs
dropped.  Every commit has `Assisted-by` (fable-5-2; plus opus-5-5 on the
dispatch commits, opus-4-8 on pata_sgiioc4) and `Signed-off-by`.

Tested at `0796593e51a6`: every commit builds (generic to the Kconfig
commit, combined after); zero warnings in SN2 code.  rx2800 and hprx boot
`hp-combined` to `running`, "platform generic", PCI state as stock
7.2.8-t2 (rx2800: only AER `AdvNonFatalErr` mask bits differ, not checked
against plain 7.3); both back on `default=0`.

**pople tested at `0796593e51a6` (2026-11-17):** `mv-combined` (cold, from
ELILO prompt) and `mv-sn2only` (ssh reboot) both log `ia64: platform SN2`;
kernel err/warn lines identical to the `d823bb10ed72` boot apart from
systemd cgroup `pids.max` noise; PLX prefetch window `10000000-1fffffff`
kept; direct SATA reads 128–133 MB/s on sda/sdb; pata_sgiioc4 finds the
DVD; mspec loads (`/dev/sgi_fetchop`, `mspec_{cached,uncached}`).
sn2only reached `running`; combined was `degraded` only because
`fwupd-refresh` (fwupdmgr SIGABRT, also on `d823bb10ed72` and older
kernels) and `systemd-sysupdate-reboot` timers fired after the box sat
off overnight.  Notes in `src/machvec/stage/pople-0796/`.
Driver tests (same day, both kernels): mspec (`driver-tests/mspectest.c`,
1000 rounds + fetchop AMOs) passes; snsc works with the reconstructed SGI
`l2cmd --scdev /dev/001c02^0#0` (L1/L2 commands, `env test warning` event
reaches dmesg); mbcs registers on the tiocx bus, but there is no TIO
hardware to bind to.  See `driver-tests/README.md`.
**bohr** (Altix 3700, IO9 with QLogic ISP12160 + a second ISP12160 card, PROM 4.53,
4 CPUs, 7 GB; `ssh root@bohr`) netboots the same elilo.conf and NFS root as pople.
`qla1280` read-only test (`driver-tests/qlatest.sh`) on the GPU-layer kernel
54fa0bee3040, mv-combined and mv-sn2only: same throughput (Compaq 79, Maxtor 68 MB/s
sequential), identical repeat-read checksums, no SCSI errors.  Both disks are on
host0 channel 0, so vchan 1 isn't exercised.  sd names swap between boots.
Results in `src/machvec/stage/bohr-*`.  bohr was left on mv-sn2only, elilo default `test`.  PR text TODO
rows filled.  elilo `default` back to `test`.  Not pushed.

## Where things are

| What | Where |
|--|--|
| Kernel branch | `sn2-machvec-7.3` in `src/mainline/linux-sn2`, worktree `src/machvec/linux-sn2-7.3`, on `master-epic-sn2` (`641358e48ce9`, since 2026-11-15) |
| Mode configs | `sn2-kernel-tools/configs/7.3-epic-sn2-combined.config`, `7.3-epic-generic.config` (gcc 16.2); working copies in `src/machvec/cfg/` |
| Build/collect helper | `src/machvec/build-matrix.sh` (`deploy <mode>`, `base <name> <rev> <mode>`, `collect`) |
| Build artifacts for static comparisons | `src/machvec/artifacts/{combined,sn2only,generic,sn2base,upstream}` |
| Toolchain | `tools/gcc-16.2.0-nolibc/ia64-linux` (gcc 16.2.0 + binutils 2.47 with T2's ia64 patches), built by `sn2-kernel-tools/build-cross-gcc.sh`; select it with `IA64_GCC_VERSION=16.2.0` |
| Bench harness | `machvec/bench/` (see its README); installed on the shared NFS root at `/opt/machvec-bench` (the target's `/root` is not writable from the boot server) |
| Bench sources (lmbench, hackbench) | `src/machvec/benchsrc/`, copied to `/opt/machvec-bench/src` and built there by `mvbench-setup.sh` (already done) |
| Old patches (7.0 series, jump-label attempt) | `machvec/OLD/` |

### Rebase onto master-epic-sn2 `641358e48ce9` (2026-11-15)

`master-epic-sn2` had moved to a newer linux-ia64 `master-epic` (perf PMU,
lazy-mm TLB fix) and gained seven SN2 commits (ACPI table/namespace
ordering, bridge windows without ACPI IO, sgi-agp, the VGA console's I/O
space).  The series applied cleanly; the pre-rebase head is kept as branch
`sn2-machvec-7.3-pre-rebase-20261115` (= `origin/sn2-machvec-7.3`,
`1c1ece802bde`).  Four of the new hooks in generic code were
compile-time only and are now `ia64_is_sn2()` tests, folded into
"test the platform at run time in the arch init hooks":

- `pcibios_fixup_bridge_resources()`: `!SN_ACPI_BASE_SUPPORT()` is true on
  HP (`sn_acpi_rev` = 0), so a combined kernel would have claimed no bridge
  windows on Integrity.
- `setup_arch()` → `sn_set_io_os_features()`: SN SAL calls on HP firmware.
- `new_space()`: skipping `io_space[0]` would change HP's I/O space layout.
- `acpi_init()` → `sn_io_acpi_init()`: harmless on HP (returns early), guarded
  for consistency.

HEAD (`bed7d1f396b3`) builds (vmlinux + modules, gcc 16.2) in combined,
sn2only and generic; intermediate commits weren't rebuilt.

**Boot-tested on pople 2026-11-16** (1 C-brick + 001r10, PROM 4.56, legacy
IO path, gcc 16.2): `mv-combined` (`7.3.0-epic1-SN2-MV-bed7d1f396b3-ia64`,
from power-off) and `mv-sn2only` (`…-SN2-ONLY-bed7d1f396b3-ia64`, reboot)
both reach `running` with no failed units, log `ia64: platform SN2`, keep
the PLX prefetch window `0x10000000-0x1fffffff`, and have identical kernel
err/warn lines (only systemd cgroup noise differs).  Direct SATA reads
130 MB/s and an NFS fsync write 45 MB/s on both.  elilo `default` is back
to `test`.

**rx2800 2026-11-16:** `hp-combined` (`7.3.0-epic1-HP-MV-bed7d1f396b3-ia64-gbed7d1f396b3`,
`cfg/hp-combined.config`) boots to `running`, logs `ia64: platform generic
(ACPI OEM ID 'HP    ')`, and against stock 7.2.8-t2 has identical `lspci`,
all 32 bridge-window lines, and the same PCI ranges in `/proc/iomem` and
`/proc/ioports` (only kernel size, `.auto` instance numbers and NIC naming
order differ).  The igb `msi_domain_free_descs` WARNING (msi.c:214) is
pre-existing in 7.2.8-t2 too.  rx2800 is back on `default=0` (7.2.8-t2).
**hprx not tested.**  Force-pushed to `origin/sn2-machvec-7.3` 2026-11-16 (was `1c1ece802bde`).  The 71 `-Wformat` warnings in octeon_ep under
sn2only are pre-existing: `___sn_readq()` returns `unsigned long`, not
`u64`, in the SN2 layer too.

### Commit series before the rebase (all build in all three modes)

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

- ~~Whether to make gcc 16.2 the default in `setup_cross.sh`~~: done 2026-11-15;
  `IA64_GCC_VERSION=14.2.0` gets the old one back.
- Jump labels: deferred until the benchmarks show a need.
- GPU layer: its `#ifdef CONFIG_IA64_SGI_SN2` hunks in ttm/drm/amdgpu must
  become runtime tests before it can sit on this series.
- Once the series is tested: fold it into `master-epic-sn2`, update the tags
  and the `diff/sn2-7.3/` patches, per the porting procedure.
