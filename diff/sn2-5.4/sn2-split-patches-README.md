# SN2 Re-addition Patches for Linux v5.4

Split into 11 patches, ordered for logical application.
Apply with: `git apply --stat NN-*.patch && git apply NN-*.patch`

## Application Order

### New files (drop-in, no conflicts expected on forward-port)

```
01-ia64-sn2-platform.patch    42 files  +11053    arch/ia64/sn/ - all SN2 platform code
02-ia64-sn2-headers.patch     35 files  +10031    arch/ia64/include/asm/sn/ - SN2 headers
03-ia64-machvec-infra.patch   21 files    +891    machvec dispatch system (dig, zx1, uv, sn2)
04-ia64-hpsim.patch           17 files   +2592    HP Simulator (optional, can skip)
07-drivers-sn2-new.patch       3 files    +873    drivers/sn/ (IOC3, Kconfig, Makefile)
```

### Build system changes (may need minor adjustment on forward-port)

```
05-ia64-build-system.patch    11 files  +166/-48  Kconfig system type menu, Makefiles, defconfigs
08-drivers-build-system.patch 17 files  +115/-9   Driver Kconfig/Makefile hookups
```

### Source modifications (most likely to need work on forward-port)

```
06-ia64-core-mods.patch       46 files  +877/-259 ia64 core: io.h, setup.c, acpi.c, sba_iommu.c...
09-drivers-source-mods.patch  12 files  +541/-31  mspec.c, sgi-xp/*, qla1280, qla2xxx
10-core-kernel.patch           2 files   +14/-2   kernel/fork.c, kernel/irq/proc.c
11-misc.patch                  4 files   +23/-1   MAINTAINERS, Documentation, pci_ids.h, firmware
```

## Notes

- Patches 01-04 and 07 are pure file additions - they will apply cleanly to any
  kernel version that doesn't already have these files.

- Patch 04 (hpsim) is optional. Many Kconfig conditionals reference IA64_HP_SIM;
  without it, those evaluate as always-false which is fine for SN2.

- Patch 06 is the hardest to forward-port. It modifies 46 existing ia64 source
  files to integrate machvec dispatch. Key files to watch: io.h, setup.c,
  sba_iommu.c, acpi.c, dma-mapping.c.

- The sn_sal.h fix (efi.sal_systab -> sal_systab_phys) is already included.

## Quick apply to v5.4

```bash
cd /path/to/linux-5.4
for p in /path/to/patches/*.patch; do
    echo "Applying $(basename $p)..."
    git apply "$p" || echo "FAILED: $p"
done
```
