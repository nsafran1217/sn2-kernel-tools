# Radeon HD 7570 on SGI Altix SN2 — Confirmed Fixes

## Hardware Configuration

| Component | Details |
|-----------|---------|
| System | SGI Altix SN2 (hostname: pople) |
| CPU | 2× Itanium 2 (ia64), 7.8GB RAM |
| Page size | 4KB (kernel) |
| PCI bridge (SN2) | PIC ASIC PCI-X, IX-brick, widget 15 |
| PCIe bridge | PLX PEX8111 rev 21, **reverse mode** (PCI-X primary → PCIe secondary) |
| GPU | AMD Radeon HD 7570 (Turks, 0x1002:0x675D), 1GB GDDR5 |
| Kernel | 7.0.0-rc1-epic1-SN2 on T2-SDE Linux 26.3 (systemd) |

PCI topology:
```
0002:00:02.0  PLX PEX8111 (PCI-X side, host bridge)
  └── 0002:01:00.0  Radeon HD 7570 (PCIe side)
```

Required `setpci` before `modprobe radeon` (programs PLX prefetchable window):
```bash
setpci -s 0002:00:02.0 24.W=0x1000
setpci -s 0002:00:02.0 26.W=0x1ff0
```

---

## Fix 1 — WrReqWithResp Fatal Crash

**Status: CONFIRMED FIXED**

### Symptom
```
PCI BRIDGE ERROR: on 0002:00 [001c02:slot0:slab0:widget15:bus1]
    int_status is 0x2000000, err_status is 0x2000000
        25: Incoming request xtalk command word error bit set or invalid sideband
            Bridge Error Command Word Register <PACTYP=WrReqWithResp,TNUM=11>
PCI Bridge Error interrupt killed the system
Kernel panic - not syncing: pcibr_error_intr_handler(): Fatal Bridge Error
```

### Root Cause

`drm_need_swiotlb(40)` returned `true` on SN2 because NASID-encoded physical addresses (e.g. `0x302xxxxxxx`) push `max_pfn` beyond the 40-bit DMA threshold — a **false positive**. This caused TTM to use `dma_alloc_coherent` for every page allocation.

On SN2, `dma_alloc_coherent` routes through `pcibr_dma_map_consistent` → `pcibr_dmamap_ate32` with the `PCI32_ATE_BAR` (barrier) flag set in the ATE entry. The BAR attribute tells the PIC to issue `WrReqWithResp` xtalk packets rather than plain `WrReq` for DMA writes. The SN2 fabric rejects `WrReqWithResp` for devices behind a secondary bus (GPU behind PLX bridge) → fatal bridge error → kernel panic.

### Fix

**File:** `drivers/gpu/drm/radeon/radeon_device.c`

Force `rdev->need_swiotlb = false` on SN2. This makes TTM use `alloc_pages` + `dma_map_page` (streaming DMA) → `pcibr_dma_map` → `pcibr_dmatrans_direct32` → direct32 path (`0x8xxxxxxx` addresses, no ATE barrier flag) → plain `WrReq` → no crash.

```c
#ifdef CONFIG_IA64_SGI_SN2
    /* On SN2, NASID-encoded physical addresses cause drm_need_swiotlb()
     * to return true as a false positive. Streaming DMA (direct32) must
     * be used to avoid WrReqWithResp xtalk packets that crash the PIC. */
    rdev->need_swiotlb = false;
#endif
```

### Verification
After fix: all DMA shown as `path=direct32` in dmesg. WrReqWithResp crash never reappears.

---

## Fix 2 — no_wb=1 Silently Overridden for Turks

**Status: CONFIRMED FIXED**

### Symptom
Despite loading radeon with `no_wb=1`, dmesg always showed `WB enabled`. GPU DMA fence writes to system RAM triggered the same `WrReqWithResp` crash during modetest.

### Root Cause

In `radeon_wb_init()` in `radeon_device.c`:

```c
/* always use writeback/events on NI, APUs */
if (rdev->family >= CHIP_PALM) {
    rdev->wb.enabled = true;   /* silently overrides no_wb=1 */
    rdev->wb.use_event = true;
}
```

`CHIP_TURKS = 87 > CHIP_PALM = 83`, so `no_wb=1` was unconditionally ignored. WB causes the GPU to issue `PACKET3_EVENT_WRITE_EOP` — a DMA write of fence completion values to GTT (system RAM). This DMA write goes GPU → PCIe → PLX → PIC → xtalk. With Fix 1 in place (streaming DMA / direct32), these are plain `WrReq` packets. Without Fix 1, they were `WrReqWithResp` → crash.

With Fix 1 applied, WB can safely remain enabled because the DMA path no longer generates barrier-flagged ATEs. Both fixes together are required for full stability.

---

## Fix 3 — PIO Stall During modetest (Framebuffer CPU Writes)

**Status: CONFIRMED FIXED**

### Symptom
`modetest` would appear to hang for 10+ minutes. The system remained alive but the modetest process never completed. Color output was eventually visible but severely corrupted.

### Root Cause

CPU writes to VRAM (for the 5MB framebuffer at 1280×1024×32bpp) go through the path: CPU → SHUB → PIC → PLX → PCIe. With no write-combining, each 4-byte store is individually serialized through the PIC PIO path. ~1.3 million stores × serialization overhead = multi-minute stall.

### Fix

**File:** `drivers/gpu/drm/radeon/radeon_gem.c`

Force `CREATE_DUMB` buffers (used by modetest and Xorg for the scanout framebuffer) into GTT (system RAM) on SN2. The CPU writes to RAM at full speed; the GPU blit path (`radeon_move_blit`) copies GTT → VRAM via DMA when the BO is pinned to VRAM by `SETCRTC`.

```c
#ifdef CONFIG_IA64_SGI_SN2
    /* CPU writes to VRAM through PIC/PLX stall at one 4-byte store per
     * PIC serialization window. Force dumb buffers to GTT so CPU writes
     * go to system RAM; GPU handles GTT→VRAM blit via DMA. */
    args->domain = RADEON_GEM_DOMAIN_GTT;
#endif
```

---

## Fix 4 — Non-Fatal Bridge Error Handler Caused Unnecessary Freezes

**Status: CONFIRMED FIXED**

### Symptom
The bridge error interrupt handler called `panic()` on any bridge error, including PMU Access Fault (bit 30) which is non-fatal. Legitimate non-fatal conditions were killing the system.

### Root Cause

`pcibr_error_intr_handler()` in `arch/ia64/sn/pci/pcibr/pcibr_provider.c` used an unconditional `panic()` path. The handler did not differentiate fatal vs non-fatal error bits.

### Fix

**File:** `arch/ia64/sn/pci/pcibr/pcibr_provider.c`

Only freeze PIO (and panic) when SAL returns `ret < 0` (indicating a truly fatal bridge error). Non-fatal errors (bit 30: PMU Access Fault) log the error, dump bridge registers via the registered hook, and return without killing the system.

The patch also adds:
- `pcibr_pio_frozen` atomic flag checked in `r100_mm_wreg` to stop PIO operations after a fatal bridge error
- `pcibr_error_dump_hook` registration from radeon's IRQ init to dump the PIO trace buffer on bridge errors

---

## Fix 5 — pcibr_dma.c Parenthesis Bug

**Status: CONFIRMED FIXED**

### Symptom
Incorrect DMA address type selection, causing wrong DMA mapping paths to be taken.

### Root Cause

**File:** `arch/ia64/sn/pci/pcibr/pcibr_dma.c`, line 85:

```c
/* BUG: */
if (SN_DMA_ADDRTYPE(dma_flags == SN_DMA_ADDR_PHYS))

/* CORRECT: */
if (SN_DMA_ADDRTYPE(dma_flags) == SN_DMA_ADDR_PHYS)
```

