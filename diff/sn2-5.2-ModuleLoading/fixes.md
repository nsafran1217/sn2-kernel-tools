# Linux v5.2 SN2 Boot Fixes

## Context

Linux v5.2 introduced changes that broke SGI SN2 Altix support. Two patches
were already applied to get the system booting (mmiowb NULL guard, IORESOURCE_UNSET
clearing). However, the system hangs during udevd device processing with NaT
consumption faults, NULL pointer dereferences, and recursive die() failures.

The crash occurs when udevd processes EHCI USB controllers on PCI bus 0001:00.

## Pre-applied Patches (already in tree)

1. **iomv.c mmiowb NULL guard** — Prevents crash when `pda->pio_write_status_addr`
   is NULL during early boot. Required because commit `49ca6462fc9e` added automatic
   `mmiowb()` calls inside every `spin_unlock()`.

2. **io_init.c IORESOURCE_UNSET clearing** — Clears `IORESOURCE_UNSET` flag on
   resources after SN2 PROM remaps the BAR addresses, so the PCI core treats
   them as properly assigned.

## Issues Found

### Issue 1: insert_resource() return value unchecked in sn_io_slot_fixup()

**File:** `arch/ia64/sn/kernel/io_init.c`

**Problem:** `sn_io_slot_fixup()` calls `insert_resource()` to insert the
SN2-remapped PCI resources into the resource tree, but never checks the return
value. If insertion fails (resource conflict, etc.), `res->parent` remains NULL.

When the PCI driver later calls `pci_enable_device()`, the function
`pci_enable_resources()` checks `!r->parent` and refuses to enable the device.
The driver probe fails, but the device remains partially initialized. Subsequent
access to device MMIO space can hit IA64 NaT pages, causing kernel-mode NaT
consumption faults that crash the system.

**Fix:** Log a warning when `insert_resource()` fails and force-set `res->parent`
to the appropriate root resource so that driver probing can still succeed. On SN2,
the PROM-provided PIO addresses are always valid; the resource tree conflict is a
bookkeeping issue, not a hardware problem.

### Issue 2: NULL pointer dereference in SN2 DMA functions

**File:** `arch/ia64/sn/pci/pci_dma.c`

**Problem:** Multiple DMA functions call `SN_PCIDEV_BUSPROVIDER(pdev)` which
expands to `sn_pcidev_info_get(pdev)->pdi_provider`. The function
`sn_pcidev_info_get()` can return NULL if the device hasn't been fixed up by
the SN2 platform code (race during init, hotplug, or error paths).
Dereferencing NULL causes a kernel crash.

**Fix:** Add NULL checks for the return value of `SN_PCIDEV_INFO()` /
`SN_PCIDEV_BUSPROVIDER()` in DMA allocation, mapping, and unmapping functions.
Return errors gracefully instead of crashing.

### Issue 3: NULL pointer dereference in pcibr_dma_map/unmap

**File:** `arch/ia64/sn/pci/pcibr/pcibr_dma.c`

**Problem:** `pcibr_dma_unmap()`, `pcibr_dma_map()`, and
`pcibr_dma_map_consistent()` call `SN_PCIDEV_INFO(hwdev)` and immediately
dereference the result without NULL checking. If the pcidev_info lookup fails,
these functions crash with a NULL pointer dereference.

**Fix:** Add NULL checks and return gracefully (return 0 / return early) when
pcidev_info is NULL.

### Issue 4: mmiowb NULL guard whitespace (cosmetic)

**File:** `arch/ia64/sn/kernel/iomv.c`

**Problem:** The existing mmiowb NULL guard patch uses spaces instead of a tab
for the `return` statement indentation. This is inconsistent with kernel coding
style.

**Fix:** Use tab indentation for consistency.

## Test Results

### Patch 0001 only (build #16)
**Result: BOOT SUCCESS** — but likely coincidence. The intermittent NaT crash
did not trigger on this particular boot.

### All patches (build #19)
**Result: INTERMITTENT CRASH** — NaT consumption during USB device probing.

### Built-in USB drivers (builds #20, #21)
**Result: STILL CRASHING** — The crash occurs regardless of whether USB drivers
are built as modules or built-in. With modules, it faults in ehci_pci module
functions. With built-in, it faults in built-in USB probe code. The `Modules
linked in:` field is empty in the latest crash, proving this is not a module
loading or icache issue.

### flush.S mf fix (build #22)
**Result: STILL CRASHING** — Adding `mf` before `fc.i` in `flush_icache_range()`
did not help. The `flush_icache_range()` function has worked on all IA64
platforms for decades and is not the problem.

