# SGI Altix Prism rtgfx Kernel Package Analysis

## Overview

This document analyzes the `kernel-rtgfx` package shipped by SGI for the
Altix Prism visualization workstation running SLES9 (SuSE Linux Enterprise
Server 9).  The goal is to determine what source code exists, whether any
binary blobs would prevent porting the ATI FireGL X3 graphics support to a
modern Linux kernel, and what the actual module loading dependencies are.

The hardware in question:

```
17:00.0 VGA compatible controller: ATI Technologies Inc R420 JM [FireGL X3] (rev 80)
        Subsystem: ATI Technologies Inc R420 JM [FireGL X3]
        Region 0: Memory at c0000041c8000000 (32-bit, prefetchable) [size=128M]
        Region 1: I/O ports at c000004023010000 [size=256]
        Region 2: Memory at c0000041c0100000 (32-bit, non-prefetchable) [size=64K]
```

The ATI R420 FireGL X3 was installed in a special AGP riser connected to
the TIO CA (TIOCA) ASIC, which bridges from the NUMAlink fabric to
AGP/PCI.

---

## Packages Examined

| Package | Type | Contents |
|---|---|---|
| `kernel-rtgfx-2.6.5-7.244.ia64.rpm` | Binary RPM | Kernel image, modules, config |
| `kernel-rtgfx-source-2.6.5-7.244.ia64.rpm` | Source RPM | Full kernel source tree |
| `kernel-rtgfx-2.6.5-7.244.src.rpm` | Source RPM | Spec file, patches, build scripts |
| `km-rtgfx-fglrx-2.6.5-7.244sgi403r1.ia64.rpm` | Binary RPM | ATI proprietary FireGL driver |
| `km_drm-4.3.99.902-43.71sgi403r1.ia64.rpm` | Binary RPM | DRM kernel module |

Additional km_ packages (all `.ko` modules, not analyzed in detail):
`km-rtgfx-arsess`, `km-rtgfx-csa`, `km-rtgfx-dmedia_devices`,
`km-rtgfx-frs`, `km-rtgfx-job`, `km-rtgfx-kbar`, `km-rtgfx-ml_sgc`,
`km-rtgfx-numatools`, `km-rtgfx-sgi-tape`, `km-rtgfx-uli`,
`km-rtgfx-ust`, `km-rtgfx-xpmem`, `km-rtgfx-xvm-standalone`.

---

## Key Source Files (All Open Source, GPL)

### TIOCA AGP GART Bridge Driver

**`drivers/char/agp/sgi-agp.c`** (338 lines)

The AGPGART bridge driver for the TIOCA ASIC.  Implements the Linux AGP
subsystem interface: GART table management, TLB flushing, NUMA-aware page
allocation (allocating from the closest node to the CA), AGP FastWrite
enablement, and AGP bridge registration.  Walks `tioca_list` at init time,
finds VGA-class devices with AGP capabilities, and registers an AGP bridge
for each.

Licensed: `MODULE_LICENSE("GPL and additional rights")`

Critical detail: **no `MODULE_DEVICE_TABLE`**.  This module cannot be
auto-loaded by udev.  See "Module Loading Problem" below.

### TIOCA Platform Provider

**`arch/ia64/sn/pci/tioca_provider.c`** (673 lines)

The platform-level TIOCA driver.  Compiled as `obj-y` (always built into
the kernel when SN2 is selected).  Responsibilities:

- Discovers TIOCA ASICs during SN2 platform init
- Initializes GART hardware and programs aperture MMRs
- Manages PCI and AGP DMA mapping (d64, d48, and GART-mapped modes)
- Handles TIOCA error interrupts via SAL calls
- Registers as SN2 PCI bus provider (`PCIIO_ASIC_TYPE_TIOCA`)
- Exports `tioca_list` and `tioca_gart_found` for use by `sgi-agp`

Licensed: GPL

### TIOCA Hardware Register Definitions

**`include/asm-ia64/sn/tioca.h`** (596 lines)

