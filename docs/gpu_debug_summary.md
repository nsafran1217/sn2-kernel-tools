# Radeon GPU on IA-64 via PLX PCI-to-PCIe Bridge — Full Debug Summary

## Goal

Get a discrete Radeon GPU working on IA-64 systems connected via a **PLX PEX 8111
PCI-to-PCIe bridge** in a PCI-X slot. The primary target is now **SGI Altix SN2**,
with the **HP Integrity rx2660** as a secondary target.

The `radeon` kernel DRM driver is used. `amdgpu` does not support these GPU generations.

---

## Hardware

### GPU

**Turks PRO [Radeon HD 7570]** — PCI ID `1002:675D`, Dell subsystem `1028:2B20`, 1 GB VRAM.

BAR requirements (hardwired in GPU silicon, not configurable):

| BAR | Size | Type | Purpose |
|-----|------|------|---------|
| BAR 0 | 256 MB | 64-bit prefetchable | VRAM aperture |
| BAR 2 | 128 KB | 64-bit non-prefetchable | MMIO registers (required for all GPU communication) |
| BAR 4 | 256 B | I/O | I/O ports (non-critical, radeon prints warning if missing but continues) |
| ROM | 128 KB | prefetchable | VBIOS |

All three available GPUs were tested on x86-64 — **all have 256 MB BAR 0**:

| GPU | Chip | BAR 0 | BAR 2 | Status |
|-----|------|-------|-------|--------|
| Radeon HD 7570 | Turks PRO | 256 MB | 128 KB | Same problem |
| Radeon HD 6350 | Cedar | 256 MB | 128 KB | Same problem |
| Radeon HD 4550 | RV710 | 256 MB | 64 KB | Same problem |

256 MB BAR 0 has been standard across all Radeon HD generations regardless of VRAM size.
A GPU with 128 MB BAR 0 would need to be pre-HD era (Radeon X1xxx or older).

### Bridge Adapter

**PLX Technology PEX 8111** (PCI ID `10B5:8111`, rev 21) — PCIe-to-PCI bridge.

Key characteristics:
- **32-bit PCI device** — upper-32 prefetchable registers (offsets 0x28, 0x2C) are hardwired to zero
- Cannot forward 64-bit prefetchable memory transactions
- Any 64-bit MMIO windows on the host bus are **unreachable** for downstream devices
- Has its own BAR 0 (64 KB, 64-bit prefetchable) which *can* use 64-bit space since it's the bridge itself
- PCIe x1 Gen1 (2.5 GT/s) upstream link

### Confirmed Working Configurations

The same GPU + PLX bridge combination works on:

1. **x86-64 (Intel Z87)**: Firmware gave the bridge a 257 MB non-prefetchable window
   (`0xe0000000–0xf00fffff`). BAR 0 + BAR 2 + ROM all fit. ROM was also mapped to
   the legacy VGA shadow at `0xc0000`. Driver loaded fully.

2. **HP Integrity rx2800i2 (IA-64, native PCIe)**: No PLX bridge needed. BAR 0 at
   `0x50000000`, BAR 2 at `0x68600000`, ROM at `0x68620000`. All assigned normally.
   VBIOS read via ROM BAR. Driver loaded fully. Confirms radeon + IA-64 works.

---

## System 1: HP Integrity rx2660 (zx2 Chipset)

### System Details

| Item | Value |
|------|-------|
| System | HP Integrity rx2660 |
| Architecture | IA-64 (Itanium 2) |
| Chipset | HP zx2 |
| OS | T2-SDE Linux 26.3 |
| Kernel | 6.19.5-t2 |
| Firmware | System Firmware B 4.15 (latest, June 2011) |
| I/O Backplane | All PCI-X (3 slots: 2x 266MHz, 1x 133MHz) |
| GPU slot | Slot 3 (bus 02, ACPI L003, quad-rope LBA) |
| IOC HPA | `0xfed01000` (zx2 IOC) |

### PCI Topology

```
Bus 00: root (ACPI L000) — ES1000 onboard VGA, USB, serial
Bus 01: root (ACPI L002) — SCSI (mpt), dual Broadcom NICs (tg3)
Bus 02: root (ACPI L003) — PLX PEX 8111 bridge (02:01.0)
Bus 03: downstream of PLX — HD 7570 (03:00.0), HDMI audio (03:00.1)
Bus 04: root (ACPI L006) — empty slot
Bus 05: root (ACPI L007) — empty slot
```

