# SN2 Patch: v5.15 → v6.1 Port — Fixes Required

## Overview

Porting the `sn2-v5.15-complete.patch` to Linux 6.1 required 5 changes:
2 patch context fixes (failed hunks) and 3 build fixes (API changes between 5.15 and 6.1).

The patch applies to 120 files total (mostly new SN2 drop-in files).
Only 2 hunks out of ~150 failed — everything else applied cleanly (some with minor offset).

---

## Part 1 — Patch Application Fixes (Context Drift)

### Fix 1: `arch/ia64/Kconfig` — ZONE_DMA32 conditional (Hunk #2)

**Symptom:** Hunk #2 failed at line 61.

**Cause:** The v5.15 patch expected `select SET_FS` on the line above `select ZONE_DMA32`.
In 6.1, `SET_FS` was removed (commit `9d28795767de`, "ia64: remove support for old
assembler"), so the context no longer matched.

**Fix:** Manually apply the change: `select ZONE_DMA32` → `select ZONE_DMA32 if !IA64_SGI_SN2`.
The anchoring changed but the actual modification is identical.

### Fix 2: `drivers/tty/serial/Makefile` — ioc4_serial.o line (Hunk #2)

**Symptom:** Hunk #2 failed at line 53.

**Cause:** The v5.15 patch anchored the `obj-$(CONFIG_SERIAL_SGI_IOC4) += ioc4_serial.o`
line after `obj-$(CONFIG_SERIAL_VR41XX)`, which was removed in 6.1.

**Fix:** Anchored the line after `obj-$(CONFIG_SERIAL_TXX9)` instead (same area of the
Makefile, one line earlier than where VR41XX used to be).

---

## Part 2 — Build Fixes (API Changes: 5.15 → 6.1)

### Fix 3: `arch/ia64/sn/kernel/msi_sn.c` — PCI_DMA_FROMDEVICE removed

**Symptom:** `PCI_DMA_FROMDEVICE` undeclared.

**Cause:** The `PCI_DMA_*` compatibility constants (`PCI_DMA_FROMDEVICE`,
`PCI_DMA_TODEVICE`, `PCI_DMA_BIDIRECTIONAL`) were removed in Linux 5.18
(Christoph Hellwig's DMA API cleanup). The replacements are the `DMA_*`
enum values from `<linux/dma-direction.h>`.

**Fix:** Two replacements in `msi_sn.c`:
- Line 51: `PCI_DMA_FROMDEVICE` → `DMA_FROM_DEVICE`
- Line 184: `PCI_DMA_FROMDEVICE` → `DMA_FROM_DEVICE`

No header change needed — `DMA_FROM_DEVICE` is provided by `<linux/dma-direction.h>`
which is already pulled in via `<linux/pci.h>`.

### Fix 4: `drivers/tty/serial/sn_console.c` — const ktermios in set_termios

**Symptom:** Incompatible pointer type warning/error in `uart_ops.set_termios` callback.

**Cause:** In Linux 6.1 (commit `bec5b814c1`, "serial: make uart_ops::set_termios()
old ktermios const"), the `set_termios` callback signature changed:
```c
// Before (5.15):
void (*set_termios)(struct uart_port *, struct ktermios *new, struct ktermios *old);
// After (6.1):
void (*set_termios)(struct uart_port *, struct ktermios *new, const struct ktermios *old);
```

**Fix:** Added `const` to the `old` parameter of `snp_set_termios()`:
```c
static void snp_set_termios(struct uart_port *port, struct ktermios *termios,
                            const struct ktermios *old)
```

### Fix 5: `drivers/tty/serial/ioc4_serial.c` — const ktermios in set_termios

**Symptom:** Same as Fix 4, plus cascading const mismatch in `ioc4_change_speed()`.

**Cause:** Same `uart_ops.set_termios` signature change as Fix 4.

**Fix:** Three changes in `ioc4_serial.c`:
1. `ic4_set_termios()`: `struct ktermios *old_termios` → `const struct ktermios *old_termios`
2. `ioc4_change_speed()`: `struct ktermios *old_termios` → `const struct ktermios *old_termios`
3. Line 1808 NULL cast: `(struct ktermios *)0` → `(const struct ktermios *)0`

---

## Part 3 — Carried Forward from v5.15 (No Changes Needed)

These fixes were already present in the v5.15 patch and carried forward unchanged:

| File | Fix | Origin |
|------|-----|--------|
| `arch/ia64/sn/kernel/io_init.c` | `insert_resource()` error handling with fallback | v5.4 |
| `arch/ia64/sn/pci/pci_dma.c` | NULL safety for provider/pcidev pointers | v5.4 |
| `arch/ia64/sn/pci/pcibr/pcibr_dma.c` | NULL safety for provider/pcidev pointers | v5.4 |
| `arch/ia64/sn/kernel/setup.c` | `module_alloc()` without `VM_FLUSH_RESET_PERMS` | v5.5 |
| `drivers/tty/serial/sn_console.c` | `uart_circ_empty()` guard in `snp_start_tx()` | v3.15 regression |
| `arch/ia64/sn/kernel/tiocx.c` | `bus_type.remove` void return | v5.15 |
| `arch/ia64/sn/kernel/tiocx.c` | `MODULE_SUPPORTED_DEVICE` removed | v5.15 |
| `arch/ia64/sn/kernel/iomv.c` | `__sn_mmiowb()` NULL pointer guard | v5.2 |
| `arch/ia64/mm/contig.c` | ZONE_DMA32 `#ifndef` guard | v5.15 |
| `arch/ia64/mm/discontig.c` | ZONE_DMA32 `#ifndef` guard | v5.15 |

---

## Build Audit: API Compatibility Check (5.15 → 6.1)

| API Area | Status | Notes |
|----------|--------|-------|
| `struct dma_map_ops` fields | OK | `.mmap`, `.get_sgtable`, `.map_sg` all still present in 6.1 |
| `struct bus_type` `.probe`/`.remove` | OK | Still present in 6.1 (deprecated in 6.3+) |
| `struct pci_driver` `.remove` | OK | Already `void` return in v5.15 patch |
| `struct file_operations` | OK | Used by `sn_hwperf` misc device, unchanged |
| `struct proc_ops` | OK | Already converted in v5.10 patch |
| `timer_setup()` API | OK | Already converted in v5.10 patch |
| `struct vm_operations_struct` | OK | `mspec.c` uses current API |
| `vmf_insert_pfn()` | OK | Used by `mspec.c`, unchanged |
| `vma->vm_flags \|=` | OK | Direct assignment still valid in 6.1 (`vm_flags_set` is 6.3+) |
| `__vmalloc_node_range()` | OK | Same 9-parameter signature as 5.15 |
| `efi_config_table_t` | OK | Still defined in `<linux/efi.h>` |
| `struct pci_controller` | OK | ia64-specific, unchanged |
| `get_arch_dma_ops()` / `dma_ops` | OK | Still present in ia64 `dma-mapping.h` |
| `MODULE_SUPPORTED_DEVICE` | OK | Already removed in v5.15 patch |
| `ioremap()` | OK | No `ioremap_nocache` calls in SN2 code |

---

## Summary of File Changes vs v5.15 Patch

### Files requiring manual fix (context drift):
| File | Change |
|------|--------|
| `arch/ia64/Kconfig` | Reanchor ZONE_DMA32 hunk (SET_FS removed) |
| `drivers/tty/serial/Makefile` | Reanchor ioc4_serial.o (VR41XX removed) |

### SN2-specific files modified for 6.1:
| File | Change |
|------|--------|
| `arch/ia64/sn/kernel/msi_sn.c` | `PCI_DMA_FROMDEVICE` → `DMA_FROM_DEVICE` |
| `drivers/tty/serial/sn_console.c` | `const struct ktermios *old` |
| `drivers/tty/serial/ioc4_serial.c` | `const struct ktermios *old` (3 locations) |

### All other files: unchanged from v5.15 patch
