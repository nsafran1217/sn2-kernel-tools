# SN2 Patch Port: Linux 6.18 → 6.19 Fixes

## Summary

Porting the SN2 patch from Linux 6.18 to 6.19.
Starting patch: `sn2-v6.18-epic2-complete.patch`
Result patch: `sn2-v6_19-complete.patch`

Total changes: **1 build fix** (DMA API rename)

---

## Upstream API Changes (6.18 → 6.19)

### DMA map_page → map_phys conversion

Linux 6.19 replaced the `map_page`/`unmap_page` callbacks in
`struct dma_map_ops` with `map_phys`/`unmap_phys`.  The old interface
took a `struct page *` plus an offset; the new interface takes a
`phys_addr_t` directly.  The `map_resource`/`unmap_resource` callbacks
were also removed (subsumed into `map_phys`/`unmap_phys`).

Old signature:
```c
dma_addr_t (*map_page)(struct device *dev, struct page *page,
                       unsigned long offset, size_t size,
                       enum dma_data_direction dir, unsigned long attrs);
void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
                   size_t size, enum dma_data_direction dir,
                   unsigned long attrs);
```

New signature:
```c
dma_addr_t (*map_phys)(struct device *dev, phys_addr_t phys,
                       size_t size, enum dma_data_direction dir,
                       unsigned long attrs);
void (*unmap_phys)(struct device *dev, dma_addr_t dma_handle,
                   size_t size, enum dma_data_direction dir,
                   unsigned long attrs);
```

The upstream `arch/ia64/hp/common/sba_iommu.c` was already updated for
this change in the 6.19 base tree.  The SN2 `pci_dma.c` was not.

---

## Build Fix

### Fix 1: `arch/ia64/sn/pci/pci_dma.c` — map_page → map_phys DMA API rename

**File:** `arch/ia64/sn/pci/pci_dma.c`

**Kernel change:** 6.19 DMA API cleanup — `map_page`/`unmap_page`
replaced by `map_phys`/`unmap_phys` in `struct dma_map_ops`.

**Problem:** `sn_dma_ops` struct references `.map_page` and
`.unmap_page` members which no longer exist.  Build fails with:
```
error: 'const struct dma_map_ops' has no member named 'map_page'
error: 'const struct dma_map_ops' has no member named 'unmap_page'
```

**Fix — three changes in the same file:**

1. **`sn_dma_map_page()` → `sn_dma_map_phys()`**: Signature changes
   from `(struct device *dev, struct page *page, unsigned long offset,
   size_t size, ...)` to `(struct device *dev, phys_addr_t phys,
   size_t size, ...)`.  The function body simplifies — the old
   `page_address(page) + offset` → `__pa()` conversion is eliminated
   since the DMA core now passes the physical address directly.  The
   `cpu_addr` and `phys_addr` local variables are removed; the `phys`
   parameter is passed straight to the provider's `dma_map()` and
   `dma_map_consistent()` callbacks.

2. **`sn_dma_unmap_page()` → `sn_dma_unmap_phys()`**: Function rename
   only.  The parameter list `(struct device *dev, dma_addr_t dma_addr,
   size_t size, enum dma_data_direction dir, unsigned long attrs)` is
   unchanged between old and new API.

3. **`sn_dma_ops` struct**: `.map_page = sn_dma_map_page` →
   `.map_phys = sn_dma_map_phys` and `.unmap_page = sn_dma_unmap_page`
   → `.unmap_phys = sn_dma_unmap_phys`.

**Type compatibility note:** The provider callbacks (`dma_map`,
`dma_map_consistent`) take `unsigned long` for the physical address.
On ia64 both `unsigned long` and `phys_addr_t` (`u64`) are 64-bit,
so implicit conversion is safe and width-preserving.

---

## Upstream Non-Breaking Changes (6.18 → 6.19)

These upstream changes affect files in the SN2 tree but do NOT require
SN2 patch modifications:

| File | Change | SN2 Impact |
|------|--------|------------|
| `arch/ia64/hp/common/sba_iommu.c` | map_page → map_phys | Already updated upstream |
| `arch/ia64/kernel/ptrace.c` | `.core_note_type` → `USER_REGSET_NOTE_TYPE()` | Already updated upstream |
| `arch/ia64/mm/fault.c` | `VM_READ_BIT` etc → `VMA_EXEC_BIT`/`VMA_WRITE_BIT` | Already updated upstream |
| `drivers/scsi/qla1280.c` | LUN format `%i` → `%llu`, removed `ql1280_dump_device()` | Already updated upstream |
| `drivers/scsi/qla2xxx/qla_init.c` | Added `qlt_config_nvram_with_fw_version()` call | Already updated upstream |
| `drivers/misc/Kconfig` | Minor MMC dependency removed | Already updated upstream |
| `include/linux/dma-mapping.h` | `DMA_BIT_MASK` parenthesized | No SN2 impact |

---

## Carried Forward From Previous Ports

| Fix | File | Description |
|-----|------|-------------|
| io_init insert_resource | sn/kernel/io_init.c | Error handling + IORESOURCE_UNSET |
| pci_dma NULL safety | sn/pci/pci_dma.c | NULL check on provider |
| pcibr_dma NULL safety | sn/pci/pcibr/pcibr_dma.c | NULL check on provider |
| msi_sn.c API updates | sn/kernel/msi_sn.c | pci.msi_attrib, irq_data_update_affinity |
| ioc4_serial.c DMA API | serial/ioc4_serial.c | dma_alloc/free_coherent, const ktermios |
| tiocx.c void remove | sn/kernel/tiocx.c | bus_type.remove returns void |
| mmiowb NULL guard | sn/kernel/iomv.c | NULL check on pio_write_status_addr |
| sn_console platform dev | serial/sn_console.c | Platform device for serial core |
| ioc4_serial ctrl_id | serial/ioc4_serial.c | ctrl_id for rs422 port disambiguation |
| sn_console kfifo | serial/sn_console.c | uart_circ → kfifo migration |
| bte_error timer_delete | sn/kernel/bte_error.c | del_timer → timer_delete |
| bte/msi timer_container_of | sn/kernel/bte.c, msi_sn.c | from_timer → timer_container_of |
| tiocx const driver | sn/kernel/tiocx.c | const device_driver in bus match |
| sn_console timer | serial/sn_console.c | timer_container_of + prototype |
| snsc_event unaligned | sn/kernel/snsc_event.c | asm/unaligned.h → linux/unaligned.h |
| mca non-static | kernel/mca.c | ia64_mca_register_cpev non-static |
| crash sysctl sentinel | kernel/crash.c | Remove sysctl table sentinel |
| sys_ia64 zero-init | kernel/sys_ia64.c | Zero-init vm_unmapped_area_info |
| io.h void casts | include/asm/io.h | void* casts in insw/outsw/insl/outsl |
| module notifier | sn/kernel/setup.c | VM_FLUSH_RESET_PERMS suppression |