## Root Cause: VM_FLUSH_RESET_PERMS causes extra SHUB TLB flushes

### Issue 5: vmalloc_exec VM_FLUSH_RESET_PERMS triggers SHUB PTC.GA interference

**Bisected commit:** `868b104d7379` ("vmalloc: New flag for flush reset")

**File:** `arch/ia64/sn/kernel/setup.c` (fix)

**Problem:** Commit `868b104d7379` changed `vmalloc_exec()` to tag allocations
with `VM_FLUSH_RESET_PERMS`. This flag is designed for architectures with
`CONFIG_ARCH_HAS_SET_MEMORY` / `CONFIG_ARCH_HAS_SET_DIRECT_MAP` to reset
memory permissions when freeing executable vmalloc memory. ia64 has **neither**
config, so `set_memory_nx()`, `set_memory_rw()`, `set_direct_map_*_noflush()`
are all no-op stubs. The flag provides zero benefit on ia64.

However, the flag causes `vm_remove_mappings()` during `vfree()` to take a
new code path. Instead of just `remove_vm_area()` (lazy TLB flush), it now
also calls `_vm_unmap_aliases()` with `flush=1`. This acquires
`vmap_purge_lock`, calls `__purge_vmap_area_lazy()`, and forces an **immediate
global TLB flush** via `flush_tlb_kernel_range()`.

On SN2, `flush_tlb_kernel_range()` → `sn2_global_tlb_purge()` → SHUB PTC.GA
broadcast to all CPUs. Before this commit, module init section free used plain
`remove_vm_area()` with lazy TLB flushing. After this commit, each module's
init section free triggers an immediate SHUB PTC.GA.

During boot, 6+ modules load in rapid succession (button, usb_common, usbcore,
ehci_hcd, ehci_pci, uhci_hcd). Each module's init section is freed after init
completes, generating 6+ extra SHUB PTC.GA broadcasts. These occur concurrently
with active PIO/MMIO traffic (USB controller register accesses). The SHUB's
coordination of PTC.GA broadcasts with ongoing PIO responses is fragile,
leading to intermittent corrupted data returns.

**Evidence:**
- Bisect pinpoints this exact commit as "first bad"
- Crash is intermittent (timing of TLB flush vs PIO)
- Different fault types across boots (NaT, illegal op, bad break, page fault
  with corrupted address 0x0000d00a02f7e198) — consistent with SHUB returning
  garbage during PTC.GA/PIO interference
- Always during USB probing when multiple modules loading/freeing init sections

**Fix:** Override `module_alloc()` in `arch/ia64/sn/kernel/setup.c` to call
`__vmalloc_node_range()` with `vm_flags=0` instead of `VM_FLUSH_RESET_PERMS`.
Since the `sn/` directory is only compiled when `CONFIG_IA64_SGI_SN2` is set,
this override only affects SN2 builds — non-SN2 ia64 platforms continue to
use the default `vmalloc_exec()` path unchanged.

### Discarded theories

- **icache coherency / flush.S**: Wrong. Crash occurs with built-in drivers.
- **Module loading race**: Wrong. Same reason — crash is not module-specific.
- **Early BAR remap ordering**: Wrong. Patch did not help.
- **mmiowb framework interaction**: The NULL guard fix is still needed for boot,
  but the intermittent crash is caused by VM_FLUSH_RESET_PERMS TLB flushes.

## Patch Summary

### Required for v5.2 boot on SN2

| Patch | File | Status |
|-------|------|--------|
| iomv.c mmiowb NULL guard | `arch/ia64/sn/kernel/iomv.c` | **Pre-applied** |
| io_init.c IORESOURCE_UNSET | `arch/ia64/sn/kernel/io_init.c` | **Pre-applied** |
| **0005** module_alloc VM_FLUSH_RESET_PERMS | `arch/ia64/sn/kernel/setup.c` | **Apply this** |

### Recommended (defensive hardening)

| Patch | File | Purpose |
|-------|------|---------|
| 0001 | `arch/ia64/sn/kernel/io_init.c` | Check insert_resource() return, force parent on failure |

### Optional

| Patch | File | Purpose |
|-------|------|---------|
| 0002 | `arch/ia64/sn/pci/pci_dma.c` | NULL safety in SN2 DMA functions |
| 0003 | `arch/ia64/sn/pci/pcibr/pcibr_dma.c` | NULL safety in pcibr DMA map/unmap |
| 0004 | `arch/ia64/sn/kernel/iomv.c` | Cosmetic: fix tab indentation in mmiowb guard |