### Root Bus MMIO Windows (from firmware ACPI _CRS)

| Bus | 32-bit Window | 64-bit Window |
|-----|--------------|---------------|
| 00 (L000) | `0x80000000–0x8fffffff` (256 MB) | `0x80004000000–0x800ffffffff` |
| 01 (L002) | `0xa0000000–0xafffffff` (256 MB) | `0x80204000000–0x802ffffffff` |
| 02 (L003) | `0xb0000000–0xbfffffff` (256 MB) | `0x80304000000–0x803ffffffff` |
| 04 (L006) | `0xe0000000–0xefffffff` (256 MB) | `0x80604000000–0x806ffffffff` |
| 05 (L007) | `0xf0000000–0xfdffffff` (224 MB) | `0x80704000000–0x807ffffffff` |

Gap in 32-bit space: `0xc0000000–0xdfffffff` (512 MB) — **not routed to any bus**.

### The Problem

BAR 0 (256 MB) consumes the entire 32-bit window for bus 02. No space remains
for BAR 2 (128 KB), ROM (128 KB), or the audio device's BAR.

The 64-bit window is unreachable because the PLX PEX 8111 is a 32-bit PCI device
and cannot forward 64-bit transactions.

### Kernel Allocator Behavior (from remove/rescan test)

```
pci 0000:02:01.0: bridge window [mem 0xb0000000-0xbfffffff pref]: assigned
pci 0000:02:01.0: bridge window [mem size 0x00100000]: can't assign; no space
pci 0000:03:00.0: BAR 0 [mem 0xb0000000-0xbfffffff 64bit pref]: assigned
pci 0000:03:00.0: BAR 2 [mem size 0x00020000 64bit]: can't assign; no space
pci 0000:03:00.0: ROM [mem size 0x00020000 pref]: can't assign; no space
pci 0000:03:00.1: BAR 0 [mem size 0x00004000 64bit]: can't assign; no space
```

The allocator tries to expand the prefetchable window by 1 MB but fails:
```
pci 0000:02:01.0: bridge window [mem 0xb0000000-0xbfffffff pref]: failed to expand by 0x100000
```

### What Was Tried and Failed

| Approach | Result |
|----------|--------|
| `pci=realloc` | No effect — bus 02 window unchanged |
| `pci=realloc,assign-busses` | `assign-busses` not recognized on IA-64 |
| `pci=nocrs` | No effect on IA-64 (x86-only) |
| Manual setpci at `0xc0000000` | Writes succeed but `devmem2` read triggers **MCA crash** — chipset does not route `0xc0000000` to bus 02 |
| Different physical slot | All slots have ≤256 MB 32-bit windows |
| Different GPU (HD 6350, HD 4550) | All have 256 MB BAR 0 — same problem |
| ACPI DSDT patching | _CRS is computed dynamically by firmware, not patchable |

### rx2660 Remaining Path: LBA Register Widening (Not Yet Completed)

The zx2 chipset's LBA (Local Bus Adapter) controls MMIO decode windows via
programmable registers. The EFI `mm` command can modify these before booting Linux.

Key LBA register offsets (from `arch/parisc/include/asm/ropes.h`):

```c
#define LBA_LMMIO_BASE  0x0200  /* < 4GB MMIO window base */
#define LBA_LMMIO_MASK  0x0208  /* < 4GB MMIO window mask (controls size) */
#define LBA_ELMMIO_BASE 0x0250  /* Extra LMMIO range base */
#define LBA_ELMMIO_MASK 0x0258  /* Extra LMMIO range mask */
#define LBA_GMMIO_BASE  0x0210  /* > 4GB MMIO base */
#define LBA_GMMIO_MASK  0x0218  /* > 4GB MMIO mask */
```

LBA HPAs (estimated, based on IOC at `0xfed01000` and SBA_FUNC_SIZE=0x1000):
- Bus 00 LBA: `0xfed00000`
- Bus 02 LBA: `0xfed03000` (needs verification)

