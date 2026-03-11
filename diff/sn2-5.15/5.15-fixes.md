# SN2 v5.10 → v5.15 Fixes

All changes required to forward-port `sn2-v5.10-complete.patch` to
Linux 5.15.  Changes fall into three categories: patch application
failures (context drift), build errors (API changes), and fixes
carried forward from the 5.10 port.

All fixes are folded into the split patch set (0001–0006) and the
combined `sn2-v5.15-complete.patch`.

Total files: 120 (vs 125 in v5.10 — 3 IDE + 4 IOC3 dropped, 2 new mm files)

---

## Part 1: Patch Application Fixes

These are hunks that failed when applying the 5.10 patch against the
5.15 clean tree due to upstream code changes.

### 1.1: arch/ia64/Kconfig — SWIOTLB context shift

**Symptom:** Hunk #1 FAILED at 46.
**Cause:** Between 5.10 and 5.15, several `select` lines were
added/removed in the `config IA64` block (`ARCH_HAS_STRNCPY_FROM_USER`,
`ARCH_HAS_STRNLEN_USER`, `ARCH_ENABLE_MEMORY_HOTPLUG`,
`ARCH_ENABLE_MEMORY_HOTREMOVE`, `HUGETLB_PAGE_SIZE_VARIABLE`,
`LEGACY_TIMER_TICK` added; `HAVE_IDE`, `HAVE_OPROFILE` removed).
This shifted the `select SWIOTLB` line enough to exceed patch fuzz.

**Fix:** Manual replacement:
`select SWIOTLB` → `select SWIOTLB if !IA64_SGI_SN2`

**Folded into:** `0003`

### 1.2: arch/ia64/Kconfig — ZONE_DMA32 restructured

**Symptom:** Hunk #2 applied with fuzz 2 and offset +9 lines, but
landed the `depends on !IA64_SGI_SN2` under `config STACKTRACE_SUPPORT`
instead of the intended ZONE_DMA32 target.
**Cause:** In 5.10, `ZONE_DMA32` was a standalone `config` block:
```
config ZONE_DMA32
    def_bool y
```
In 5.15, this was folded into the main `config IA64` block as:
```
    select ZONE_DMA32
```
The fuzz-matched hunk found a `def_bool y` under `STACKTRACE_SUPPORT`
and applied there — completely wrong target.

**Fix:** Removed the errant `depends on !IA64_SGI_SN2` from
`STACKTRACE_SUPPORT`.  Changed `select ZONE_DMA32` to
`select ZONE_DMA32 if !IA64_SGI_SN2` in the `config IA64` block.

**Folded into:** `0003`

### 1.3: arch/ia64/Kbuild — Build system restructured (new file)

**Symptom:** arch/ia64/Makefile Hunk #1 FAILED at 49.
**Cause:** In 5.15, the `core-y` build lines moved from
`arch/ia64/Makefile` to a new `arch/ia64/Kbuild` file:
```
# 5.10 Makefile had:
core-y                          += arch/ia64/kernel/ arch/ia64/mm/
core-$(CONFIG_IA64_SGI_SN2)     += arch/ia64/sn/
core-$(CONFIG_IA64_SGI_UV)      += arch/ia64/uv/

# 5.15 Kbuild has:
obj-y                           += kernel/ mm/
obj-$(CONFIG_IA64_SGI_UV)       += uv/
```

The `core-y` → `obj-y` migration was part of Kbuild modernization.

**Fix:** Added `obj-$(CONFIG_IA64_SGI_SN2) += sn/` to `arch/ia64/Kbuild`
instead of modifying `arch/ia64/Makefile`.

**Folded into:** `0003`

### 1.4: arch/ia64/include/asm/io.h — Context line removed

**Symptom:** Hunk #1 FAILED at 277.
**Cause:** The patch anchored the SN2 I/O override block before
`#define xlate_dev_kmem_ptr xlate_dev_kmem_ptr`, but this line was
removed upstream in 5.15 (xlate_dev_kmem_ptr eliminated).

**Fix:** Reanchored the SN2 `#ifdef CONFIG_IA64_SGI_SN2` block to
insert after `#define memset_io memset_io` and before
`#define xlate_dev_mem_ptr xlate_dev_mem_ptr`.  Content is identical.

**Folded into:** `0004`

### 1.5: drivers/char/Makefile — RAW_DRIVER removed

**Symptom:** Hunk #1 FAILED at 9.
**Cause:** The patch expected `obj-$(CONFIG_RAW_DRIVER) += raw.o` as
context between `VIRTIO_CONSOLE` and `MSPEC`.  The raw driver was
removed upstream in v5.14.

**Fix:** Reanchored SGI_SNSC and SGI_MBCS entries after
`obj-$(CONFIG_VIRTIO_CONSOLE)` and before/after `obj-$(CONFIG_MSPEC)`.

