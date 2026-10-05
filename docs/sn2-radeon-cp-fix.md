# R100 CP Fix for SGI Altix SN2: RPTR_ADDR Must Point to Valid DMA Address

## Summary

The radeon DRM driver's R100 Command Processor (CP) hangs on SGI Altix
SN2 systems because `RPTR_ADDR` is set to 0 when writeback (WB) is
disabled. The R100 CP microcode unconditionally writes the ring read
pointer (RPTR) to `RPTR_ADDR` via DMA when the ring goes idle, regardless
of the `RB_NO_UPDATE` control bit. On SN2, bus address 0 has no valid
Address Translation Entry (ATE) in the PCI bridge, so the DMA write
never completes, permanently stalling the CP's Register Set Interface
Unit (RSIU).

**Fix:** Always set `RPTR_ADDR` to a valid GART-mapped address, even
when writeback is disabled.

## Hardware

- **System:** SGI Altix 350 (SN2 architecture, ia64 Itanium 2)
- **GPU:** ATI Radeon 7500 / RV200 (PCI, device 1002:5157)
- **PCI Bridge:** SHub PCIBR (PCI-X), NOT TIOCA
- **Kernel:** Linux 5.10 with SN2 patches

## Root Cause

### The DMA Path on SN2

On SN2 systems, GPU bus-master DMA operations pass through the PCIBR's
ATE (Address Translation Entry) table. The ATE table maps 32-bit PCI bus
addresses (starting at 0x40000000) to physical system memory addresses
across the NUMAlink fabric. Bus addresses without a valid ATE mapping
cause a fatal bridge error or, in the case of a posted write, silently
hang — the PCI bridge has no target to respond to the transaction.

Reference: SGI Altix Device Driver Porting Guide (007-4520-007),
§DMA Addressing, Page 30: "the kernel sets up the bus adapter hardware
to translate between some range of bus addresses and the desired range
of memory space."

### The RPTR Writeback Mechanism

The R100 CP maintains a ring buffer for command submission. The CPU
writes commands to the ring and updates the write pointer (`WPTR`). The
CP reads commands from the ring and advances the read pointer (`RPTR`).
The `RPTR_ADDR` register (0x070C) specifies a bus address where the CP
writes the current `RPTR` value via DMA, so the CPU can read the host
memory location instead of polling the GPU register.

The `RB_NO_UPDATE` bit (bit 27 of `CP_RB_CNTL`, register 0x0704) is
documented as preventing the CP from writing `RPTR` to memory. However,
**on the R100/RV200, the CP microcode ignores this bit and writes RPTR
to RPTR_ADDR unconditionally** when the ring goes idle (RPTR == WPTR).

### The Bug

When writeback is disabled, the radeon driver sets `RPTR_ADDR = 0` and
`RB_NO_UPDATE = 1`:

```c
/* Original code in r100_cp_init() when wb.enabled == false */
WREG32(R_00070C_CP_RB_RPTR_ADDR, 0);
tmp |= RADEON_RB_NO_UPDATE;
```

On x86 systems, bus address 0 is typically mapped to real physical
memory, so the stray DMA write completes harmlessly. On SN2, bus
address 0 has no ATE mapping — it is below the ATE-mapped range
(0x40000000+). The DMA write receives no completion, permanently
stalling the RSIU.

### The Stall Sequence

1. CPU submits commands to the ring (writes PACKET0 register writes)
2. CPU updates WPTR register via MMIO
3. CP fetches ring data via DMA (GART-mapped, works correctly)
4. CP executes the PACKET0 commands (register writes succeed)
5. CP processes NOP padding to end of commit
6. RPTR reaches WPTR — ring is empty
7. **CP writes RPTR to RPTR_ADDR (0x00000000) via DMA**
8. **DMA write has no ATE mapping — never completes**
9. **RSIU stalls permanently** (CP_STAT bit 2 = RSIU_BUSY = 1)
10. All subsequent ring commits are blocked — data is fetched but
    commands cannot execute because RSIU is stuck

### Observed Symptom

The CP executes all commands in the **first** ring commit successfully,
then fails on **every subsequent** ring commit. The first commit works
because the CP processes the commands before attempting the RPTR
writeback. The writeback happens when the CP goes idle after the first
commit, stalling the RSIU before the second commit can execute.

```
[SN2-DBG] TEST-A2 PASSED: both commands in first commit worked! (1 usecs)
[SN2-DBG] RSIU_BUSY: t0=1 t+10us=1 t+100us=1 t+1ms=1
[SN2-DBG] ring test FAILED: CP_STAT=0x80000004   ← RSIU_BUSY + CP_BUSY
```

## The Fix

Set `RPTR_ADDR` to a valid GART-mapped address (the writeback buffer
page) even when writeback is logically disabled. Remove `RB_NO_UPDATE`
so the CP's writeback completes normally.

