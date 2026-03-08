# SN2 v4 Build Fixes

## Fix 001: arch/ia64/mm/init.c — arch_sync_dma_for_cpu redefinition

**Error:**
```
arch/ia64/mm/init.c:76:6: error: redefinition of 'arch_sync_dma_for_cpu'
```

**Cause:** Patch 0003 makes `ARCH_HAS_SYNC_DMA_FOR_CPU` conditional on SWIOTLB,
and SWIOTLB is disabled for SN2. When `ARCH_HAS_SYNC_DMA_FOR_CPU` is unset,
`include/linux/dma-noncoherent.h` provides a static inline no-op stub. But
`arch/ia64/mm/init.c` unconditionally defines the real function body, causing a
redefinition conflict.

**Fix:** Guard the function definition with `#ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU`.
SN2 has its own DMA via SHUB and doesn't use the SWIOTLB DMA sync path, so this
function is not needed for SN2 builds.

**File:** `arch/ia64/mm/init.c`
**Patch:** `fix-001-init-sync-dma.patch`

## Fix 002: Missing asm/machvec.h includes for ia64_platform_is

**Error:**
```
arch/ia64/sn/kernel/sn2/sn2_smp.c:556:14: error: implicit declaration of function 'ia64_platform_is'
```

**Cause:** 13 files call `ia64_platform_is()` but don't include `asm/machvec.h`
where it's defined. In the old machvec-based patches, this was pulled in
transitively through `asm/io.h` (which included `asm/machvec.h`). Our
compile-time approach doesn't add machvec.h to io.h's include chain.

**Fix:** Add `#include <asm/machvec.h>` to all 13 files. Also:
- Add `#define ia64_platform_is ia64_platform_is` to machvec.h so the
  preprocessor `#if !defined(ia64_platform_is)` guard in qla1280.c works
  correctly (it tests for a macro, not a function).
- Replace qla1280.c's buggy fallback macro (used `x` instead of `foo`)
  with a proper conditional `#include <asm/machvec.h>`.

**Files:**
- `arch/ia64/include/asm/machvec.h` — add `#define ia64_platform_is` self-ref
- `arch/ia64/sn/kernel/sn2/sn2_smp.c`
- `arch/ia64/sn/kernel/sn2/prominfo_proc.c`
- `arch/ia64/sn/kernel/sn2/sn_hwperf.c`
- `arch/ia64/sn/kernel/tiocx.c`
- `arch/ia64/sn/kernel/mca.c`
- `arch/ia64/sn/kernel/io_common.c`
- `drivers/sn/ioc3.c`
- `drivers/char/mbcs.c`
- `drivers/char/snsc.c`
- `drivers/char/mspec.c`
- `drivers/tty/serial/sn_console.c`
- `drivers/scsi/qla1280.c`
- `drivers/scsi/qla2xxx/qla_init.c`

**Patch:** `fix-002-missing-machvec-includes.patch`

## Fix 003: SN2 DMA ops never registered — boot failure

**Error (boot):**
```
tg3 0001:00:04.0: tg3_test_dma: Buffer write failed. err = -19
tg3 0001:00:04.0: DMA engine test failed, aborting
VFS: Unable to mount root fs via NFS, trying floppy.
```

**Cause:** With SWIOTLB disabled for SN2 and the machvec dispatch removed,
nothing calls `sn_dma_init()` to set the global `dma_ops` pointer to SN2's
custom SHUB-based DMA operations (`sn_dma_ops`). The pointer stays NULL,
causing all DMA operations to fail with -ENODEV. This breaks tg3 (network),
sata_vsc (SATA), and ide (PRD table allocation), preventing NFS root mount.

Previously `sn_dma_init()` was invoked via the machvec `platform_dma_init`
function pointer from `pci_iommu_alloc()`.

**Fix:** Call `sn_dma_init()` directly from `sn_setup()` after `sn_timer_init()`,
before any drivers that use DMA are initialized.

**File:** `arch/ia64/sn/kernel/setup.c`
**Patch:** `fix-003-sn-dma-init.patch`
