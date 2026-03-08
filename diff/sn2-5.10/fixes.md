# SN2 v5.10 Fixes — Changes from v5.5 Patch

These are the changes required when forward-porting sn2-v5.5-complete.patch
to Linux 5.10.  27 of 34 modified files changed between v5.5 and v5.10.

---

## Patch-application rejects (3 hunks out of ~277)

### Reject 1: `arch/ia64/Kconfig` hunk #1 — DROPPED

**v5.5 hunk:** Changed `select ARCH_HAS_SYNC_DMA_FOR_CPU` to
`select ARCH_HAS_SYNC_DMA_FOR_CPU if SWIOTLB`

**v5.10 status:** `ARCH_HAS_SYNC_DMA_FOR_CPU`, `DMA_NONCOHERENT_MMAP`,
and `HAVE_MEMBLOCK_NODE_MAP` were all removed from the ia64 Kconfig
upstream between v5.5 and v5.10.  The replacement is
`ARCH_HAS_DMA_MARK_CLEAN` (line 11), which is unconditionally selected
and harmless for SN2 (it just marks DMA'd pages clean for i-cache
coherency).

**Resolution:** Hunk dropped entirely.  No equivalent change needed.
The other 4 Kconfig hunks (SWIOTLB conditional, ZONE_DMA32 guard,
IA64_SGI_SN2 block, drivers/sn/Kconfig source) applied with minor
offsets.

### Reject 2: `arch/ia64/mm/init.c` hunk #1 — DROPPED

**v5.5 hunk:** Added `#ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU` guard
around `arch_sync_dma_for_cpu()`.

**v5.10 status:** Function renamed to `arch_dma_mark_clean()` and the
controlling Kconfig symbol changed to `ARCH_HAS_DMA_MARK_CLEAN` (always
selected).  The function is harmless — it marks pages clean for i-cache
coherency — so no conditional guard is needed.

**Resolution:** Hunk dropped entirely.  The second hunk (SWIOTLB init
guard) applied cleanly.

### Reject 3: `drivers/char/Kconfig` hunk #1 — REANCHORED

**v5.5 hunk:** Added SGI_SNSC, SGI_TIOCX, SGI_MBCS config entries
before `source "drivers/tty/serial/Kconfig"`.

**v5.10 status:** `drivers/char/Kconfig` was substantially restructured.
The `DEVKMEM` section and `source "drivers/tty/serial/Kconfig"` line
are gone.

**Resolution:** SGI config entries placed before `endmenu` (line 474)
instead of before the serial Kconfig source line.

---

## Additional v5.10 API/syntax fixes (applied to SN2 new files)

### Fix 1: Add `#include <linux/dma-map-ops.h>` to pci_dma.c

**File:** `arch/ia64/sn/pci/pci_dma.c` (new SN2 file)
**Kernel change:** v5.10 (Christoph Hellwig's DMA API cleanup)
**Issue:** `struct dma_map_ops`, `dma_common_mmap`, and
`dma_common_get_sgtable` moved from `<linux/dma-mapping.h>` to the new
`<linux/dma-map-ops.h>`.

### Fix 2: Convert `file_operations` to `proc_ops` in sn2_smp.c

**File:** `arch/ia64/sn/kernel/sn2/sn2_smp.c` (new SN2 file)
**Kernel change:** v5.6 (proc_ops introduction)
**Issue:** `proc_create()` requires `struct proc_ops *`.  Changed
`proc_sn2_ptc_operations` from `file_operations` to `proc_ops` and
renamed fields: `.open` to `.proc_open`, `.read` to `.proc_read`,
`.write` to `.proc_write`, `.llseek` to `.proc_lseek`,
`.release` to `.proc_release`.

### Fix 3: Convert `file_operations` to `proc_ops` in sn_proc_fs.c

**File:** `arch/ia64/sn/kernel/sn2/sn_proc_fs.c` (new SN2 file)
**Kernel change:** v5.6 (same as Fix 2)
**Issue:** `proc_sn_topo_fops` changed to `proc_ops` with renamed
fields.  Note: `sn_hwperf.c` uses `misc_register()` which still takes
`file_operations` — no change needed there.

### Fix 4: `---help---` to `help` in Kconfig files

**Files:** `drivers/sn/Kconfig`, `drivers/misc/Kconfig` (new SN2 files)
**Kernel change:** v5.10 (Kconfig syntax cleanup)
**Issue:** `---help---` was removed as valid Kconfig syntax.  Changed
to plain `help` and ensured help text is indented with tab + two spaces.

---

## Changes NOT needed (evaluated and confirmed OK)

- **`mspec.c` maddr[0] to maddr[]**: Already done upstream in 5.10.
  The v5.5 patch context adjusted via fuzz/offset.
- **`ARCH_HAS_DMA_MARK_CLEAN`**: Unconditionally selected, harmless
  for SN2, does not need conditional guard.
- **`MODULE_SUPPORTED_DEVICE`**: Still present in v5.10 (removed v5.12).
- **`ioremap_nocache`**: Not used by SN2 code (only `ioremap`).
- **`sn_hwperf.c` file_operations**: Used with `misc_register()`, not
  `proc_create()` — still correct in v5.10.
- **IDE subsystem**: Still present in v5.10.
- **DMA ops structure**: `.mmap` and `.get_sgtable` fields still exist in
  `struct dma_map_ops`; only the header location changed (Fix 1).
- **`dma_ops` global variable**: Still exists in v5.10's
  `arch/ia64/kernel/dma-mapping.c`.