**Folded into:** `0005`

### 1.6: drivers/ide/ — IDE subsystem removed

**Symptom:** `drivers/ide/Kconfig` and `drivers/ide/Makefile` — file
not found.
**Cause:** The entire IDE subsystem was removed from Linux in v5.14
(commit `afee7f30da5c`).  The SGI IOC4 IDE driver (`sgiioc4.c`)
depended on this subsystem.

**Fix:** Dropped `drivers/ide/sgiioc4.c`, `drivers/ide/Kconfig`
changes, and `drivers/ide/Makefile` changes entirely.

**Impact:** Disk access via IOC4 IDE is lost.  On SN2 Altix systems
with IOC4-based IO9/IO10 cards, the IDE function will not be
available.  SCSI and PCI storage remain fully functional.

**Files dropped:** `drivers/ide/sgiioc4.c`, `drivers/ide/Kconfig`,
`drivers/ide/Makefile`

---

## Part 2: Build Fixes

These are errors found during compilation with `CONFIG_IA64_SGI_SN2=y`
after the patch was applied.

### 2.1: ZONE_DMA32 undeclared in paging_init()

**Error:**
```
arch/ia64/mm/discontig.c:604:23: error: 'ZONE_DMA32' undeclared
```

**Cause:** SN2 disables `ZONE_DMA32` (via
`select ZONE_DMA32 if !IA64_SGI_SN2` in Kconfig) because SN2 uses its
own DMA handling through SHUB.  But `paging_init()` in both
`discontig.c` and `contig.c` unconditionally references `ZONE_DMA32`.

**Fix:** Guard the `ZONE_DMA32` array assignment with
`#ifdef CONFIG_ZONE_DMA32`.  Fold `max_dma` variable into the guarded
block to avoid unused variable warning.

**Files:** `arch/ia64/mm/discontig.c`, `arch/ia64/mm/contig.c`

**Folded into:** `0004`

### 2.2: tiocx.c bus_type.remove signature change

**Error:**
```
arch/ia64/sn/kernel/tiocx.c:150:19: error: initialization of
  'void (*)(struct device *)' from incompatible pointer type
  'int (*)(struct device *)' [-Werror=incompatible-pointer-types]
```

**Cause:** `bus_type.remove` changed from `int (*)(struct device *)`
to `void (*)(struct device *)` in v5.15 (commit `fc7a6209d571`).

**Fix:** Change `cx_driver_remove()` return type from `int` to `void`,
remove the `return 0`.

**Files:** `arch/ia64/sn/kernel/tiocx.c`

**Folded into:** `0001`

### 2.3: tiocx.c MODULE_SUPPORTED_DEVICE removed

**Error:**
```
arch/ia64/sn/kernel/tiocx.c:570:25: error: expected declaration
  specifiers or '...' before string constant
  570 | MODULE_SUPPORTED_DEVICE(DEVICE_NAME);
```

**Cause:** `MODULE_SUPPORTED_DEVICE()` macro removed in v5.12
(commit `1d6272f3a455`).

**Fix:** Delete the `MODULE_SUPPORTED_DEVICE()` call.

**Files:** `arch/ia64/sn/kernel/tiocx.c`

**Folded into:** `0001`

### 2.4: IOC3 driver — tty_port.low_latency removed

**Error:**
```
drivers/tty/serial/ioc3_serial.c:1000:20: error: 'struct tty_port'
  has no member named 'low_latency'
```

**Cause:** `tty_port.low_latency` removed in v5.12
(commit `b3b576461c47`).

**Fix:** Drop the IOC3 driver entirely.  IOC3 is not used on SN2
systems — only IOC4 is present.

**Files removed:**
- `include/linux/ioc3.h`
- `arch/ia64/include/asm/sn/ioc3.h`
- `drivers/sn/ioc3.c`
- `drivers/tty/serial/ioc3_serial.c`
- `drivers/sn/Kconfig` — `SGI_IOC3` config removed
- `drivers/sn/Makefile` — `ioc3.o` build removed
- `drivers/tty/serial/Kconfig` — `SERIAL_SGI_IOC3` config removed
- `drivers/tty/serial/Makefile` — `ioc3_serial.o` build removed

**Folded into:** `0001` (source files), `0005` (Kconfig/Makefile)

### 2.5: ioc4_serial.c — tty_port.low_latency removed

**Error:**
```
drivers/tty/serial/ioc4_serial.c:1746:20: error: 'struct tty_port'
  has no member named 'low_latency'
```

**Cause:** Same API change as IOC3 — `tty_port.low_latency` removed
in v5.12 (commit `b3b576461c47`).  All tty ports are now low latency
by default.

**Fix:** Remove the `state->port.low_latency = 1` line.

**Files:** `drivers/tty/serial/ioc4_serial.c`

**Folded into:** `0001`