**To verify from EFI shell** (not yet done):
```
mm 0xfed00200 8 -n    # Bus 00 LMMIO_BASE (should be 0x80000000)
mm 0xfed00208 8 -n    # Bus 00 LMMIO_MASK
mm 0xfed03200 8 -n    # Bus 02 LMMIO_BASE (should be 0xb0000000)
mm 0xfed03208 8 -n    # Bus 02 LMMIO_MASK (should be 0xf0000000 = 256MB)
mm 0xfed03250 8 -n    # Bus 02 ELMMIO_BASE
mm 0xfed03258 8 -n    # Bus 02 ELMMIO_MASK
```

**Plan**: Change LMMIO_MASK from `0xf0000000` (256 MB) to `0xe0000000` (512 MB) from
EFI before booting Linux. This would extend bus 02's window from `0xb0000000–0xbfffffff`
to `0xb0000000–0xdfffffff`, providing space for BAR 2 and ROM. However, the MCA crash
at `0xc0000000` proved the chipset doesn't currently route that range — the LBA mask
change is needed precisely to make it route there. The IOC-level LMMIO routing registers
may also need adjustment.

IOC-level registers to check:
```
mm 0xfed01300 8 -n    # LMMIO_DIRECT0_BASE
mm 0xfed01308 8 -n    # LMMIO_DIRECT0_MASK
mm 0xfed01310 8 -n    # LMMIO_DIRECT0_ROUTE
mm 0xfed01360 8 -n    # LMMIO_DIST_BASE
mm 0xfed01368 8 -n    # LMMIO_DIST_MASK
mm 0xfed01370 8 -n    # LMMIO_DIST_ROUTE
```

**This path was paused in favor of investigating the SGI Altix SN2.**

---

## System 2: SGI Altix SN2 (Primary Target)

### System Details

| Item | Value |
|------|-------|
| System | SGI Altix SN2 (hostname: pople) |
| Architecture | IA-64 (Itanium 2) |
| I/O Chipset | SHUB + PIC ASIC |
| SAL | SGI SAL version 4.56 |
| CPUs | 2x Itanium 2 (1.5 GHz) |
| RAM | ~8 GB |
| OS | T2-SDE Linux 26.3 |
| Kernel | 7.0.0-rc1 custom build (cross-compiled) |
| Boot | NFS root via tg3 Ethernet |
| GPU slot | PCI-X slot on second PCI bus (domain 0002) |

### PCI Topology

```
Domain 0001 Bus 00: IOC4, VIA USB (UHCI+EHCI), VSC7174 SATA, BCM5701 NIC
Domain 0002 Bus 00: PLX PEX 8111 bridge (0002:00:02.0)
Domain 0002 Bus 01: HD 7570 (0002:01:00.0), HDMI audio (0002:01:00.1)
```

### Root Bus Resources

```
pci_bus 0001:00: root bus resource [io  0x800000080f400000-0x800000080f40ffff]
pci_bus 0001:00: root bus resource [mem 0x80000008c0000000-0x80000008c00fffff]
                                        (bus address [0x00000000-0x000fffff])  ← 1 MB

pci_bus 0002:00: root bus resource [io  0x800000080fe00000-0x800000080fe0ffff]
pci_bus 0002:00: root bus resource [mem 0x800000080ff00000-0x800000080fffffff]
                                        (bus address [0x00000000-0x000fffff])  ← 1 MB
```

**Only 1 MB of PCI bus address space** is declared per root bus. This is the SN2
PIC ASIC's "small window" — it directly maps the lowest 1 MB of PCI bus addresses
(bits 19:0 of the PIO address).

### SN2 PIO Address Translation

The SN2 uses a multi-level address translation for CPU PIO (Programmed I/O) access
to PCI devices. The CPU physical address format is:

```
Bits 63-60: 0xC (uncached)
Bits 48-38: NASID (node ID)
Bits 37-36: Address space
Bits 35-32: Big window / Global MMR space
Bits 27-24: Widget/host bus adapter number
Bits 23-20: Device register number (selects DEV_OFF for upper address bits)
Bits 19-0:  PCI bus address bits 19:0 (1 MB direct)
```

For PCI bus addresses above 1 MB, the PIC ASIC uses **device registers**:
- Each device register provides a 12-bit `DEV_OFF` value for PCI bus address bits 31:20
- Selected by bits 23:20 of the PIO address (up to 16 device registers per widget)
- Each device register maps a 1 MB window to a 1 MB-aligned region of 32-bit PCI bus space