The comparison was inside the macro call rather than outside it, always evaluating `dma_flags == SN_DMA_ADDR_PHYS` as a boolean (0 or 1) before passing to `SN_DMA_ADDRTYPE`.

---

## Fix 6 — PIC ATE Index Mismatch (GPU GART-Bypassing Engines)

**Status: CONFIRMED FIXED (color bars visible, corruption resolved with correct ATE indices)**

### Symptom
modetest showed color bars but with severe corruption. Initial implementation showed ATEs at wrong indices (e.g. `[36-115]` for framebuffer at offset `0x240000`).

### Root Cause — Architecture

The Evergreen/NI (Turks) GPU has two classes of engines with different memory access behavior:

- **GART-using engines** (CP, command processor): Read the GPU GART table → get the DMA bus address → issue PCIe transactions to that address.
- **GART-bypassing engines** (DCE4/5 display controller, rendering engines): Issue PCIe writes **directly** using the raw GPU MC address: `PCI32_MAPPED_BASE + gart_byte_offset` (i.e. `0x40000000 + offset`).

The PIC receives address `0x40000000 + X` from bypassing engines and computes:
```
ATE index = X >> IOPFNSHIFT
```
(From porting guide Figure 9-6: bits 29:12 are the ATE index for 4KB pages)

With streaming DMA (direct32, `0x8xxxxxxx` addresses), no ATE exists at those indices → PMU Access Fault (non-fatal) or WrReqWithResp (fatal).

### Root Cause — Bug in Initial Implementation

The original fix used `bo_mem->start` (TTM page index) directly as the ATE index. With 4KB kernel pages and `IOPFNSHIFT=12`, the correct formula is:

```
first_ATE = gart_byte_offset >> IOPFNSHIFT
           = (bo_mem->start × PAGE_SIZE) >> 12
           = bo_mem->start × 1          (correct for 4KB pages)
```

However, for 64KB pages (the common ia64 configuration): `IOPFNSHIFT=14`, so each CPU page covers 4 ATEs (`PAGE_SIZE / IOPGSIZE = 4`), and the correct first ATE is `gart_byte_offset >> 14`. The old code used `bo_mem->start` without accounting for `ates_per_page`.

### Fix

**Files:** `arch/ia64/sn/pci/pcibr/pcibr_ate.c`, `arch/ia64/include/asm/sn/pcibr_provider.h`, `drivers/gpu/drm/radeon/radeon_ttm.c`, `drivers/gpu/drm/radeon/radeon_object.c`, `drivers/gpu/drm/radeon/radeon.h`

#### New kernel function: `pcibr_ate_force()`

```c
/* arch/ia64/sn/pci/pcibr/pcibr_ate.c */
int pcibr_ate_force(struct pcibus_info *pcibus_info, int index,
                    unsigned long phys_addr)
```

Writes a PIC ATE at a **specific index** (not the next free index like `pcibr_ate_alloc`). Uses `PCI32_ATE_PREF` (not `PCI32_ATE_BAR`) to avoid `WrReqWithResp`.

#### GPU GART table fix in `radeon_ttm_backend_bind()`

For each GART page `T` at byte offset `gart_off`:

1. Compute `first_ate = gart_off >> IOPFNSHIFT`
2. For each sub-page `k` (0 to `ates_per_page - 1`): call `pcibr_ate_force(pcibus_info, first_ate + k, phys + k * IOPGSIZE)`
3. Override `ttm->dma_address[i] = PCI32_MAPPED_BASE + gart_off`

Step 3 is critical: instead of storing a direct32 address (`0x8xxxxxxx`) in the GPU GART table, store the ATE-range address (`0x4xxxxxxx + gart_off`). Now **both** code paths are consistent:

- GART-using engines: read GART → get `0x40000000 + gart_off` → issue PCIe read → PIC ATE `(gart_off >> IOPFNSHIFT)` → physical page ✓
- GART-bypassing engines: send PCIe write to `0x40000000 + gart_off` → PIC ATE `(gart_off >> IOPFNSHIFT)` → physical page ✓

