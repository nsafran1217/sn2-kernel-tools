# SN2 Radeon GPU — PIO Address Translation Worklog

## Date: 2026-04-08 — GPU SUCCESSFULLY INITIALIZED

---

## 1. Final Status: WORKING

The Radeon HD 7570 (Turks PRO) successfully initialized on SGI Altix SN2 via the
`radeon` DRM driver. Full KMS, VRAM, GART, UVD, and framebuffer console are operational.

```
ATOM BIOS: TURKS
radeon: VRAM: 1024M, BAR=256M, RAM width 128bits DDR
radeon: 1024M of VRAM memory ready
radeon: 1024M of GTT memory ready
PCIE GART of 1024M enabled
ring test on 0 succeeded in 5 usecs
ring test on 3 succeeded in 5 usecs
ring test on 5 succeeded in 2 usecs
UVD initialized successfully
ib test on ring 0 succeeded
ib test on ring 3 succeeded
ib test on ring 5 succeeded
Connectors: DP-1, DVI-I-1
fb0: radeondrmfb frame buffer device (160x64)
```

---

## 2. Root Cause and Fix

### The Problem

The Linux PCI subsystem's `pci_setup_bridge_mmio_pref()` in `drivers/pci/setup-bus.c`
disabled the PLX PEX 8111 bridge's prefetchable memory window during boot. It wrote
`0x0000FFF0` to `PCI_PREF_MEMORY_BASE` (base > limit = window disabled) because the
bridge window resource couldn't be claimed in the kernel's resource tree — the SN2
root bus memory resource is only 1 MB, while the prefetchable window spans 256 MB
(bus addresses 0x10000000–0x1FFFFFFF).

With the prefetchable window disabled, the PLX bridge did not forward PCI memory
transactions for addresses in the 0x10000000–0x1FFFFFFF range. The GPU's BAR 0
(256 MB VRAM aperture) lives at PCI bus address 0x10000000, so any access to VRAM
resulted in a PCI device select timeout and Machine Check Abort (MCA).

The non-prefetchable window (0x00000000–0x003FFFFF) was NOT cleared because its base
address (0x0000) overlaps with the start of the root bus resource. This allowed BAR 2
(GPU MMIO registers at bus address 0x00300000) to work.

### The Fix

Reprogram the PLX bridge's prefetchable memory base/limit registers:

```bash
setpci -s 0002:00:02.0 24.W=0x1000    # Pref base  → 0x10000000
setpci -s 0002:00:02.0 26.W=0x1FF0    # Pref limit → 0x1FFFFFFF
```

This must happen BEFORE loading the radeon driver. A kernel module is required to
make this persistent.

---

## 3. System Configuration

| Item | Value |
|------|-------|
| System | SGI Altix SN2 (hostname: pople) |
| CPU | 2× Itanium 2 (1.5 GHz) |
| RAM | ~8 GB |
| OS | T2-SDE Linux 26.3 |
| Kernel | 7.0.0-rc1 custom (cross-compiled, SN2 patches) |
| GPU | Turks PRO Radeon HD 7570 (1002:675D, Dell 1028:2B20, 1 GB VRAM) |
| Bridge | PLX PEX 8111 PCIe-to-PCI (10B5:8111 rev 21) |
| GPU Slot | PCI-X slot on domain 0002, widget 15 |
| Boot | NFS root via tg3 Ethernet |

### PCI Topology

```
Domain 0001 Bus 00: IOC4, VIA USB, VSC7174 SATA, BCM5701 NIC
Domain 0002 Bus 00: PLX PEX 8111 bridge (0002:00:02.0)
Domain 0002 Bus 01: HD 7570 (0002:01:00.0), HDMI audio (0002:01:00.1)
```

### GPU PIO Address Map (after sn_io_slot_fixup)

| BAR | PCI Bus Addr   | SN2 PIO Address         | Mechanism              |
|-----|----------------|-------------------------|------------------------|
| 0   | `0x10000000`   | `0x80000008B0000000`    | SHUB big window 4      |
| 2   | `0x00300000`   | `0x800000080FD00000`    | PIC small window       |
| 4   | `0x00001000`   | `0x800000080FE01000`    | PIC IO small window    |
| ROM | (shadow)       | `0x34F680D000`          | SAL-copied to RAM      |