For BAR 0 (256 MB at bus address `0x10000000`), this mechanism is **insufficient** —
it would need 256 device registers, but only ~16 exist per widget. The **big window**
mechanism (indicated by bits 35:32) would be needed for large contiguous BARs.

### BAR Assignment on SN2

Despite the 1 MB root bus resource, the SN2 PCI code assigned physical addresses:

```
Region 0: Memory at 80000008b0000000 (64-bit, prefetchable) [size=256M]   ← assigned
Region 2: Memory at 800000080fd00000 (64-bit, non-prefetchable) [size=128K] ← assigned
Region 4: I/O ports at 800000080fe01000 [size=256]                         ← assigned
```

But the kernel's resource framework reported:

```
pci 0002:00:02.0: bridge window [mem 0x10000000-0x1fffffff pref]: can't claim; no compatible bridge window
pci 0002:01:00.0: BAR 0 [mem 0x10000000-0x1fffffff 64bit pref]: can't claim; no compatible bridge window
pci 0002:00:02.0: BAR 0 [mem 0x00200000-0x0020ffff 64bit pref]: can't claim; no compatible bridge window
```

The BARs have physical addresses (from SN2 PIO translation) but the kernel doesn't
consider them validly claimed because the bus addresses fall outside the 1 MB root
bus resource.

### Crash on Driver Load

```
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (TURKS 0x1002:0x675D 0x1028:0x2B20 0x00).
[drm:radeon_device_init [radeon]] *ERROR* Unable to find PCI I/O BAR
Entered OS MCA handler. PSP=20000000fff21120 cpu=0 monarch=1
MCA: kernel context not recovered, iip 0xa000000202803460
```

The "Unable to find PCI I/O BAR" is a non-fatal warning (radeon continues without I/O ports).
The **MCA (Machine Check Abort)** occurred when the driver tried to access GPU registers
through BAR 2 MMIO. The physical address `0x800000080fd00000` is likely not properly
routed through the SHUB/PIC PIO translation hardware, despite appearing in lspci.

### Root Cause on SN2

The SN2 PROM firmware programmed the PLX bridge and GPU BARs at bus addresses that
exceed the 1 MB small window. The PIC ASIC's device registers and/or big window
translation is not properly configured for these addresses. When the radeon driver
calls `ioremap()` on the physical address and tries to read GPU registers, the PIO
transaction reaches the SHUB but has no valid translation to a PCI bus address,
causing a machine check.

This is fundamentally a **PIO address translation problem**, not a window size
problem like on the rx2660.

### What Needs Investigation for SN2

1. **Is BAR 2 accessible at all?** Test with `devmem2` before loading radeon:
   ```bash
   devmem2 0x800000080fd00000 w
   ```
   If this also MCAs, the PIO translation is completely broken for bus 0002 BARs
   above the 1 MB small window.

2. **SN2 kernel PCI source code**: How does the SN2 PCI host bridge driver handle
   resource assignment? Relevant source files to examine:
   ```bash
   find /path/to/kernel -name "*.c" -o -name "*.h" | \
     xargs grep -l "sn_pci\|sn2.*pci\|pcibr\|pic.*pci\|tiocp" 2>/dev/null
   ```
   Key questions:
   - How does `pci_resource_start()` return translated physical addresses on SN2?
   - Are the PIC device registers programmed for BAR bus addresses > 1 MB?
   - Is the big window mechanism used for large BARs?
   - Does `pci_enable_device()` succeed or fail for the GPU?

3. **PIC ASIC device register state**: Read the PIC's device registers to see if
   they're programmed for the GPU's BAR bus addresses. The PIC register layout
   is in the kernel source (look for `pic_widget_config` or similar structures).

4. **Bridge window vs root bus resource mismatch**: The PLX bridge claims a 4 MB
   non-prefetchable window (`0x00000000–0x003fffff`) and 256 MB prefetchable window
   (`0x10000000–0x1fffffff`) in bus address space, but the root bus resource is only
   1 MB. The kernel correctly reports "can't claim". The SN2 PCI code may need to
   either expand the root bus resource or properly handle the PIO translation for
   these larger ranges.

