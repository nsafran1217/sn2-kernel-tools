# SN2 Re-addition Patches v4 for Linux v5.4
# Compile-time CONFIG_IA64_SGI_SN2 approach (no machvec)

## Key Design: No Machvec Infrastructure

Unlike v3 which restored the full machvec dispatch system (21 files, 891 lines),
this patch set uses compile-time CONFIG_IA64_SGI_SN2 selection with:
- Minimal asm/machvec.h shim (ia64_platform_is() as compile-time check)
- #ifdef CONFIG_IA64_SGI_SN2 blocks in ~13 core ia64 files
- Weak symbol override for ia64_send_ipi (SN2 provides SHUB-based IPI)
- Direct #ifdef for TLB purge (SN2 SHUB deadlock avoidance)
- I/O function overrides via #ifdef in io.h (not machvec dispatch)

## Core ia64 impact: 13 files, +198/-10 lines (vs v3: 46 files, +877/-259)

## Patch Order

### 0001 - Drop-in: SN2 platform, headers, drivers, misc
  Pure file additions. SN2 platform code, headers, driver sources, pci_ids.h.
  Excludes: machvec.c (not needed), sgi_hotplug.c (not needed), hpsim.

### 0002 - machvec: minimal compatibility shim
  Creates arch/ia64/include/asm/machvec.h with ia64_platform_is() as a
  compile-time strcmp check. Replaces the entire 891-line machvec infrastructure.

### 0003 - kconfig: add SN2 platform config and build rules
  Adds CONFIG_IA64_SGI_SN2, CONFIG_SGI_SN to Kconfig.
  Adds ZONE_DMA32 depends on !IA64_SGI_SN2.
  Adds core-$(CONFIG_IA64_SGI_SN2) to arch Makefile.
  Sources drivers/sn/Kconfig.

### 0004 - ia64: add SN2 hooks to core code via ifdef
  The critical patch. Modifies 13 core ia64 files:
  - io.h: SN2 I/O override block (#define inb/outb/readb etc to SN2 versions)
  - mmiowb.h: SN2 custom MMIO write barrier
  - hw_irq.h: SN2 IRQ vector identity mapping
  - irq_ia64.c: weak ia64_send_ipi, sn_irq_init() call
  - setup.c: sn_setup(), sn_cpu_init() calls, early console, crashkernel
  - acpi.c: SN2 proximity domain fixes, IOSAPIC message suppress
  - msi_ia64.c: SN2 MSI delegation
  - sal.c: SN2 SAL version fix
  - smpboot.c: SN2 CPU disable check
  - uncached.c: SN2 cache flush
  - tlb.c: SN2 global TLB purge redirect
  - pci.c: SN2 PCI fixup_bus call
  - sn2_smp.c: ia64_send_ipi override via weak symbol

### 0005 - drivers: add SN2 driver Kconfig and Makefile entries
  Adds Kconfig options and Makefile rules for SN2 drivers:
  SGI_SNSC, SGI_TIOCX, SGI_MBCS, AGP_SGI_TIOCA, BLK_DEV_SGIIOC4,
  SGI_IOC4, SERIAL_SGI_L1_CONSOLE, SERIAL_SGI_IOC4, SERIAL_SGI_IOC3.
  Excludes: PCI hotplug.

### 0006 - drivers: add SN2 support to mspec, qla1280, qla2xxx
  Adds SN2 fetchop/uncached memory to mspec.c.
  Adds SN2 MMIO workarounds to qla1280 and qla2xxx SCSI drivers.

## Quick Apply

```bash
cd /path/to/linux-5.4
git apply sn2-v5.4-complete.patch
```

Or apply split patches:
```bash
cd /path/to/linux-5.4
for p in 000*.patch; do
    echo "Applying $p..."
    git apply "$p" || echo "FAILED: $p"
done
```

## Build Configuration

Enable SN2 support in your kernel config:
```
CONFIG_IA64_SGI_SN2=y
CONFIG_SGI_SN=y           # auto-selected
CONFIG_NUMA=y             # auto-selected
CONFIG_ACPI_NUMA=y        # auto-selected
CONFIG_SMP=y
# Driver options:
CONFIG_SGI_SNSC=y
CONFIG_SGI_TIOCX=y
CONFIG_SERIAL_SGI_L1_CONSOLE=y
CONFIG_SGI_IOC4=y
CONFIG_SERIAL_SGI_IOC4=y
CONFIG_SGI_IOC3=y
CONFIG_SERIAL_SGI_IOC3=y
CONFIG_BLK_DEV_SGIIOC4=y
```

## What's NOT Included (vs v3)

- Full machvec dispatch system (machvec.h, machvec_*.h, machvec.c)
- DIG/ZX1/UV/hpsim platform machvec definitions
- CONFIG_IA64_GENERIC multi-platform boot support
- HP simulator (hpsim) support
- PCI hotplug driver (sgi_hotplug.c)
- MEDUSA/fake-PROM simulator support
