# SN2 v5.10 Patch Set

Re-addition of SGI SN2 (Altix) platform support for Linux v5.10.
Forward-ported from sn2-v5.5-complete.patch with build fixes for
v5.10 API changes.

## Files

- `sn2-v5.10-complete.patch` — Single combined patch (125 files)
- `0001-0006` — Split patches for sequential application
- `fixes.md` — Detailed description of v5.5→v5.10 changes
- `build-issues.md` — Build issues found and fixed
- `PLAN.md` — Overall design document

## Split Patches

| Patch | Files | Description |
|-------|-------|-------------|
| **0001** | 94 | Drop-in: SN2 platform code, headers, new driver sources, misc |
| **0002** | 1 | machvec.h shim (`ia64_platform_is` compile-time dispatch) |
| **0003** | 2 | Kconfig + Makefile (`CONFIG_IA64_SGI_SN2`, SWIOTLB conditional) |
| **0004** | 12 | Core ia64 hooks (`#ifdef` in hw_irq.h, io.h, setup.c, acpi.c, etc.) |
| **0005** | 12 | Driver Kconfig/Makefiles |
| **0006** | 4 | Driver source mods (mspec.c, qla1280, qla2xxx) |

## Application

Either apply the combined patch:
```
patch -p1 < sn2-v5.10-complete.patch
```

Or apply the split patches in order:
```
for p in 000[1-6]-*.patch; do patch -p1 < "$p"; done
```

## v5.10 Build Fixes (folded into patches)

These changes were needed beyond the v5.5 patch to build on v5.10:

| Fix | File(s) | Issue |
|-----|---------|-------|
| Orphan `#endif` | `arch/ia64/mm/init.c` | `arch_sync_dma_for_cpu` renamed; stray `#endif` from rejected hunk |
| Unused function | `arch/ia64/mm/tlb.c` | `ia64_global_tlb_purge` guarded with `#ifndef CONFIG_IA64_SGI_SN2` |
| `efi.hcdp` removed | `arch/ia64/sn/kernel/setup.c` | Use `hcdp_phys` (EFI cleanup v5.7) |
| `uninitialized_var` removed | `tiocx.c`, `pcibr_provider.c` | Macro removed in v5.10; plain declaration |
| `struct pci_bus` warning | `pcibr_provider.h` | Forward declaration added |
| `linux/ioc3.h` missing | `include/linux/ioc3.h` | Re-added (removed with MIPS IOC3 rewrite) |
| `DECLARE_TASKLET` API | `snsc_event.c` | 3-arg → 2-arg, new callback signature |
| `---help---` syntax | `drivers/sn/Kconfig`, `drivers/misc/Kconfig` | Changed to `help` |
| `dma-map-ops.h` | `pci_dma.c` | DMA header split in v5.10 |
| `proc_ops` | `sn2_smp.c`, `sn_proc_fs.c` | `file_operations` → `proc_ops` (v5.6) |
| `drivers/char/Kconfig` | SGI entries reanchored | Restructured in v5.10; placed before `endmenu` |

## Patch Lineage

- `sn2-v5.4-complete.patch` → original compile-time SN2 re-addition
- `sn2-v5.5-complete.patch` → forward-port to v5.5
- `sn2-v5.10-complete.patch` → forward-port to v5.10 (this patch set)
