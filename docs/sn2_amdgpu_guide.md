# AMD Radeon GPU on SGI Altix SN2 (ia64) via PLX PEX8111 Bridge

## Overview

This document describes how to get an AMD Radeon R5 430 (Oland, GCN 1.0) working on an SGI Altix SN2 system with ia64 Itanium 2 processors. The GPU is a PCI Express card connected through a PLX PEX8111 PCI Express-to-PCI bridge operating in **reverse mode** (PCI-X primary, PCIe secondary), installed in a PCI-X slot on the Altix IX-brick.

### Hardware

- **System**: SGI Altix SN2 (hostname: pople)
- **CPUs**: Intel Itanium 2 (ia64), 2 CPUs
- **I/O**: PIC ASIC PCI-X bridge (IX-brick)
- **Bridge**: PLX PEX8111 PCI Express-to-PCI Bridge (rev 21), in reverse mode
- **GPU**: AMD Radeon R5 430 OEM (Dell, 2048MB GDDR5), PCI ID `1002:6611`, Oland/GCN 1.0
- **Display**: 1280x1024 LCD Monitor connected via DVI-I

### Software

- **Distribution**: T2-SDE Linux 26.3
- **Kernel**: 7.0.0-rc1 (custom build with SN2 and amdgpu support)
- **Init**: systemd
- **Driver**: amdgpu (in-tree, with SI support enabled)

### PCI Topology

```
0002:00:02.0 PCI bridge: PLX Technology, Inc. PEX 8111 (rev 21)  [PCI-X side]
  └── 0002:01:00.0 VGA: AMD/ATI Oland [Radeon R5 430]           [PCIe side]
```

The GPU sits on PCI domain 0002, bus 01 (secondary bus behind the PLX bridge). Other devices on domain 0002 bus 00 include IOC4, VIA USB, Vitesse SATA, and Broadcom Ethernet.

---

## Summary of Issues and Fixes

| # | Issue | Symptom | Fix | Status |
|---|-------|---------|-----|--------|
| 1 | PLX prefetchable window disabled | MCA crash on modprobe | `setpci` to configure prefetchable window | **Fixed** |
| 2 | UVD engine crashes system | Hard hang during UVD ring test | `ip_block_mask=0xffffff7f` to skip UVD | **Fixed (workaround)** |
| 3 | GPU interrupts not delivered | vblank timeouts, fence fallback timers, system hang | `irq_poll=1` timer-based polling | **Fixed (workaround)** |
| 4 | MSI not routed through PLX on SN2 | salruntime_sn_intr_handler errors | `msi=0` to force legacy INTx | **Fixed** |
| 5 | SN2 interrupt routing for bridge devices | IRQ 60 registered but handler not dispatched properly | Needs SN2 platform code fix | **TODO** |

---

## Detailed Findings

### 1. PLX PEX8111 Prefetchable Memory Window (Critical)

**Problem**: The PLX bridge's prefetchable memory forwarding window is disabled at boot. The GPU's BAR 0 (256MB VRAM) is at PCI bus address `0x10000000` and requires the prefetchable window to be open for PIO access. Without it, any access to VRAM triggers a Machine Check Abort (MCA).

**Root cause**: The SN2 firmware (SAL/PROM) configures the PLX bridge's bus numbers, non-prefetchable window, and I/O window, but does not enable the prefetchable window. The prefetchable base/limit registers are left in the disabled state (`base > limit`).

**PCI bus addresses assigned by firmware**:

| Resource | PCI Bus Address | Size | Window |
|----------|----------------|------|--------|
| PLX BAR 0 | 0x00200000 | 64KB | (bridge's own register space) |
| GPU BAR 0 (VRAM) | 0x10000000 | 256MB | Needs prefetchable |
| GPU BAR 2 (MMIO) | 0x00300000 | 256KB | Non-prefetchable (0x00000000-0x003FFFFF) |
| GPU BAR 4 (I/O) | 0x00001000 | 256B | I/O window |

**Fix**: Set the prefetchable window before loading the driver:

```bash
# Set prefetchable base = 0x10000000 (bits 15:4 → addr bits 31:20)
setpci -s 0002:00:02.0 24.W=0x1000

# Set prefetchable limit = 0x1FFFFFFF (bits 15:4 → addr bits 31:20)
setpci -s 0002:00:02.0 26.W=0x1ff0
```

This creates a 256MB prefetchable window from `0x10000000` to `0x1FFFFFFF`, exactly covering the GPU's VRAM BAR. The upper 32-bit prefetchable registers (offsets 0x28, 0x2C) are already zero, which is correct for 32-bit addressing.

**Note**: The non-prefetchable window (`0x00000000-0x003FFFFF`, 4MB) is already correctly configured by firmware and covers GPU BAR 2 (MMIO registers at `0x00300000`). No `setpci` is needed for it.

### 2. UVD (Unified Video Decoder) Engine Crash

**Problem**: The UVD IP block (block 7) causes a hard system hang during its ring test. All other engines (GFX, compute, SDMA) pass their ring tests successfully.

**Symptom**: After all GFX and SDMA ring tests succeed, the system hangs immediately upon entering the UVD ring test. No debug output appears from the UVD test function — the hang occurs at or before the test_ib callback. The L2 controller reports loss of console.

**Root cause**: Not yet determined. Possibly related to:
- UVD firmware loading doing DMA differently from other engines
- UVD accessing registers or memory ranges that aren't properly mapped
- UVD generating a specific type of interrupt or bus transaction the PLX bridge can't handle

**Fix (workaround)**: Disable UVD via the `ip_block_mask` parameter:

```bash
modprobe amdgpu ip_block_mask=0xffffff7f
```

Bit 7 corresponds to the UVD IP block. Setting it to 0 skips UVD initialization entirely. This disables hardware video decode but all other GPU functionality (3D, display, DMA) works.

### 3. GPU Interrupt Delivery

**Problem**: GPU interrupts (vblank, fence completion, etc.) are never delivered to the `amdgpu_irq_handler`. This causes:
- `vblank wait timed out on crtc 0` warnings (repeating)
- `Fence fallback timer expired on ring sdmaX` warnings
- `drm_fb_helper_damage_work` workqueue backup
- Eventual system hang from RCU stalls

**Analysis**: The interrupt path on SN2 is complex:
- IRQ 60 was allocated from PCI config space interrupt line byte (not from SN2 platform)
- `request_irq(60)` succeeded, installing `amdgpu_irq_handler` on IRQ 60
- The GPU generates interrupts that reach the SN2 SAL interrupt handler, which rejects them with `Invalid provider_call 3`
- The SN2 `sn_pci_fixup_slot` code did not set up proper IRQ routing for the GPU because `sn_irq_info->irq_irq` was 0 (no GSI for devices behind the PLX bridge)
- MSI also doesn't work through the PLX bridge on SN2

**Evidence from debug output**:
```
amdgpu 0002:01:00.0: SN2_DEBUG: irq_init: msi_ok=0 flags=0x1 pdev->irq=60
salruntime_sn_intr_handler:  Invalid provider_call 3
amdgpu 0002:01:00.0: SN2_DEBUG: IRQ installed: irq=60 msi_enabled=0
```

**Fix (workaround)**: A kernel timer that periodically calls the IH (Interrupt Handler) ring processor. This is implemented as a module parameter `irq_poll` that specifies the polling interval in milliseconds.

The timer callback calls `amdgpu_ih_process()` directly, which drains the GPU's IH ring buffer and dispatches vblank events, fence completions, and other interrupt-driven events.

**Modified files for irq_poll**:
- `drivers/gpu/drm/amd/amdgpu/amdgpu_irq.h` — add `irq_poll_timer` and `irq_poll_enabled` to struct
- `drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c` — add timer callback, setup in init, teardown in fini
- `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c` — add `irq_poll` module parameter
- `drivers/gpu/drm/amd/amdgpu/amdgpu.h` — add extern declaration

### 4. DMA Works Through PLX Bridge

**Key finding**: GPU DMA through the PLX bridge works correctly on SN2. The previous debug chats incorrectly assumed DMA was fundamentally broken. All ring tests pass:

```
SN2_DEBUG: ib test on gfx SUCCEEDED
SN2_DEBUG: ib test on comp_1.0.0 SUCCEEDED
SN2_DEBUG: ib test on comp_1.1.1 SUCCEEDED
SN2_DEBUG: ib test on sdma0 SUCCEEDED
SN2_DEBUG: ib test on sdma1 SUCCEEDED
```

The DMA path (GPU → PCIe → PLX → PCI-X → PIC ATE → SHUB → memory) functions correctly. The PIC ASIC's ATE translation handles addresses from the GPU properly. DMA addresses observed:

- Consistent mappings use ATE range: `dma=0x40000000` and above
- Streaming mappings use direct32: `dma=0x9d840000` (PCI32_DIRECT_BASE range)
- Both paths work because these addresses are **outside** the PLX bridge forwarding windows, so the PLX correctly forwards them **upstream** from PCIe to PCI-X

### 5. SN2 Platform Code Behavior

**PCI enumeration**: The SN2 SAL firmware correctly enumerates devices behind the PLX bridge. `sal_get_pcidev_info()` succeeds for the GPU at domain 2, bus 1, devfn 0. The firmware provides valid PIO-mapped addresses (`pdi_pio_mapped_addr[]`) and programs PIC device registers for the GPU's BARs.

**Bus fixup**: `sn_common_bus_fixup` is only called for root buses. For bus 01 (behind PLX), it returns early with `PCIIO_ASIC_TYPE_PPB`. The GPU's `pci_controller` is inherited from bus 00, so it gets the PIC's `pcibr_provider` for DMA mapping — this is correct.

**Resource addresses**: The kernel's PCI resources for the GPU contain valid SN2 PIO addresses:
```
Region 0: Memory at 80000008b0000000 (64-bit, prefetchable) [size=256M]
Region 2: Memory at 800000080fd00000 (64-bit, non-prefetchable) [size=256K]
Region 4: I/O ports at 800000080fe01000 [size=256]
```

**ioremap**: Works correctly. The `pci_resource_start()` returns the SN2 PIO-mapped address. `ioremap()` on ia64 adds the uncacheable region offset. On Itanium 2 with 50-bit physical addresses, extra bits are truncated harmlessly.

**devmem2 verification**:
```bash
# PIO to PLX bridge registers (tests PIO TO the bridge)
devmem2 0x800000080fc00000 w  →  0x811110B5 (PLX vendor/device ID) ✓

# PIO through PLX bridge to GPU BAR 2 (tests PIO THROUGH the bridge)
devmem2 0x800000080fd00000 w  →  0x0 (mmMM_INDEX default value) ✓
```

---

## Working Configuration

### Required setpci Commands (run before modprobe)

```bash
# Enable prefetchable memory window on PLX bridge for GPU VRAM
setpci -s 0002:00:02.0 24.W=0x1000
setpci -s 0002:00:02.0 26.W=0x1ff0
```

### Module Load Command

```bash
modprobe amdgpu ip_block_mask=0xffffff7f msi=0 runpm=0 irq_poll=1
```

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `ip_block_mask` | `0xffffff7f` | Disable UVD (bit 7) to prevent hang |
| `msi` | `0` | Force legacy INTx (MSI broken through PLX on SN2) |
| `runpm` | `0` | Disable runtime power management |
| `irq_poll` | `1` | Enable 1ms interrupt polling timer |

### Kernel Patches Required

Two categories of patches are applied to the kernel:

**1. Debug instrumentation** (can be removed once stable):
- `SN2_DEBUG` printks in amdgpu init, ring tests, and SN2 DMA mapping
- Controlled by `dev_info` — shows in dmesg at default log level

**2. IRQ polling timer** (required for functionality):
- Adds `irq_poll` module parameter to amdgpu
- Timer periodically calls `amdgpu_ih_process()` to drain GPU interrupt ring
- Files modified: `amdgpu_irq.h`, `amdgpu_irq.c`, `amdgpu_drv.c`, `amdgpu.h`

### Boot Automation

To make persistent across reboots, add to an init script or udev rule:

```bash
#!/bin/bash
# /etc/local.d/amdgpu-setup.start (or equivalent)
setpci -s 0002:00:02.0 24.W=0x1000
setpci -s 0002:00:02.0 26.W=0x1ff0
modprobe amdgpu ip_block_mask=0xffffff7f msi=0 runpm=0 irq_poll=1
```

---

## What Works

- **Display output**: Framebuffer console (160x64), mode setting, DVI-I output at 1280x1024@60Hz
- **GFX engine**: Ring tests pass, GPU command submission works
- **Compute engine**: Both compute rings (comp_1.0.0, comp_1.1.1) pass
- **SDMA engines**: Both DMA rings (sdma0, sdma1) pass
- **DMA**: Full bidirectional DMA through PLX bridge, including GART, fence writeback
- **VRAM**: 2048MB GDDR5 detected and usable via 256MB BAR window
- **GART**: 1024MB PCIE GART enabled
- **VBIOS**: Successfully fetched from ROM BAR
- **modetest**: Color bar test pattern displays correctly on monitor

## What Doesn't Work (Yet)

- **UVD**: Disabled (crashes system during ring test)
- **Hardware interrupts**: Using timer polling workaround; native interrupt delivery needs SN2 platform code fix
- **Extended PCI config space**: `System can't access extended configuration space` warning (cosmetic, does not affect functionality)
- **VSync**: Likely broken (vblank relies on polling timer rather than precise interrupt timing)

---

## Remaining Work

### Priority 1: Fix SN2 Interrupt Routing
The `salruntime_sn_intr_handler: Invalid provider_call 3` messages show GPU interrupts ARE reaching the SN2 interrupt subsystem but have no valid provider. The SN2 platform code needs to be patched to handle interrupts from devices on bus 01 (behind the PLX bridge). This would eliminate the need for the `irq_poll` workaround and fix vblank timing.

### Priority 2: Investigate UVD Crash
Determine why UVD initialization/ring test crashes the system. May require additional debug instrumentation in the UVD-specific code paths (`uvd_v3_1.c`).

### Priority 3: Automate PLX Bridge Setup
Write a PCI quirk or platform fixup that automatically configures the PLX bridge prefetchable window during PCI enumeration, eliminating the need for manual `setpci` commands.

### Priority 4: Test X11/Wayland and 3D Acceleration
Test with X server, Mesa, and OpenGL applications to verify full GPU functionality beyond framebuffer console and modetest.

---

## Reference: PLX PEX8111 Bridge Config Space

Key registers for the PLX bridge at `0002:00:02.0`:

| Offset | Register | Current Value | Notes |
|--------|----------|---------------|-------|
| 0x20-0x21 | Memory Base | 0x0000 | Non-pref window base: 0x00000000 |
| 0x22-0x23 | Memory Limit | 0x0030 | Non-pref window limit: 0x003FFFFF |
| 0x24-0x25 | Prefetch Base | 0x1000 | Prefetch base: 0x10000000 (after setpci) |
| 0x26-0x27 | Prefetch Limit | 0x1ff0 | Prefetch limit: 0x1FFFFFFF (after setpci) |
| 0x28-0x2B | Prefetch Base Upper | 0x00000000 | 32-bit addressing |
| 0x2C-0x2F | Prefetch Limit Upper | 0x00000000 | 32-bit addressing |

## Reference: GPU PCI Config Space BARs

| BAR | Config Offset | Raw Value | PCI Bus Address | Size | Type |
|-----|--------------|-----------|----------------|------|------|
| BAR 0 | 0x10-0x17 | 0x1000000C / 0x00000000 | 0x10000000 | 256MB | 64-bit prefetchable |
| BAR 2 | 0x18-0x1F | 0x00300004 / 0x00000000 | 0x00300000 | 256KB | 64-bit non-prefetchable |
| BAR 4 | 0x20-0x23 | 0x00001001 | 0x00001000 | 256B | I/O |

## Reference: DMA Address Ranges

| Range | Type | Usage |
|-------|------|-------|
| 0x00000000-0x3FFFFFFF | PCI32_LOCAL_BASE | PIO device registers (small window) |
| 0x40000000-0x7FFFFFFF | PCI32_MAPPED_BASE | ATE-mapped DMA (32-bit) |
| 0x80000000-0xFFFFFFFF | PCI32_DIRECT_BASE | Direct-mapped DMA (32-bit) |

GPU DMA addresses in the ATE-mapped and direct-mapped ranges are **outside** the PLX bridge forwarding windows, so the PLX correctly forwards them upstream from PCIe to PCI-X, where the PIC ASIC performs ATE translation to system physical addresses.