#### GTT placement constraints

```c
/* radeon_object.c — radeon_ttm_placement_from_domain() */
#ifdef CONFIG_IA64_SGI_SN2
    rbo->placements[c].fpfn = SN2_GPU_GTT_FPFN;  /* skip coherent DMA ATEs */
    rbo->placements[c].lpfn = SN2_GPU_GTT_LPFN;  /* cap at ATE pool size */
#endif
```

Where (for 4KB pages):
- `SN2_TOTAL_ATES = 1024` (from `pic.h: p_int_ate_ram[1024]`)
- `SN2_ATE_COHERENT_RESERVE = PAGE_SIZE / IOPGSIZE = 1` (reserve ATE 0 for IH ring/MSI)
- `SN2_GPU_GTT_FPFN = 1`, `SN2_GPU_GTT_LPFN = 1024`

---

## Fix 7 — sn_pcidev_info_get Not Exported

**Status: CONFIRMED FIXED**

### Symptom
```
ERROR: modpost: "sn_pcidev_info_get" [drivers/gpu/drm/radeon/radeon.ko] undefined!
```

### Root Cause

`sn_pcidev_info_get()` in `arch/ia64/sn/kernel/io_common.c` existed but had no `EXPORT_SYMBOL`, making it invisible to loadable modules.

### Fix

**File:** `arch/ia64/sn/kernel/io_common.c`

```c
inline struct pcidev_info *
sn_pcidev_info_get(struct pci_dev *dev) { ... }
EXPORT_SYMBOL(sn_pcidev_info_get);   /* add this line */
```

---

## Current Status

| Test | Result |
|------|--------|
| `modprobe radeon` | ✅ Loads cleanly |
| VRAM/GTT detection | ✅ 1024M VRAM, 1024M GTT |
| Ring tests (rings 0, 3, 5) | ✅ Pass |
| IB tests (rings 0, 3, 5) | ✅ Pass |
| UVD | ✅ Initialized |
| fbdev console | ✅ 160×64 text console |
| `modetest -s 58@44:1280x1024` | ✅ Color bars visible |
| `X &` (no Mesa) | ✅ X server + xterm stable |
| `startx` with Mesa | ⚠️ GPU render writes to GTT bypass GART — further work needed |

---

## Remaining Known Issues

### MSI Interrupts Broken
```
salruntime_sn_intr_handler: Invalid provider_call 3
```
SAL firmware does not support interrupt routing queries for devices behind the PLX bridge. MSI initializes but the xtalk address programmed into the GPU is invalid. The driver falls back to `irq_poll` (fence timeout polling). This is functional but slower than interrupt-driven operation. No fix yet — would require SAL/PROM changes or a kernel workaround to synthesize valid xtalk interrupt addresses for bridge-attached devices.

### 3D / Mesa Acceleration
GPU rendering engines bypass the GPU GART and write render targets directly to GTT via PCIe. These writes hit PIC ATEs correctly (Fix 6 handles this), but Mesa/libdrm allocates render target BOs without coordinating with the kernel's SN2 ATE management. For stable 3D, render target BOs must either be in VRAM or the Mesa r600g driver must be made aware that GTT BOs on SN2 must stay within the ATE pool. This is a userspace-level constraint, separate from the kernel fixes above.

---

## Patch Files

| File | Description |
|------|-------------|
| `radeon_sn2_full_v4.patch` | Combined patch: all fixes above except `io_common.c` |
| `pcibr_provider.h` | Updated header with `pcibr_ate_force` / `pcibr_ate_force_free` declarations |

Apply with:
```bash
patch -p1 < radeon_sn2_full_v4.patch
# Then copy pcibr_provider.h to arch/ia64/include/asm/sn/pcibr_provider.h
# Then add EXPORT_SYMBOL(sn_pcidev_info_get) to arch/ia64/sn/kernel/io_common.c
```
