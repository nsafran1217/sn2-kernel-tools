# SN2 Re-addition Patches for Linux v5.4 (v2)

Split into 11 patches. Minimizes changes outside arch/ia64 and drivers.

Removed from v1: kernel/fork.c, kernel/irq/proc.c, sgi-xp partition
support, MAINTAINERS, Documentation, firmware.

Apply with: `git apply NN-*.patch`

## Application Order

### New files (drop-in, no conflicts on forward-port)

```
00-drivers-sn2-sources.patch  14 files  +10833  New SN2 driver source files
01-ia64-sn2-platform.patch    42 files  +11053  arch/ia64/sn/ platform code
02-ia64-sn2-headers.patch     35 files  +10031  arch/ia64/include/asm/sn/ headers
03-ia64-machvec-infra.patch   21 files    +891  Machvec dispatch system
04-ia64-hpsim.patch           17 files   +2592  HP Simulator (optional)
07-drivers-sn2-new.patch       3 files    +873  drivers/sn/ (IOC3)
```

### Build system (may need minor context adjustment)

```
05-ia64-build-system.patch    11 files  +166/-48  Kconfig, Makefiles, defconfigs
08-drivers-build-system.patch 16 files  +105/-6   Driver Kconfig/Makefile hookups
```

### Source modifications (most likely to need work on forward-port)

```
06-ia64-core-mods.patch       46 files  +877/-259  ia64 core: io.h, setup.c, acpi.c...
09-drivers-source-mods.patch   4 files  +198/-11   mspec.c, qla1280, qla2xxx
10-misc.patch                  1 file     +1/-0    include/linux/pci_ids.h
```

## What was excluded

- **kernel/fork.c** - ARCH_TASK_STRUCT_ALLOCATOR guard removal unnecessary;
  ia64 selects it so the guarded code is already compiled out
- **kernel/irq/proc.c** - is_affinity_mask_valid() adds a convenience check
  that SN2 works without
- **drivers/misc/sgi-xp/** - Cross-partition communication (XPC/XP/XPNET);
  not needed unless running partitioned SN2 configurations
- **MAINTAINERS, Documentation, firmware** - Non-essential metadata

## Notes

- Patch 04 (hpsim) is optional but some Kconfig conditionals reference
  IA64_HP_SIM. Without it they evaluate as always-false which is fine.
- The sn_sal.h fix (efi.sal_systab -> sal_systab_phys) is included.
- All driver modifications are guarded by CONFIG_IA64_SGI_SN2/GENERIC
  and ia64_platform_is("sn2") runtime checks.



for p in ~/altix_cross/sn2-kernel-tools/diff/sn2-5.x/*.patch; do
    echo "Applying $(basename $p)..."
    git apply "$p" || echo "FAILED: $p"
done