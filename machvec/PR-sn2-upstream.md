<!--
Draft PR description for linux-ia64, branch sn2-upstream (tip 7e590d8bf8dd,
32 commits, 2026-11-17).  Testing below was at 97a20e158fbc, which differs
only in commit 20's message and an iomv.c comment (SHub2 note).  Before submitting:
  - pople rows re-checked at this tip on 2026-11-17 (mv-combined cold,
    mv-sn2only by reboot; notes in src/machvec/stage/pople-97a2/).  The HP
    and bohr rows are from 0796593e51a6, the 29-commit tip, which differs
    only in commits 20-22 (SN2-only code) and the pcibr fix.  The GPU rows (pople,
    rx2800) are this tree plus three DRM commits (branch sn2-upstream-gpu,
    797d21ba170c), retested 2026-11-17; notes in src/machvec/stage/.
  - Per-commit build check passed at 97a20e158fbc on 2026-11-17 (only
    dc395x's -Wunused-value warnings; src/machvec/check-series-97a2.log).
Everything below this comment is the PR text.
-->

# ia64: Restore SGI SN2 (Altix) support, detected at run time

This brings back the SGI SN2 platform (Altix 3000/4000/350/450, Prism),
removed in v5.4, together with the drivers an Altix needs to be usable.

Before v5.4 one kernel could run on several ia64 platforms through machine
vectors, which went away with SN2. This series does not bring machine
vectors back. SN2 is the only platform left that needs more than the
generic code, so there is one predicate, `ia64_is_sn2()`, and the generic
code tests it in the places the machine vector used to cover.

## Build modes

| Config | `ia64_is_sn2()` | Boots on |
|--|--|--|
| `IA64_SGI_SN2=n` | constant `false` | everything but SN2 (as today) |
| `IA64_SGI_SN2=y` | a `__read_mostly` bool set at boot | SN2 and everything else |
| `IA64_SGI_SN2=y`, `IA64_SGI_SN2_ONLY=y` | constant `true` | SN2 only |

- Without `IA64_SGI_SN2` the SN2 branches are discarded at compile time.
  The callers need no `#ifdef`: the SN2 entry points are declared in
  `asm/machvec.h` in every configuration and the dead calls are dropped.
- `IA64_SGI_SN2_ONLY` is for people who only run Altix hardware and want
  no run time tests. It panics early, with a clear message, on anything
  else.
- The platform is detected in `setup_arch()` from the ACPI XSDT OEM ID
  ("SGI", and not "UV"), before the early console, which already needs
  the answer.

The flag is a plain bool and not a static key. ia64 has no
`HAVE_ARCH_JUMP_LABEL`, so `static_branch_unlikely()` is an
`atomic_read()`, and gcc emits that volatile load as `ld4.acq` at every
one of several thousand I/O accessor call sites.

## How the series is laid out

32 commits, 122 files, about 30,450 lines, nearly all of it restored code.

| Commits | What |
|--|--|
| 1–2 | `ia64_is_sn2()` and platform detection; the uncached allocator |
| 3–12 | The SN2 platform code under `arch/ia64/sn` and `asm/sn`, split by area. Nothing builds it yet. |
| 13–18 | The hooks in generic ia64 code, already in their run time form |
| 19 | `IA64_SGI_SN2`, `IA64_SGI_SN2_ONLY` and the Makefiles: SN2 becomes buildable here |
| 20–22 | New SN2 behaviour: PIO space is never mapped write-combined, and display devices get cache flushes and direct32 coherent memory |
| 23–32 | Drivers, one commit each |

Each restore commit names the commit it reverts and lists what differs
from the code that was removed, so it can be reviewed as "the 5.3 code
plus this list". The bulk comes from cf07cb1ff4ea ("ia64: remove support
for the SGI SN2 platform"); the drivers each had their own removal commit.

Every commit builds: without SN2 up to commit 18, and with it from 19 on.

## What it touches outside the SN2 files

Generic ia64 (existing files): 19 files, +399/−17. Of that, 192 lines are
the accessor dispatch in `asm/io.h` and 34 are `asm/mmiowb.h`; the rest
are one- to ten-line hooks.

Outside `arch/ia64`, existing files:

| File | Change |
|--|--|
| `drivers/scsi/qla1280.[ch]` | +36: the SN2 DMA workarounds, as removed in f877a786b1dd |
| `drivers/scsi/qla2xxx/qla_init.c` | +18: the SN2 NVRAM defaults, as removed in 42ab658fccb6 |
| `drivers/{char,char/agp,misc,tty/serial,ata}/Makefile` | one line per restored driver, 9 in all |
| `include/linux/pci_ids.h` | `PCI_DEVICE_ID_SGI_IOC4` |
| `Documentation/driver-api/index.rst` | the restored `sgi-ioc4` page |

Two things were done to keep that list short, since every line here is a
possible conflict on the next mainline merge:

- All the SN2 driver options are in a new `drivers/sn/Kconfig`, sourced
  from `arch/ia64/Kconfig`, instead of the Kconfig files of the subsystems
  the drivers used to be configured in.
- ACPI: the SN2 I/O setup runs from `acpi_arch_init()`, the existing arch
  hook in `acpi_init()`. `drivers/acpi` is not touched.

Both qla hunks are inside `#ifdef CONFIG_IA64_SGI_SN2` and test
`ia64_is_sn2()`, so they do nothing on other hardware.

## Drivers

Restored: `sn_console` (the L1 console, the only console an Altix has),
`snsc`, `mspec`, `mbcs`, `sgi-agp`, the IOC4 base driver, `ioc4_serial`,
and the SN2 support in `qla1280` and `qla2xxx`.

New: `pata_sgiioc4`, a libata driver for the IOC4 ATA channel (the DVD
drive). The driver it replaces, `drivers/ide/sgiioc4.c`, cannot come back
because the IDE layer is gone.

Not restored:

- IOC3 (`drivers/sn/ioc3.c` and `ioc3_serial`). On SN2 it was only an
  add-in PCI serial card; the IOC3 is mainly a MIPS-era part.
- `sgi-xp` (XPC/XPNET, cross-partition messaging). It needs a machine
  partitioned into at least two partitions, each with its own base I/O
  brick, which I can't test, and there's likely no demand for it. The
  whole driver left mainline in 5.3, so restoring it would mean bringing
  back all of it, not just an SN2 backend.
- `sgi_hotplug` (PCI hot-plug). These machines no longer run anything that
  can't be shut down to swap a PCI card.

## Fixes that are part of the restore

These are bugs the code had, or would have had on a current kernel. They
are called out in the commit messages.

- **PROMs with ACPI I/O support came up without PCI.** The hubs were looked
  up before `acpi_init()` had loaded the namespace. Fixed by the
  `acpi_arch_init()` call, and by announcing ACPI support to the PROM
  before the first `acpi_table_init()` instead of parsing the tables twice.
- **DMA operations are per device.** ia64 has no global `dma_ops` any more;
  a device that misses the SN2 ones silently uses `dma_direct` and hands
  the bridge untranslated addresses.
- **`MAX_DMA_ADDRESS`** is the top of the PIC bridge's direct-mapped 32-bit
  window, so that `ZONE_DMA32` means what drivers expect. A PIC has only
  1024 address translation entries (16 MB).
- **Two hooks lost with the machine vector** are back: the timer tick hook
  (SHub 1 lost interrupt workaround) and the PIO write drain when a task
  migrates.
- **`sgi-agp`**: enables AGP on the card, accepts the memory types TTM
  binds, and no longer uses a list iterator after its loop.
- **`pcibr_dmamap_ate32()`** applied `SN_DMA_ADDRTYPE()` to the result of
  a comparison, so a physical address passed with any other flag went
  into the ATE untranslated. No caller did that before commit 22.
- The SN2 code and drivers build without warnings (about 35
  `-Wmissing-prototypes` and a `-Wformat` in every `readq()` user are gone).

## New behaviour for PIO mappings and display devices

Commits 20–22 are not restores. They change what SN2 does, and only on
SN2:

- **Write-combined pfn mappings of PIO space become uncached.** SHub 1
  turns a coalesced WC write to PIO space into a memory request and the
  machine hangs. TTM asks for WC on a GPU's VRAM BAR, and so do fbdev and
  the sysfs `resourceN_wc` files. ia64 implements
  `pfnmap_setup_cachemode()` when SN2 support is built; on other machines
  it returns at the `ia64_is_sn2()` test. It applies on SHub2 too but is
  untested there: SHub2 has write-combining request types that SHub1
  lacks, so it may not need it.
- **Display-class devices get their pages flushed from the CPU caches
  when DMA-mapped.** Modified lines that a GPU reads by DMA turn into
  RDEXC interventions, which can overflow the FSB into an MCA.
- **Display-class devices get coherent memory from the PIC's direct32
  window** instead of from its 1024 ATEs, which TTM's `dma_alloc` path
  exhausts.

These are what a GPU needs from the platform. Running one also needs a
change to `ttm_io_prot()` on SN2, which is not part of this PR.

## Cost on non-SN2 hardware

With `IA64_SGI_SN2=y`, each port I/O, `readX()`, IPI and IRQ/vector lookup
has a load of the flag, a compare and a branch that is predicted not
taken. `mmiowb()` tests a per-CPU pointer instead, to keep `spin_unlock()`
paths leaf functions.

Measured on an earlier revision of this work with the same dispatch code,
against a kernel without SN2 support, same config and compiler:

- rx2800 i2 (Itanium 9340) and a Montecito system: lmbench, hackbench and
  MMIO/port I/O microbenchmarks show no change outside the noise, except
  the best case context switch round trip on the rx2800, about 2% slower.
- Kernel text grows by about 3% with a distribution style config, mostly
  the SN2 code itself and the inlined (cold) SN2 `mmiowb()` wait.
- On an Altix 350, the default SN2 kernel is about 0.7% slower than an
  `IA64_SGI_SN2_ONLY` one on the same context switch test.

Jump labels would remove the flag loads, but that is separate work for
all of ia64 and the numbers above don't seem to justify it yet.

## Testing

Compiler: gcc 16.2.0 with binutils 2.47.

| Machine | Kernel | Result |
|--|--|--|
| hp Integrity rx2800 i2 | `IA64_SGI_SN2=y` | boots, "platform generic"; `lspci -vv`, `/proc/iomem`, `/proc/ioports` and all 32 bridge windows match 7.2.8 |
| same, Radeon RX 550 | `IA64_SGI_SN2=y`, this series plus the `ttm_io_prot()` change | bridge windows and PCI state as the 29-commit revision; amdgpu SDMA move benchmarks and an on-screen glmark2 pass (3594) are the same as on that revision (3582) and on 7.2.8 (3552) |
| HP Montecito system (hprx) | `IA64_SGI_SN2=y` | boots, "platform generic"; PCI state matches 7.2.8 |
| Altix 350, 1 C-brick + I/O brick, PROM 4.56 | `IA64_SGI_SN2=y` | boots, "platform SN2"; kernel warnings same as the pre-series tree, PLX bridge window kept, SATA reads 133 MB/s, pata_sgiioc4 finds the DVD, mspec loads |
| same | `IA64_SGI_SN2_ONLY=y` | same results |
| Altix 350 as above, Radeon Oland behind a PLX 8112 | `IA64_SGI_SN2=y` plus the `ttm_io_prot()` change | amdgpu loads, UVD IB test passes; three on-screen glmark2 passes (1719, 1606, 1620), 6.5 million gfx fences, no "out of ATEs", no SHub errors. PIC read prefetch was turned off by hand for the GPU's slot; with it on, the GPU can be fed stale ring data and hang (separate work). |
| Altix 3700, IO9, PROM 4.53, 4 CPUs | `IA64_SGI_SN2=y` and `IA64_SGI_SN2_ONLY=y` | boots, "platform SN2"; `qla1280` binds both ISP12160s with the SN2 workarounds, two Ultra160 disks; O_DIRECT read throughput and checksums same as the pre-series kernel |

Not tested:

- A PROM with ACPI I/O support. The Altix 350 here uses the legacy I/O
  path, so `sn_io_acpi_init()` returns early on it.
- TIOCA/TIOCE hardware, SHub 2, multi-partition systems.
- `sgi-agp` and `qla2xxx` were built but not exercised in this run.
  `qla1280` was tested only with disks on SCSI channel 0, so its
  channel 1 virtual-channel path (`sn_pci_set_vchan()`) was not exercised. `mbcs` registers on the tiocx bus, but this machine has no TIO FPGA
  for it to bind to.

Exercised on the Altix 350 with both kernels: `mspec` (cached, uncached
and fetchop mappings, page zeroing on unmap, fetchop AMOs including
concurrent increments from 4 processes), and `snsc`. For `snsc`, a rebuild
of SGI's `l2cmd` was used: it sent L1 and L2 commands through the
`/dev/snsc` device and got multi-chunk responses. An L1 `env test warning`
event was delivered to the kernel log.
<!-- Nathan: correct this list; I only checked sn_console, IOC4,
ioc4_serial probing, pata_sgiioc4 and mspec on pople. -->

## Known leftovers

- `sn_kernel_launch_event()`, `sn_dma_set_mask()` and the
  `sn_pci_legacy_*()` functions were reached through the machine vector
  and have no caller now. They are kept, with prototypes, rather than
  deleted. Legacy PCI access in particular is left unhooked on purpose.
- `ia64_mca_register_cpev()` is no longer static, also without SN2
  support, so it is no longer inlined into its one generic caller. On an
  earlier revision that was the only code difference in a kernel built
  without SN2 (+169 bytes, a cold path); not re-measured at this tip.
- The rest of GPU support on Altix is not part of this PR: the
  `ttm_io_prot()` change mentioned above, and turning off PIC read
  prefetch for display devices.
- Commit 21's `dma_map_page()` flush has not carried GPU buffers yet: on
  the Altix 350 tested, TTM takes its pages from `dma_alloc_coherent()`.
