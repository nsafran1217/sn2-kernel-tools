# SN2 Re-addition Patches for Linux v5.5

Split into 6 patches, ordered for sequential application.

## Application Order

```
0001-ia64-sn2.patch     93 files  Drop-in: SN2 platform, headers, drivers, misc
0002-ia64.patch           1 file   machvec.h compatibility shim
0003-ia64.patch           2 files  Kconfig/Makefile (includes SWIOTLB conditional)
0004-ia64.patch          13 files  Core ia64 hooks (includes arch_sync_dma guard)
0005-drivers.patch       12 files  Driver Kconfig/Makefiles
0006-drivers.patch        4 files  Driver source mods (includes qla machvec.h)
```

Total: 125 files

## Quick apply

```bash
cd /path/to/linux-5.5
for p in /path/to/patches/000[1-6]-*.patch; do
    echo "Applying $(basename $p)..."
    patch -p1 < "$p" || echo "FAILED: $p"
done
```

Or apply the monolithic patch:

```bash
patch -p1 < sn2-v5.5-complete.patch
```

## Notes

- Patch 0001 is all new files (no conflicts possible on any 5.5-based tree).
  Includes the DMA_ATTR_WRITE_BARRIER local define and const/mmap fixes
  in pci_dma.c.

- Patch 0002 provides the minimal machvec.h shim that SN2 code depends on.
  Must be applied before 0004 (core hooks include machvec.h).

- Patch 0003 adds CONFIG_IA64_SGI_SN2 to Kconfig. The SWIOTLB conditional
  on ARCH_HAS_SYNC_DMA_FOR_CPU is a 5.5-specific fix (this select was
  unconditional in 5.4, but SN2 uses its own DMA ops, not SWIOTLB).

- Patch 0004 is the most invasive — 13 existing ia64 files get #ifdef
  CONFIG_IA64_SGI_SN2 hooks. The arch_sync_dma_for_cpu #ifdef guard is
  a 5.5-specific fix (function signature changed from 5.4).

- Patches 0005-0006 are driver integration. 0006 includes the qla2xxx
  machvec.h include (relocated for 5.5 due to header context changes).

## v5.4 → v5.5 fixes included

- pci_dma.c: DMA_ATTR_WRITE_BARRIER defined locally (removed from headers)
- pci_dma.c: const struct dma_map_ops + .mmap/.get_sgtable callbacks
- Kconfig: ARCH_HAS_SYNC_DMA_FOR_CPU conditional on SWIOTLB
- mm/init.c: #ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU guard
- setup.c: Simplified platform init (collapsed 3-way ifdef)
- qla_init.c: machvec.h include relocated (single occurrence)

## Already present from v5.4 patch

- pcibr_dma.c: sn_dma_flush(unsigned long addr) signature
- io_init.c: IORESOURCE_UNSET flag cleared before insert_resource()
- iomv.c: NULL check for pda->pio_write_status_addr in __sn_mmiowb()
