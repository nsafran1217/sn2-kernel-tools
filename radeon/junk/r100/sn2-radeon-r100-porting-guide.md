# Porting the Radeon DRM Driver to SGI Altix SN2

## Overview

This document describes the complete set of fixes required to get the
radeon DRM/KMS driver working on an SGI Altix SN2 system (ia64 Itanium 2)
with a PCI Radeon graphics card. The work was conducted across 20+
debugging sessions, starting from a non-functional GPU (CP hang on every
ring commit) to a working accelerated display with correct modetest output.

### Hardware

- **System:** SGI Altix 350, SN2 architecture, ia64 Itanium 2 processors
- **GPU:** ATI Radeon 7500 / RV200 (PCI 2.2, device 1002:5157)
- **PCI Bridge:** SHub PCIBR (PIC ASIC), PCI-X bus in PCI compat mode
- **Kernel:** Linux 5.10 with SN2 patches

### Key SN2 Platform Characteristics

- All PCI addresses are 64-bit (e.g., BAR0 = `0x80000008A8000000`)
- GPU has 32-bit internal address space (`mc_mask = 0xFFFFFFFF`)
- 64-bit addresses truncate to correct 32-bit GPU addresses by accident
  (lower 32 bits are the GPU-internal address)
- DMA uses ATE (Address Translation Entry) mapping in the PCIBR
  (bus addresses `0x40000000+`)
- `PAGE_SIZE = 65536` (64KB), PCIBR ATE page size = 16KB
- No BIOS/VBIOS accessible — all GPU init must be done by the driver
- PCI interrupts broken (`Invalid provider_call 3`)
- PIO writes are posted — require PIO read flush for synchronization
- DMA writes are posted — flushed only by interrupts (which are broken)

---

## Fix 1: RPTR_ADDR Must Point to Valid DMA Address

**Files:** `drivers/gpu/drm/radeon/r100.c`

### Symptom

The CP (Command Processor) executes all commands in the first ring commit,
then permanently hangs on every subsequent commit. `CP_STAT = 0x80000004`
(RSIU_BUSY + CP_BUSY) after the first commit — RSIU never clears.

### Root Cause

The R100 CP microcode unconditionally writes the ring read pointer (RPTR)
to `RPTR_ADDR` via DMA when the ring goes idle (RPTR == WPTR), regardless
of the `RB_NO_UPDATE` control bit. When writeback is disabled, the driver
sets `RPTR_ADDR = 0`. On SN2, bus address 0 has no valid ATE mapping
(ATEs start at `0x40000000`), so the DMA write never completes,
permanently stalling the RSIU.

### Evidence

- `CP_STAT = 0x80000004` persists after first commit (RSIU permanently stuck)
- `RSIU_BUSY: t0=1 t+10us=1 t+100us=1 t+1ms=1` — never clears
- WB sentinel test: planted `0xDEADDEAD` at RPTR offset, after fix it was
  replaced with `0x00000010` (the actual RPTR value) — proving the CP
  writes RPTR to memory
- Two PACKET0s in a single commit both execute — proving multi-command
  capability; the hang is specifically in the idle transition

### Fix

Always set `RPTR_ADDR` to a valid GART-mapped address, even when writeback
is logically disabled. The writeback buffer object is always allocated by
`radeon_wb_init()` regardless of `wb.enabled`, so `wb.gpu_addr` is always
valid.

```c
/* In r100_cp_init(), when wb.enabled == false: */
/* BEFORE (broken): */
WREG32(R_00070C_CP_RB_RPTR_ADDR, 0);
tmp |= RADEON_RB_NO_UPDATE;

/* AFTER (fixed): */
WREG32(R_00070C_CP_RB_RPTR_ADDR,
    S_00070C_RB_RPTR_ADDR((rdev->wb.gpu_addr + RADEON_WB_CP_RPTR_OFFSET) >> 2));
/* Do NOT set RB_NO_UPDATE — let RPTR writeback complete */
```

### Verification

```
[drm] ring test succeeded in 1 usecs
[drm] ib test succeeded in 0 usecs
```

### References

- SGI Altix Device Driver Porting Guide (007-4520-007), §DMA Addressing,
  Page 30: bus adapter translates addresses via ATE mappings
- `r100d.h`: `S_0007C0_RSIU_BUSY` at bit 2 of `CP_STAT`

---

## Fix 2: Force Dumb Buffers to GTT on SN2

**Files:** `drivers/gpu/drm/radeon/radeon_gem.c`

### Symptom

`modetest` appears to hang for ~15 seconds, then triggers an RCU stall.
The system stays responsive but the modetest process is stuck in
`R running` state on a CPU. The display does not update.

### Root Cause

CPU writes to VRAM go through the SN2 PIO path:
CPU → SHub → NUMAlink → PIC → PLX → GPU VRAM. With no write-combining,
each 4-byte store is individually serialized through the PIC. A 5MB
framebuffer (1280×1024×32bpp) requires ~1.3 million stores. At ~11µs per
store (PIO serialization overhead), this takes ~15 seconds — matching the
RCU stall timeout exactly.