---

## Part 3: Fixes Carried Forward from v5.10

These fixes were already in the v5.10 patch and are retained
unchanged.  They are folded into the new files in `0001`.

### 3.1: io_init.c — insert_resource error handling

Added `int ret` and wrapped both `insert_resource()` calls with error
checking.  On failure, logs a warning and forces `res->parent`
directly so PCI resource lookups don't break on overlapping resources.

**File:** `arch/ia64/sn/kernel/io_init.c`

### 3.2: pci_dma.c — NULL safety for pcidev_info

Split `SN_PCIDEV_BUSPROVIDER()` into separate `SN_PCIDEV_INFO()` +
NULL check + `pdi_provider` dereference across all 6 DMA functions.
Prevents NULL pointer dereference during early PCI enumeration.

**File:** `arch/ia64/sn/pci/pci_dma.c`

### 3.3: pcibr_dma.c — NULL safety for pcidev_info

Added `!pcidev_info` NULL checks to `pcibr_dma_unmap()`,
`pcibr_dma_map()`, and `pcibr_dma_map_consistent()`.

**File:** `arch/ia64/sn/pci/pcibr/pcibr_dma.c`

### 3.4: setup.c — module_alloc without VM_FLUSH_RESET_PERMS

SN2-specific `module_alloc()` that uses `__vmalloc_node_range()`
without `VM_FLUSH_RESET_PERMS` flag.  The flag is useless on ia64 but
causes `vm_remove_mappings()` to force global TLB flushes that
interfere with SN2 SHUB PIO/MMIO traffic during module init.

**File:** `arch/ia64/sn/kernel/setup.c`

### 3.5: sn_console.c — uart_circ_empty guard in snp_start_tx

Added early return in `snp_start_tx()` when transmit circular buffer
is empty, preventing spurious `ia64_sn_console_intr_disable(XMIT)`
SAL calls that stall the L1 console.  Fix for regression introduced
in 3.15 by commit `717f3bbab3c7`.

**File:** `drivers/tty/serial/sn_console.c`

---

## Build Issue Audit

### Checked — No issues found:

| Area | Status | Notes |
|------|--------|-------|
| `uart_circ` API | OK | Still present in 5.15 (deprecated in 5.18+) |
| `__vmalloc_node_range` | OK | Same 9-arg signature in 5.15 |
| `proc_ops` vs `file_operations` | OK | Already converted in 5.10 port |
| `DECLARE_TASKLET` 2-arg | OK | Already converted in 5.10 port |
| `ioremap_nocache` | OK | Not used in SN2 code |
| `uninitialized_var` | OK | Already removed in 5.10 port |
| `hcdp_phys` (EFI cleanup) | OK | Already using hcdp_phys from 5.10 port |
| `dma-map-ops.h` include | OK | Already present from 5.10 port |
| `pci_find_bus` | OK | Still present in 5.15 |
| `SET_FS` | OK | Still selected in 5.15 ia64 Kconfig |
| `set_fs()` in SN2 code | OK | SN2 code does not use set_fs |
| `IRQF_DISABLED` | OK | Not used in SN2 code |
| `follow_pfn` | OK | Not used in mspec.c |
| `vm_operations_struct` | OK | mspec.c already uses current API |
| `kmap_atomic` | OK | Not used in SN2/driver code |

---

## Summary of File Changes vs v5.10 Patch

### New files (not in v5.10 patch):
| File | Reason |
|------|--------|
| `arch/ia64/Kbuild` | Build system moved from Makefile |
| `arch/ia64/mm/contig.c` | ZONE_DMA32 guard added |
| `arch/ia64/mm/discontig.c` | ZONE_DMA32 guard added |

### Dropped files (were in v5.10 patch):
| File | Reason |
|------|--------|
| `arch/ia64/Makefile` | Build lines moved to Kbuild |
| `arch/ia64/include/asm/sn/ioc3.h` | IOC3 dropped |
| `include/linux/ioc3.h` | IOC3 dropped |
| `drivers/sn/ioc3.c` | IOC3 dropped |
| `drivers/tty/serial/ioc3_serial.c` | IOC3 dropped |
| `drivers/ide/sgiioc4.c` | IDE subsystem removed |
| `drivers/ide/Kconfig` | IDE subsystem removed |
| `drivers/ide/Makefile` | IDE subsystem removed |

### Trailing fix patches folded in (no longer separate diffs):
| File | Fix |
|------|-----|
| `arch/ia64/sn/kernel/io_init.c` | insert_resource error handling |
| `arch/ia64/sn/pci/pci_dma.c` | NULL safety |
| `arch/ia64/sn/pci/pcibr/pcibr_dma.c` | NULL safety |
| `arch/ia64/sn/kernel/setup.c` | module_alloc |
| `drivers/tty/serial/sn_console.c` | uart_circ_empty |