```c
/* Fixed code in r100_cp_init() */
if (rdev->wb.enabled) {
    WREG32(R_00070C_CP_RB_RPTR_ADDR,
        S_00070C_RB_RPTR_ADDR((rdev->wb.gpu_addr + RADEON_WB_CP_RPTR_OFFSET) >> 2));
    WREG32(R_000774_SCRATCH_ADDR, rdev->wb.gpu_addr + RADEON_WB_SCRATCH_OFFSET);
    WREG32(R_000770_SCRATCH_UMSK, 0xff);
} else {
    /* RPTR_ADDR must point to a valid DMA address even when WB is
     * disabled. The R100 CP microcode writes RPTR to this address
     * unconditionally when the ring goes idle, regardless of
     * RB_NO_UPDATE. On platforms with strict DMA address checking
     * (e.g., SGI Altix SN2 with ATE-based PCI bridges), RPTR_ADDR=0
     * causes a permanent RSIU hang because bus address 0 has no
     * valid translation.
     */
    WREG32(R_00070C_CP_RB_RPTR_ADDR,
        S_00070C_RB_RPTR_ADDR((rdev->wb.gpu_addr + RADEON_WB_CP_RPTR_OFFSET) >> 2));
    WREG32(R_000774_SCRATCH_ADDR, 0);
    WREG32(R_000770_SCRATCH_UMSK, 0);
    /* Do NOT set RB_NO_UPDATE — let RPTR writeback complete to valid address */
}
```

The writeback buffer object (`rdev->wb.wb_obj`) is always allocated by
`radeon_wb_init()` regardless of the `wb.enabled` flag, so
`rdev->wb.gpu_addr` is always a valid GART-mapped address.

## Verification

### Sentinel Test

A sentinel value (0xDEADDEAD) was planted in the writeback buffer at
the RPTR offset before starting the CP. After the first ring commit,
the sentinel was replaced with the actual RPTR value, proving the CP
performs the writeback:

```
[SN2-DBG] WB sentinel planted at wb[256]=0xdeaddead
...
[SN2-DBG] WB RPTR readback: wb[256]=0x00000010
```

### Ring Test and IB Test

With the fix applied, both the ring test and indirect buffer (IB) test
pass:

```
[drm] ring test succeeded in 1 usecs
[drm] ib test succeeded in 0 usecs
```

Without the fix, every ring test after the first commit fails:

```
[drm:r100_ring_test [radeon]] *ERROR* radeon: ring test failed
[drm:r100_cp_init [radeon]] *ERROR* radeon: cp isn't working (-22).
radeon 0002:00:02.0: Disabling GPU acceleration
```

### CP_STAT Decode

| State | CP_STAT | Meaning |
|---|---|---|
| After first commit (broken) | 0x80000004 | CP_BUSY=1, RSIU_BUSY=1 — RSIU permanently stalled |
| After second commit (broken) | 0xC0002004 | Added CMDSTRM_BUSY, CSI_BUSY — queued behind stalled RSIU |
| After first commit (fixed) | 0x80000004 | CP_BUSY=1, RSIU_BUSY=1 — normal idle state, clears on next commit |

Note: RSIU_BUSY=1 appears to be normal for the R100 idle state (the CP
polls for new work via the RSIU). The difference is that with a valid
`RPTR_ADDR`, subsequent commits are processed; with `RPTR_ADDR=0`, the
RSIU is permanently stalled and never processes new commands.

## Applicability

This fix is required on any platform where:

1. The radeon driver disables writeback (`wb.enabled = false`)
2. Bus address 0 is not a valid DMA target (no IOMMU mapping, no
   physical memory at address 0, or strict bus address checking)

SN2 is the known affected platform, but any system with an IOMMU that
does not map address 0 could theoretically be affected. On x86 without
an IOMMU, physical address 0 is real memory and the stray write is
harmless.

## Debugging Timeline

The root cause was identified through 15 sessions of systematic
instrumentation:

1. Sessions 1-7: Established that the CP executes one command, then
   hangs. Ruled out DMA addressing, GART corruption, bus mastering,
   microcode, clock gating, and ISYNC conflicts.
2. Sessions 8-10: Zeroed RPTR_ADDR (made the bug worse, though we
   didn't know it). Tested NOP padding, multi-register writes, and
   readl_relaxed — all ruled out.
3. Session 11-12: Added BETWEEN TESTS instrumentation revealing
   CP_STAT=0x80000004 (RSIU_BUSY) persists after the first commit,
   before the second commit even starts.
4. Session 13: Two PACKET0s in a single commit both execute — proving
   the CP handles multiple commands, and the hang occurs during the
   idle transition.
5. Session 14: RSIU_BUSY confirmed permanently stuck (1ms+ poll).
6. Session 15: Set RPTR_ADDR to valid GART address → **ring test
   passed, IB test passed.** WB sentinel confirmed RPTR writeback.

## Related Findings

- **fglrx reference (TIOCA/Prism):** The proprietary fglrx driver for
  the SGI Altix Prism (TIOCA bridge) called `sn_dma_map_single()`
  directly with a 32-bit DMA mask. While this was for TIOCA's specific
  GART requirements (broken PCI32 direct DMA), the principle is the
  same: all DMA addresses on SN2 must be valid ATE-mapped addresses.

- **RB_NO_UPDATE is unreliable on R100:** Despite being set, the CP
  still writes RPTR to memory. This may be a silicon bug or
  undocumented behavior specific to the R100/RV200.

- **SN2 interrupts are broken:** `salruntime_sn_intr_handler: Invalid
  provider_call 3` — interrupt routing fails for this PCI device. This
  does not affect the CP fix but prevents interrupt-driven features
  (vsync, fence completion via IRQ).