Full MMIO register layout for the TIO CA ASIC (`struct tioca`).  Includes
control, status, GART aperture, interrupt, and debug registers with all
bitmask and shift definitions.  Register offsets documented inline
(e.g. `ca_id` at 0x000000, `ca_control1` at 0x000008, etc.).

### TIOCA Provider Header

**`include/asm-ia64/sn/tioca_provider.h`** (207 lines)

Defines `struct tioca_kernel`, `struct tioca_common`, `struct tioca_dmamap`.
Contains inline functions for GART entry conversion
(`tioca_paddr_to_gart`, `tioca_physpage_to_gart`) and TLB flush logic
with RevA hardware workaround (PV910244).  Also defines workaround
tracking macros (`TIOCA_WAR_ENABLED`, `PV907908`, `PV908234`,
`PV895469`, `PV910244`).

### Build Integration

**`drivers/char/agp/Kconfig`** — adds `CONFIG_AGP_SGI_TIOCA` option,
depends on `AGP && (IA64_SGI_SN2 || IA64_GENERIC)`.

**`drivers/char/agp/Makefile`** — adds `obj-$(CONFIG_AGP_SGI_TIOCA) += sgi-agp.o`.

**`arch/ia64/sn/pci/Makefile`** — `tioca_provider.c` listed under `obj-y`
(always built-in).

---

## What Made the rtgfx Kernel Different

The rtgfx kernel was a **configuration flavor**, not a code fork.  The
standard SLES9 SN2 kernel (`sn2_defconfig`) was built for headless
rack-mount Altix servers.  The rtgfx flavor (`defconfig.rtgfx`) enabled
graphics support via config changes.

### Critical Config Differences (sn2 vs rtgfx)

| Option | sn2_defconfig | defconfig.rtgfx | Effect |
|---|---|---|---|
| `CONFIG_AGP` | not set | `=m` | AGP subsystem |
| `CONFIG_AGP_SGI_TIOCA` | not set | `=m` | TIOCA AGP bridge |
| `CONFIG_VGA_CONSOLE` | not set | `=y` | VGA text console |
| `CONFIG_FRAMEBUFFER_CONSOLE` | not set | `=y` | Framebuffer console |
| `CONFIG_PCI_CONSOLE` | not set | `=y` | PCI-based console |
| `CONFIG_FB_RADEON` | not set | `=m` | Radeon framebuffer |
| `CONFIG_FB_MATROX` | not set | `=m` | Matrox framebuffer |
| `CONFIG_DRM` | not set | **not set** | DRM was disabled |

The stock SN2 kernel had no code path to drive a display.  The rtgfx
kernel compiled in console support (`=y`) and shipped AGP and framebuffer
modules (`=m`).  **DRM was not enabled in either flavor.**

### No Binary Blobs in the Kernel

The only ELF binary in the source package is
`scripts/kconfig/libkconfig.so`, a standard kernel build tool.  Every
driver — TIOCA AGP, TIOCA platform provider, radeonfb — is GPL source.
There are no proprietary kernel components.

---

## The fglrx Driver (km-rtgfx-fglrx) — SGI-Modified Proprietary

**File:** `fglrx.ko` (924,387 bytes, ELF 64-bit IA-64, not stripped)

```
license=Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY
description=ATI Fire GL
depends=agpgart,usbcore
vermagic=2.6.5-7.244-rtgfx SMP ia64 gcc-3.3
```

### This is NOT a Stock ATI fglrx

The driver contains SGI-specific modifications, evidenced by:

**SGI adaptation layer — `firegl_snia.c`:**

An entire source file was added for SN2/IA-64 support.  Exported
functions:

| Symbol | Purpose |
|---|---|
| `__ke_firegl_snia_is_tioca()` | Checks if PCI bus provider is TIOCA |
| `__ke_firegl_snia_closest_node()` | Returns closest NUMA node to the GPU |
| `sn_attach_bdata()` | SN2 bridge data attachment |
| `sn_destroy_bdata()` | SN2 bridge data teardown |
| `sn_get_reg_address()` | SN2 register address lookup |