### PLX Bridge Windows (must be programmed before driver load)

| Window | PCI Bus Addr Range        | Config Regs | Status |
|--------|---------------------------|-------------|--------|
| Non-pref | `0x00000000–0x003FFFFF` | 20.W/22.W   | Intact (kernel didn't clear) |
| Pref   | `0x10000000–0x1FFFFFFF`   | 24.W/26.W   | **Cleared by kernel — must restore** |

---

## 4. Remaining Issues

### 4.1. PCI I/O BAR Warning (Non-Fatal)

```
[drm:radeon_device_init] *ERROR* Unable to find PCI I/O BAR
[drm:radeon_atombios_init] *ERROR* Unable to find PCI I/O BAR; using MMIO for ATOM IIO
```

BAR 4 (I/O ports) has a valid PIO address but `pci_iomap()` may not handle SN2 PIO
addresses correctly for I/O space. The driver falls back to MMIO, which works fine.

### 4.2. MSI Interrupt Warning

```
salruntime_sn_intr_handler: Invalid provider_call 3
```

SN2 interrupt routing for devices behind the PLX bridge has limited MSI support.
The driver reports "using MSI" and ring/IB tests pass, so interrupts appear functional.
This warning may indicate a non-critical issue with the SN2 SAL runtime handler.

### 4.3. No GSI for Interrupt Routing

```
pci 0002:00:02.0: can't derive routing for PCI INT A
pci 0002:00:02.0: PCI INT A: no GSI
```

Standard PCI INTx routing is unavailable (no ACPI GSI). MSI is used instead.

### 4.4. Bridge Window Fix Must Persist

The `setpci` fix is lost on reboot. A kernel module (see Section 5) must be loaded
before radeon to reprogram the bridge window.

---

## 5. Kernel Module: sn2_plx_bridge_fix

### Purpose

Reprogram the PLX PEX 8111 bridge's prefetchable memory window before radeon loads.
The kernel's PCI subsystem disables this window during boot because the SN2 root bus
memory resource is too small to contain it.

### Source: sn2_plx_bridge_fix.c

```c
/*
 * sn2_plx_bridge_fix - Restore PLX PEX 8111 prefetchable bridge window
 *
 * The Linux PCI subsystem disables the PLX bridge's prefetchable memory
 * window on SN2 because the root bus resource is only 1 MB while the
 * window spans 256 MB. This module restores the window so that the
 * GPU's BAR 0 (VRAM aperture) is accessible.
 *
 * Load this module BEFORE radeon:
 *   modprobe sn2_plx_bridge_fix
 *   modprobe radeon
 *
 * Or add to /etc/modprobe.d/radeon.conf:
 *   softdep radeon pre: sn2_plx_bridge_fix
 */

#include <linux/module.h>
#include <linux/pci.h>

/* PLX PEX 8111 PCI ID */
#define PLX_VENDOR  0x10B5
#define PLX_DEVICE  0x8111

/* Prefetchable window: bus addresses 0x10000000 - 0x1FFFFFFF */
#define PREF_BASE_VAL   0x1000  /* bits 15:4 → addr bits 31:20 = 0x100 → 0x10000000 */
#define PREF_LIMIT_VAL  0x1FF0  /* bits 15:4 → addr bits 31:20 = 0x1FF → 0x1FFFFFFF */

static int __init sn2_plx_bridge_fix_init(void)
{
    struct pci_dev *bridge = NULL;
    u16 pref_base, pref_limit;

    while ((bridge = pci_get_device(PLX_VENDOR, PLX_DEVICE, bridge)) != NULL) {
        if (bridge->hdr_type != PCI_HEADER_TYPE_BRIDGE)
            continue;

        pci_read_config_word(bridge, PCI_PREF_MEMORY_BASE, &pref_base);
        pci_read_config_word(bridge, PCI_PREF_MEMORY_LIMIT, &pref_limit);

        pr_info("sn2_plx_bridge_fix: %s pref window: base=0x%04x limit=0x%04x\n",
                pci_name(bridge), pref_base, pref_limit);

        if (pref_base == 0xFFF0 && pref_limit == 0x0000) {
            pr_info("sn2_plx_bridge_fix: %s pref window DISABLED — restoring\n",
                    pci_name(bridge));

            pci_write_config_word(bridge, PCI_PREF_MEMORY_BASE, PREF_BASE_VAL);
            pci_write_config_word(bridge, PCI_PREF_MEMORY_LIMIT, PREF_LIMIT_VAL);

            /* Clear upper 32-bit pref base/limit (32-bit bridge) */
            pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, 0);
            pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);

            /* Verify */
            pci_read_config_word(bridge, PCI_PREF_MEMORY_BASE, &pref_base);
            pci_read_config_word(bridge, PCI_PREF_MEMORY_LIMIT, &pref_limit);
            pr_info("sn2_plx_bridge_fix: %s pref window restored: base=0x%04x limit=0x%04x\n",
                    pci_name(bridge), pref_base, pref_limit);
        } else {
            pr_info("sn2_plx_bridge_fix: %s pref window already enabled\n",
                    pci_name(bridge));
        }
    }

    return 0;
}

static void __exit sn2_plx_bridge_fix_exit(void)
{
    /* Nothing to undo — bridge window should stay programmed */
}

module_init(sn2_plx_bridge_fix_init);
module_exit(sn2_plx_bridge_fix_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Restore PLX PEX 8111 prefetchable bridge window on SN2");
MODULE_AUTHOR("SN2 GPU Project");
```

### Build (cross-compile)

```makefile
obj-m += sn2_plx_bridge_fix.o

KDIR ?= /path/to/linux-sn2-source

all:
    make -C $(KDIR) M=$(PWD) ARCH=ia64 CROSS_COMPILE=ia64-linux- modules

clean:
    make -C $(KDIR) M=$(PWD) clean
```

### Deployment

```bash
# Copy module to NFS root
cp sn2_plx_bridge_fix.ko /t2/altixroot/lib/modules/$(uname -r)/extra/

# Create modprobe dependency
echo "softdep radeon pre: sn2_plx_bridge_fix" > /t2/altixroot/etc/modprobe.d/sn2-gpu.conf

# Run depmod
depmod -a
```

---

## 6. Timeline of Debug Sessions

1. **Initial attempt**: radeon loaded but MCA'd immediately on MMIO access (BAR 2
   not reachable due to 1MB root bus resource on rx2660)