5. **Whether `pci_enable_device()` returns an error**: If it does, radeon should
   bail out before trying MMIO access. If it doesn't (perhaps SN2 code bypasses
   the resource check), the driver proceeds to ioremap an address that isn't
   properly translated, causing the MCA.

---

## Kernel Configuration for radeon on IA-64

```
CONFIG_DRM=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_USERPTR=y
CONFIG_FW_LOADER=y
CONFIG_HWMON=y
CONFIG_I2C=m
CONFIG_I2C_ALGOBIT=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
```

Required firmware files in `/lib/firmware/radeon/`:
`TURKS_me.bin`, `TURKS_pfp.bin`, `TURKS_mc.bin`, and others from linux-firmware.

An extracted VBIOS from the working rx2800i2 system is available at
`/lib/firmware/radeon/TURKS_vbios.bin` (may be needed if ROM BAR is inaccessible).

---

## Key Reference: SN2 PIO Address Translation (from SGI Documentation)

Source: "Linux Device Driver Programmer's Guide — Porting to SGI Altix Systems" (007-4520-007)

PCI memory BARs on SN2 are accessed through PIO. The PIO address the CPU issues
is completely different from the PCI bus address. The PCI resource addresses in the
`pci_dev` structure are already-translated PIO addresses that drivers use directly
with `ioremap()`.

The PIC ASIC provides:
- **Small window**: Bits 19:0 of PIO address map directly to PCI bus address bits 19:0 (1 MB)
- **Device registers**: 16 registers per widget, each providing a `DEV_OFF` (12-bit)
  value that replaces PCI bus address bits 31:20, mapping 1 MB windows to arbitrary
  1 MB-aligned 32-bit PCI bus addresses
- **Big window**: Alternate PIO address format (bits 35:32) for larger mappings

The document explicitly states: "Reading the BARs for an address to use as a PIO
will definitely not work on SGI Altix 3000 systems."

---

## Summary of Platform Comparison

| Aspect | rx2660 (zx2) | Altix SN2 (PIC) |
|--------|-------------|-----------------|
| 32-bit MMIO window | 256 MB (too small by 128 KB) | 1 MB (way too small) |
| 64-bit window | Exists but PLX can't use it | N/A (PIO translation) |
| BAR 0 assigned? | Yes (fills entire window) | Yes (physical addr shown) |
| BAR 2 assigned? | No (no space) | Yes (physical addr shown) |
| Driver result | Fails: can't enable device | MCA crash on MMIO access |
| Root cause | Window too small | PIO translation not set up |
| Fix approach | Widen LBA LMMIO mask from EFI | Fix SN2 PCI code for large BARs behind bridge |
| Complexity | Register poke from EFI + kernel resource fixup | Kernel PCI subsystem work |

---

## Files and Commands Quick Reference

```bash
# --- General ---
lspci -vvv -s <device>                    # Full device dump
dmesg | grep -iE "radeon|drm|BAR|bridge|claim|assign|window"

# --- rx2660 (EFI shell) ---
mm 0xfed03200 8 -n                        # Read LBA LMMIO_BASE for bus 02
mm 0xfed03208 8 -n                        # Read LBA LMMIO_MASK for bus 02
pci 00 02 01 -i                           # PLX bridge config space

# --- rx2660 (Linux) ---
setpci -s 02:01.0 20.W                    # Bridge memory base
setpci -s 02:01.0 22.W                    # Bridge memory limit
cat /proc/iomem                           # System MMIO map
echo 1 > /sys/bus/pci/devices/0000:02:01.0/remove  # Remove for rescan test
echo 1 > /sys/bus/pci/rescan                         # Rescan

# --- Altix SN2 ---
devmem2 0x800000080fd00000 w              # Test BAR 2 accessibility (may MCA!)
modprobe radeon                           # Load driver
echo "install radeon /bin/true" > /etc/modprobe.d/radeon-manual.conf  # Block autoload

# --- Cross-compilation (for Altix kernel) ---
# Kernel built on x86-64 host (NathanPC), NFS root at /t2/altixroot
# Kernel source at ~/altix_cross/src/mainline/linux-sn2/
# Boot via NFS: root=/dev/nfs nfsroot=10.40.0.120:/t2/altixroot,v3,tcp
```