**Direct SN2 platform API usage (bypassing standard Linux DMA):**

| Imported Symbol | Purpose |
|---|---|
| `sn_dma_map_single` | SN2-specific DMA mapping |
| `sn_dma_unmap_single` | SN2-specific DMA unmapping |
| `sn_dma_flush` | SN2 DMA flush |
| `sn_io_addr` | SN2 I/O address translation |
| `__sn_mmiowb` | SN2 memory-mapped I/O write barrier |
| `physical_node_map` | NUMA physical node map |
| `numnodes` | NUMA node count |

A stock fglrx uses the standard Linux `dma_map_single`/`pci_map_single`
APIs.  This version calls SN2-specific functions directly.

**ImageSync (Genlock/Framelock) hardware support:**

The driver includes a PCI driver (`fglrx_isx_pci_driver`) matching SGI
ImageSync devices:

| Vendor | Device | Description |
|---|---|---|
| `0x10A9` (SGI) | `0x100C` | ImageSync device |
| `0x10A9` (SGI) | `0x100F` | ImageSync device |

Related strings in the binary:
- `"ImageSync Version 1 is unsupported on this platform, contact SGI for ImageSync Version 2 upgrade information"`
- `"unknown SGI device id: 0x%x"`
- `"Provider is TIOCA = %d"`

ImageSync provides genlock/framelock for multi-pipe synchronized
rendering on the Prism.

**Built-in AGP stack:**

fglrx bundles its own complete AGP GART implementation (`__fgl_agp_*`
symbols) and copies of several AGP chipset drivers (`ali_cleanup`,
`amd_irongate_cleanup`, `amd_8151_cleanup`).  String: `"Fire GL built-in
AGP-support"`.  The module depends on the kernel's `agpgart` but can
partially fall back to its own implementation.

---

## The radeonfb Problem — R420 Not Supported

The `radeonfb` module shipped in the rtgfx kernel does NOT support the
R420/FireGL X3.  The PCI device ID `1002:4A4D` (R420 JM) is absent from
the module alias list in `modules.alias`.  The radeonfb in kernel 2.6.5
only covers up through R350/RV350.  Zero occurrences of "R420" exist in
the radeonfb source.

This means **fglrx was the only driver that could drive the FireGL X3**
on SLES9.  The radeonfb could not even recognize the card.

---

## Module Loading Problem — Why "Only Works With rtgfx"

### The Dependency Chain

```
1. tioca_provider.c  (built-in, obj-y)
   └─ Runs at boot, discovers TIOCA ASICs, populates tioca_list
      Exports: tioca_gart_found, tioca_list, tioca_fastwrite_enable

2. agpgart.ko  (module)
   └─ AGP core subsystem
      Autoload trigger: char-major-10-175 alias (when /dev/agpgart opened)

3. sgi-agp.ko  (module, depends on agpgart.ko)
   └─ Walks tioca_list, finds VGA devices, registers AGP bridges
      Autoload trigger: *** NONE *** — no MODULE_DEVICE_TABLE

4. fglrx.ko  (module, depends on agpgart.ko)
   └─ ATI proprietary driver, needs AGP bridge already registered
      Autoload trigger: loaded by X11/manual
```

### The Root Cause

`sgi-agp.ko` has **no `MODULE_DEVICE_TABLE`**.  Compare with the Intel
i460 AGP driver on the same platform:

```c
/* i460-agp.c — HAS autoload support */
static struct pci_device_id agp_intel_i460_pci_table[] = { ... };
MODULE_DEVICE_TABLE(pci, agp_intel_i460_pci_table);

/* sgi-agp.c — NO autoload support */
module_init(agp_sgi_init);
module_exit(agp_sgi_cleanup);
MODULE_LICENSE("GPL and additional rights");
/* That's it. No device table. */
```