2. **Moved to SN2**: Different PIO architecture. SAL assigned PIO addresses but BAR 0
   access MCA'd with "PCI bus device select timeout"
3. **PIC register dump**: Confirmed PIC widget 15 accessible, device registers readable
4. **BAR 2 test**: Read at PIO addr 0x800000080FD00000 returned 0x0 — PIO works!
5. **BAR 0 MCA analysis**: PIC generated correct PCI bus addr 0x10000000, but PLX bridge
   didn't forward → prefetchable window was disabled
6. **PLX register check**: Pref base=0xFFF0, limit=0x0000 → confirmed kernel cleared it
7. **Bridge window restore**: `setpci` to reprogram pref window
8. **BAR 0 re-test**: `devmem2` returned VRAM data — PLX now forwarding
9. **radeon loaded**: Full initialization, framebuffer active ✓

---

## 7. Key Lessons

1. **SN2 PIO addresses ARE assigned by SAL for downstream bridge devices** — contrary to
   initial assumption. The `sal_get_pcidev_info()` call returns valid PIO mapped addresses
   including big window mappings for large BARs.

2. **The kernel's PCI resource framework actively disables bridge windows** it can't fit
   into the resource tree. On SN2 with small root bus resources, this breaks devices
   behind bridges with large memory windows.

3. **The non-prefetchable window survived** because its base address (0x00000000) overlaps
   with the root bus resource start. The prefetchable window (0x10000000+) was entirely
   outside and got disabled.

4. **MSI works on SN2 through PLX bridges** despite the lack of INTx routing (no GSI).