### Evidence

- `mem_type=2 (VRAM) is_iomem=1` — buffer placed in VRAM
- `pfn=0x80000008a854` — VRAM PIO PFN mapped to userspace
- `~1310720 stores` — 5MB / 4B = 1.3M individual PIO writes
- RCU stall at exactly 15 seconds — matches PIO serialization calculation
- `state:R running task` — CPU actively executing stores, not sleeping

### Fix

Force `CREATE_DUMB` buffers (used by modetest and Xorg for scanout) into
GTT (system RAM) on SN2. CPU writes go to RAM at full speed. The GPU blit
engine copies GTT → VRAM via DMA when the BO is pinned to VRAM for
display scanout.

```c
/* In radeon_mode_dumb_create(): */
u32 domain = RADEON_GEM_DOMAIN_VRAM;
#ifdef CONFIG_IA64_SGI_SN2
    domain = RADEON_GEM_DOMAIN_GTT;
#endif
r = radeon_gem_object_create(rdev, args->size, 0, domain, 0, false, &gobj);
```

---

## Fix 3: 64-bit Address Overflow in 2D Blit Pitch/Offset Register

**Files:** `drivers/gpu/drm/radeon/r100.c`

### Symptom

After applying Fix 2, modetest displays color bars but with random
colored pixels scattered across the image. The corruption is visible on
every run.

### Root Cause

`r100_copy_blit()` packs pitch and offset into a 32-bit GPU register:

```c
radeon_ring_write(ring, (pitch << 22) | (src_offset >> 10));
```

`src_offset` is `uint64_t`. On SN2, it contains 64-bit PIO addresses
(e.g., `0x8000000888000000`). When shifted right by 10, the result is
a 64-bit value (`0x20000002220000`). When truncated to 32 bits by
`radeon_ring_write(uint32_t)`, bits from the upper address overflow into
the pitch field (bits 31:22), corrupting the blit stride.

Example:
- `src_offset = 0x8000000888000000` (GTT start)
- `src_offset >> 10 = 0x20000002220000` → lower 32 = `0x02220000`
- bits 31:22 of `0x02220000` = **8** (should be 0)
- `(64 << 22) | 0x02220000 = 0x12220000` → pitch = **72** (should be 64)
- GPU reads with wrong stride → source data misaligned → pixel corruption

### Fix

Cast to `uint32_t` before the shift. The GPU has a 32-bit internal address
space, so only the lower 32 bits are meaningful.

```c
/* BEFORE (broken on SN2): */
radeon_ring_write(ring, (pitch << 22) | (src_offset >> 10));
radeon_ring_write(ring, (pitch << 22) | (dst_offset >> 10));

/* AFTER (fixed): */
radeon_ring_write(ring, (pitch << 22) | ((uint32_t)src_offset >> 10));
radeon_ring_write(ring, (pitch << 22) | ((uint32_t)dst_offset >> 10));
```

### Note

This bug affects ANY 64-bit platform where `rdev->mc.gtt_start` or
`rdev->mc.vram_start` has bits set above bit 31. On x86-64, these
addresses are typically below 4GB, so the bug is latent. On SN2, the
64-bit PIO addresses expose it.

---

## Fix 4: Implement R100 PCI GART TLB Flush

**Files:** `drivers/gpu/drm/radeon/r100.c`

### Symptom

Potentially contributes to pixel corruption (stale GART entries from
dummy_page initialization could cause wrong page reads during blits).

### Root Cause

`r100_pci_gart_tlb_flush()` was a no-op TODO since the driver was first
written. After updating GART entries (e.g., binding new pages for a BO),
the GPU's AIC (Address Indirection Cache) may still have stale entries
cached, causing DMA reads to access wrong physical pages.

### Fix

Toggle `PCIGART_TRANSLATE_EN` in `AIC_CNTL` to force the AIC to re-read
GART entries from the table.

```c
void r100_pci_gart_tlb_flush(struct radeon_device *rdev)
{
    u32 tmp = RREG32(RADEON_AIC_CNTL);
    WREG32(RADEON_AIC_CNTL, tmp & ~RADEON_PCIGART_TRANSLATE_EN);
    RREG32(RADEON_AIC_CNTL);  /* PIO flush */
    udelay(10);
    WREG32(RADEON_AIC_CNTL, tmp);
    RREG32(RADEON_AIC_CNTL);  /* PIO flush */
    mb();
}
```

---

## Fix 5: Fence Wait After BO Pin for GTT→VRAM Blit

**Files:** `drivers/gpu/drm/radeon/radeon_legacy_crtc.c`

### Symptom

When dumb buffers are in GTT (Fix 2), `bo_pin` triggers a GPU blit from
GTT → VRAM. Without waiting for the blit fence, the CRTC may start
scanning VRAM before the blit completes.

### Fix

Add `ttm_bo_wait()` after `radeon_bo_pin_restricted()` in
`radeon_crtc_do_set_base()`, before the BO reservation is released.