The TIOCA is not a PCI device (it's a NUMAlink ASIC), so there is no PCI
ID for udev to match against.  And `sgi-agp` doesn't match on the ATI
card's PCI ID either.  Nothing triggers the load automatically.

The `modules.alias` file from the binary kernel confirms this:

```
alias char-major-10-175 agpgart    ← only alias, triggers on /dev/agpgart open
                                    ← NO alias for sgi-agp at all
```

### How It Actually Worked on SLES9

The binary RPM does **not** contain an initrd — the post-install script
(`post.sh`) calls `mkinitrd` at install time to generate it.  The modules
that go into the initrd are determined by `/etc/sysconfig/kernel`
(`INITRD_MODULES` variable) on the installed system.

On a Prism, the installation process or system administrator would have
configured `INITRD_MODULES` to include `agpgart` and `sgi-agp`, or these
modules were loaded by the X11 startup scripts before fglrx was loaded.

The `agpgart` module would be triggered when X11 opens `/dev/agpgart`
(via the `char-major-10-175` alias), but `sgi-agp` still requires
explicit loading — either through initrd, a modprobe.d config, or a
startup script.

---

## Implications for Modern Linux

### No Binary Blobs Required

All kernel-side TIOCA/AGP code is GPL open source and already ported
forward in the SN2 patch set:

| File | Patch |
|---|---|
| `drivers/char/agp/sgi-agp.c` | Present in `sn2-v6.4-complete.patch`, `sn2-v6.6-complete.patch`, `sn2-v6.18-epic2-complete.patch` |
| `arch/ia64/sn/pci/tioca_provider.c` | Present in all patch versions |
| `include/asm-ia64/sn/tioca.h` | Present in all patch versions |
| `include/asm-ia64/sn/tioca_provider.h` | Present in all patch versions |
| `drivers/char/agp/Kconfig` | Updated for each kernel version |

### R420 Support in Modern Radeon

The mainline `radeon` DRM driver has supported R420 since approximately
Linux 2.6.30.  The open-source driver uses standard kernel DMA APIs,
which the SN2 platform layer (`tioca_provider.c`) handles transparently.
No SGI-specific driver modifications are needed — unlike fglrx, which
bypassed the standard DMA layer and required direct SN2 API calls.

### Recommended Kernel Config

Build AGP as built-in to eliminate the module loading ordering problem:

```
CONFIG_AGP=y
CONFIG_AGP_SGI_TIOCA=y
CONFIG_DRM=y
CONFIG_DRM_RADEON=y
CONFIG_VGA_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
```

If modules are preferred, add a modprobe softdep:

```
# /etc/modprobe.d/sgi-tioca.conf
softdep radeon pre: agpgart sgi-agp
```

Or include `agpgart` and `sgi-agp` in the initramfs module list.

### Card Firmware (VBIOS)

There is tribal knowledge that the firmware (VBIOS) on the Prism's ATI
cards differs from stock.  The VBIOS is stored on the card's ROM chip and
read by the radeon driver at probe time to configure connectors, clocks,
and memory timings.  If SGI modified the VBIOS, the radeon driver will
still parse and use it — this is standard behavior.

The only risk is if SGI's VBIOS uses non-standard ATOMBIOS/COMBIOS
command tables that the open-source radeon parser cannot handle.  This
would manifest as errors in dmesg during radeon probe.  If this occurs,
the custom firmware image would need to be supplied via the kernel's
firmware loading mechanism.

### What Will NOT Work Without Additional Effort

- **ImageSync (genlock/framelock):** This was SGI-proprietary hardware
  (PCI devices `10a9:100c` and `10a9:100f`) with support only in the
  modified fglrx.  There is no open-source ImageSync driver.  Multi-pipe
  synchronized rendering will not be available.

- **fglrx userspace:** The proprietary ATI userspace libraries (libGL,
  etc.) from the Prism era are IA-64 binaries linked against SLES9
  libraries and will not function on a modern system.  Use Mesa's open-source
  radeon/r300 Gallium driver instead.
