# SN2 on v7.2-epic3

Base: `v7.2-epic3` (linux-ia64). Previous version: `v7.1-epic2-sn2` / `v7.1-epic2-sn2-gpu`.

Tags (linux-sn2): `v7.2-epic3-sn2`, `v7.2-epic3-sn2-gpu` — boot-tested on hardware with the GPU tag (2026-09-27).

Method: cherry-pick of the v7.1 stack onto `v7.2-epic3`, plus two new SN2-layer commits for
upstream ia64 API changes.

## Layout

| Layer | Range | Commits |
|---|---|---|
| SN2 | `v7.2-epic3..v7.2-epic3-sn2` | the four v7.1 SN2 commits, then **sn2: timer: use VDSO_CLOCKMODE_MMIO for the SHub RTC clocksource**, **sn2: pci_dma: attach sn_dma_ops per device** |
| GPU | `v7.2-epic3-sn2..v7.2-epic3-sn2-gpu` | unchanged from v7.1 (6 commits, `git range-diff` identical apart from Kconfig context) |

## Conflicts

### drivers/misc/Makefile (SN2 layer, "Apply sn2 patch")

v7.2 removed the `apds990x` driver, whose Makefile line was the context above the
`CONFIG_SGI_IOC4` line. Resolution: drop the apds990x line, keep `ioc4.o`.

## Build breaks from upstream ia64 changes

### fsys_gettimeofday moved to generic VDSO data — `arch/ia64/sn/kernel/sn2/timer.c`

`2ed1b2025d3f` "ia64: Migrate fsys_gettimeofday to the generic VDSO time data" dropped
`ARCH_CLOCKSOURCE_DATA`, so `clocksource.archdata.fsys_mmio` no longer exists. The MMIO fast
path in `fsys.S` now dispatches on `vdso_clock_mode == VDSO_CLOCKMODE_MMIO` and loads the
counter through the global `ia64_fsys_mmio` pointer (same `ld8` + mask + cycle_last math as
before).

Fix: `sn2_rtc` gets `.vdso_clock_mode = VDSO_CLOCKMODE_MMIO` and `sn_timer_init()` sets
`ia64_fsys_mmio = RTC_COUNTER_ADDR` — the same conversion upstream applied to Cyclone and HPET.

Boot check: `cat /sys/devices/system/clocksource/clocksource0/current_clocksource` should be
`sn2_rtc`, and `gettimeofday()` should still be served by the fsyscall (no syscall fallback).

### Global dma_ops removed — `arch/ia64/sn/pci/pci_dma.c`

`38c09f598f62` "ia64/sba_iommu: attach per device instead of globally" deleted
`asm/dma-mapping.h` and the `dma_ops` global; ia64 now uses the generic `get_arch_dma_ops()`
(returns NULL). `sn_dma_init()` (`dma_ops = &sn_dma_ops`) no longer compiles, and a device
without ops would silently use `dma_direct`, handing raw physical addresses to the PIC/TIO.

Fix:
- `sn_dma_init()` → `sn_dma_set_ops(struct pci_dev *)`, doing `set_dma_ops(&dev->dev, &sn_dma_ops)`.
- Called from `sn_pci_fixup_slot()` right after the bus provider is chosen. Both PROM paths
  (`sn_io_slot_fixup`, `sn_acpi_slot_fixup`) go through it from `pcibios_fixup_bus()`, before
  driver probe.
- The `sn_dma_init()` call in `sn/kernel/setup.c` is removed.
- `IA64_SGI_SN2` now selects `ARCH_HAS_DMA_OPS`. Upstream only selects it via
  `IA64_HP_SBA_IOMMU`; without it `set_dma_ops()` is an empty stub and the failure would be
  silent.

`pcibios_bus_add_device()` (what sba_iommu now uses) was not an option: `sba_iommu.c` defines
it non-weak and is built in the SN2 config. sba does not claim SN2 devices — it only attaches
when `GET_IOC(dev)` is non-NULL.

Behavior change vs. v7.1: a PCI device that never went through `sn_pci_fixup_slot()` (no PROM
pcidev_info) now gets `dma_direct` instead of `sn_dma_ops`. Previously such a device would have
hit the `SN_PCIDEV_INFO` lookups in `sn_dma_*` with NULL info, so this is not a regression.

## Semantic checks on the GPU layer (applied cleanly)

- `amdgpu_uvd.c`: 7.2 UVD fixes (`32bd35f068a3`, `8002b744ad70`, size/dimension checks) add no
  new CPU stores into BO memory — only placement changes and message-parser reads. Older UVD
  now places the VCPU BO in VRAM only, which is the path the SN2 `writel` conversion covers.
- `ttm_pool.c`: `a3fdf74ffa59` "back up at native page order" changes the backup side only;
  restore still allocates through `ttm_pool_alloc_page()` (flushed).

## Known gap (pre-existing, not changed here)

TTM restore-from-backup (`ttm_pool_restore_commit()` → `ttm_backup_copy_page()`) writes page
contents through the WB mapping after the SN2 flush in `ttm_pool_alloc_page()` has already run,
leaving Modified lines on pages the GPU will DMA-read. Only reachable after the TTM shrinker has
backed buffers out to shmem under memory pressure. Present since the GPU work began (v7.0).

## Config

`sn2-kernel-tools/configs/7.2-epic-sn2-gpu.config` — `7.1-epic-sn2-gpu` + `olddefconfig`.
Notable: `ARCH_CLOCKSOURCE_DATA`/`GENERIC_TIME_VSYSCALL` → `HAVE_GENERIC_VDSO`/
`GENERIC_GETTIMEOFDAY`; `PERF_EVENTS=y` (new ia64 perf support); `NETFILTER_NETLINK` `m` → `y`;
several drivers removed upstream dropped out (apds990x, ATALK, some ISA arcnet / PCMCIA BT).

## Upstream items to watch

- `618e86355c42` "ia64: implement flush_tlb_kernel_range() properly" (in `v7.3-rc3-epic1`) —
  evaluate against the SN2 `VM_FLUSH_RESET_PERMS` module notifier at 7.3.