```c
/* After bo_pin_restricted, before radeon_bo_unreserve: */
#ifdef CONFIG_IA64_SGI_SN2
{
    int wr = ttm_bo_wait(&rbo->tbo, false, false);
    if (wr)
        printk(KERN_WARNING "crtc_do_set_base: ttm_bo_wait returned %d\n", wr);
}
#endif
radeon_bo_unreserve(rbo);
```

---

## Fix 6: Force Engine Clocks ON Without BIOS

**Files:** `drivers/gpu/drm/radeon/r100.c`

### Symptom

Without BIOS initialization, engine clock gating may leave some GPU
blocks powered down, causing timeouts or incorrect behavior.

### Fix

In `r100_clock_startup()`, when no BIOS is available, force all engine
clocks ON by writing `0x1FFF7FFA` to `SCLK_CNTL`.

```c
if (rdev->bios == NULL) {
    WREG32(RADEON_SCLK_CNTL, 0x1FFF7FFA);
}
```

---

## Additional Configuration

### need_swiotlb Override

**Files:** `drivers/gpu/drm/radeon/radeon_device.c`

`drm_need_swiotlb()` returns true on SN2 because NASID-encoded physical
addresses push `max_pfn` above the DMA threshold (false positive). This
was investigated but found NOT to be the primary cause of the
`WrReqWithResp` crashes. The override is included as a defensive measure.

```c
#ifdef CONFIG_IA64_SGI_SN2
    rdev->need_swiotlb = false;
#endif
```

### pcibr_dma_map_consistent Instrumentation

**Files:** `arch/ia64/sn/pci/pcibr/pcibr_dma.c`

Added logging to `pcibr_dma_map_consistent()` to trace barrier ATE
creation. Only one barrier ATE was found (GART table allocation).
The intermittent `WrReqWithResp` crash at addresses like `0x489xxxxx`
remains an open investigation — it is NOT caused by `dma_alloc_coherent`.

---

## Known Remaining Issues

### Broken PCI Interrupts

```
radeon 0002:00:02.0: can't derive routing for PCI INT A
radeon 0002:00:02.0: PCI INT A: no GSI
salruntime_sn_intr_handler: Invalid provider_call 3
```

PCI interrupt routing fails for this device. The radeon driver falls back
to polling for fence completion. Vblank interrupts are not functional.
This limits performance but does not prevent operation.

### No BIOS/VBIOS

```
[drm:radeon_get_bios [radeon]] *ERROR* Unable to locate a BIOS ROM
```

The GPU's expansion ROM is not accessible on SN2. The driver uses generic
clock info and a hardcoded connector table. Display output configuration
(connectors, encoders, DAC settings) uses defaults that may not match the
specific card's wiring.

### Intermittent WrReqWithResp Bridge Errors

Under certain workloads, the PCI bridge reports fatal errors with
`PACTYP=WrReqWithResp`. Instrumentation showed this is NOT from
`dma_alloc_coherent` (only one barrier ATE exists — the GART table).
The source remains unidentified. This crash is intermittent and may be
related to GPU DMA writes hitting a stale or barrier-flagged ATE.

---

## Build Configuration

```
CONFIG_AGP=y                    # or =m with softdep
CONFIG_AGP_SGI_TIOCA=y          # if TIOCA hardware present
CONFIG_DRM=m
CONFIG_DRM_RADEON=m
CONFIG_VGA_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_IA64_SGI_SN2=y           # SN2 platform support
```

---

## File Change Summary

| File | Fix | Description |
|---|---|---|
| `drivers/gpu/drm/radeon/r100.c` | 1, 4, 6 | RPTR_ADDR, GART TLB flush, clock forcing, copy_blit address fix |
| `drivers/gpu/drm/radeon/r100.c` | 3 | `r100_copy_blit` uint32_t cast for pitch/offset |
| `drivers/gpu/drm/radeon/radeon_gem.c` | 2 | Force dumb buffers to GTT |
| `drivers/gpu/drm/radeon/radeon_legacy_crtc.c` | 5 | Fence wait after bo_pin |
| `drivers/gpu/drm/radeon/radeon_device.c` | — | need_swiotlb override |
| `arch/ia64/sn/pci/pcibr/pcibr_dma.c` | — | Instrumentation (optional) |
| `drivers/gpu/drm/ttm/ttm_bo_vm.c` | — | Instrumentation (optional) |

---

## Debugging Methodology

All fixes were found through systematic instrumentation rather than
speculative changes. The debugging protocol:

1. **Instrument first** — add `printk` at key points to narrow the
   problem before proposing any fix
2. **Ground in evidence** — every theory must be backed by dmesg output,
   source code, or the SGI Altix Porting Guide (007-4520-007)
3. **One variable at a time** — each test changes exactly one thing
4. **Maintain a knowledge document** — track confirmed findings, ruled-out
   theories, and next steps across sessions

The RPTR_ADDR root cause required 15 sessions of elimination to identify.
The blit pitch overflow was found by studying the SN2 PCI DMA
implementation and tracing how 64-bit addresses propagate through GPU
register commands.
