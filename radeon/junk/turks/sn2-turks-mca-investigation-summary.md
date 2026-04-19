# SGI Altix SN2 Radeon GPU — Investigation Summary

## Project Goal
Get the radeon DRM driver working on SGI Altix SN2 (ia64 Itanium 2) with a Radeon HD 7570 (Turks, PCIe, 1002:675D) behind a PLX PEX8111 PCIe-to-PCI-X bridge. Kernel: Linux 7.0-rc1.

## Hardware Configuration
- **System**: SGI Altix 350 (SN2 architecture), 2× Itanium 2 CPUs, NUMA
- **GPU**: Radeon HD 7570 (Turks PRO, 1002:675D, 1GB VRAM, PCIe x16 card running at x1)
- **Bridge**: PLX PEX8111 PCIe-to-PCI-X bridge (in a PCIe riser card)
- **I/O ASIC**: PIC (PCIIO_ASIC_TYPE_PIC=2), NOT PCI-X mode (IS_PCIX=0)
- **PCI topology**: `0002:00:02.0` (PLX bridge) → `0002:01:00.0` (GPU)
- **PIC widget**: widget 15 on slab 0, bus 1
- **DMA**: 40-bit mask (0xffffffffff), uses PCI32 direct mapped path (dir_xbase=0x0)
- **DMA addresses**: 0x80000000-0xFFFFFFFF range (32-bit direct mapped)
- **ATEs**: 1024 × 16KB = 16MB (used only for barrier/MSI, not for main DMA)
- **PAGE_SIZE**: 4KB on v7.0
- **PLX bridge setup**: Manual via setpci (firmware doesn't auto-configure):
  ```
  setpci -s 0002:00:02.0 24.W=0x1000   # memory base
  setpci -s 0002:00:02.0 26.W=0x1ff0   # memory limit
  ```

## Source Tree
- Location: `/home/claude/v7-tree/` (kernel 7.0-rc1)
- Branch: `turks-clean`
- Base commit: `60208e6` (initial import)
- Reference docs: `/mnt/project/porting-device-drivers-to-Atlix-007-4520-007.pdf`
- fglrx analysis: `/mnt/project/sgi-prism-fglrx-*.md`
- Previous transcripts: `/mnt/transcripts/`

---

## SOLVED: Root Cause #1 — TTM WC→UC Page Protection

**The fundamental fix that made the GPU work at all.**

**Problem**: TTM told the CPU to use write-combining (WC) for device memory mappings (VRAM, doorbell, MMIO). On SN2, the PIO hardware has no mechanism to drain CPU write-combine buffers, so WC writes to GPU VRAM never reach the GPU.

**Fix**: 12 lines in `drivers/gpu/drm/ttm/ttm_bo_util.c` in `ttm_io_prot()`:
```c
#ifdef CONFIG_IA64_SGI_SN2
    if (!man->use_tt)
        return pgprot_noncached(tmp);
#endif
```
Forces UC (uncached) page protection for all device memory (VRAM, doorbell, MMIO) userspace mappings. System memory (GTT, use_tt=true) is unaffected. This is universal — fixes radeon, amdgpu, nouveau, any TTM driver on SN2.

**Status**: CONFIRMED WORKING. GPU initializes, ring tests pass, X11 works, glxgears works, light 3D works.

**Patches generated**:
- `/mnt/user-data/outputs/sn2-ttm-v7.0-rc1.patch` (universal TTM fix, 1 file)
- `/mnt/user-data/outputs/sn2-radeon-turks-v7.0-rc1.patch` (Turks-specific minimal)

---

## ACTIVE: MCA Under Heavy 3D Load (Minecraft)

### Symptoms
- **Workload**: Minecraft (Java, OpenGL via Mesa r600 Gallium, heavy 3D rendering)
- **Timing**: Crash consistently ~25 seconds after heavy rendering starts
- **Sequence**: System freezes (console unresponsive) for 20-25 seconds, then MCA fires
- **MCA**: severity=1 (fatal), SAL record 9352 bytes, platform-specific error section
- **pmsa_iip**: Always in Java userspace (region 2) — MCA is asynchronous
- **cpu**: Varies between CPU 0 and CPU 1 — MCA delivered to whatever CPU is available
- **Light load**: Everything works perfectly (X11, twm, glxgears, modetest)
- **x86-64**: Same GPU + PLX bridge work perfectly on x86-64 system

### Configuration During Testing
- `need_swiotlb = false` in radeon_device.c (required — with swiotlb, ATE exhaustion at 16MB)
- TTM UC fix applied
- Various instrumentation patches applied (see below)

### Key Evidence from Instrumentation

**DMA mappings**: All succeed. Zero failures. All go through PCI32 direct mapped path. DMA addresses in 0x80000000-0x9FFFFFFF range. ~200 mappings logged before crash.

**GPU lockup detection**: GPU is NOT locked up. Fences progressing normally. No STALL detected during Minecraft rendering. The lockup probe (which does RREG32 = PIO read to GPU) succeeds every time it runs.

**Heartbeat workqueue**: Runs normally during light load. During heavy Minecraft load, the last heartbeat (#20, ~10 seconds in) appears, then silence until MCA. The workqueue stops running because CPUs are stuck (one in userspace Java, the other likely stuck in PIO timeout).

**GPU interrupts**: Working during init and X startup (9 interrupts delivered). During heavy Minecraft rendering, ZERO additional interrupts. The GPU stops generating interrupts during heavy 3D load (or they stop being delivered).

**DMA ring (ring 3)**: NOT used by Minecraft. No `[SN2-DMA-RING]` messages. All rendering goes through GFX ring (ring 0).

**sn_dma_flush()**: CONFIRMED NO-OP for GPU device.
```
[SN2-FLUSH] NO BAR MATCH for addr 0xc00000080fd015e0 nasid=0x0 wid=15
```
The GPU's BARs (behind PLX PPB bridge) are NOT registered in the flush_nasid_list. Only devices directly on the PIC bus have BARs registered. The fallback fix (flushing via first device on same widget) was implemented and confirmed working, but uses dev=0 which is a different PCI slot than the PLX bridge (dev=2). On PIC, WRBs are per-slot, so flushing dev=0 does NOT flush the PLX bridge's WRBs. However, even with 531K+ total flushes, the MCA still occurs — so DMA write buffer flushing is NOT the root cause.

**SAL record analysis**: Platform-specific error section (GUID `e429faf1-3cb7-11d4-bca7-0080c73c8881`). Format is SGI-proprietary, not documented in open source. Consistent fields across runs:
- +060: `0000000000000009` (error type 9?)
- +068: `1080000003000540` or `1080000003000840`
- +080: Physical memory address (varies, always node 0 cacheable memory)
- +270/+5c0: Always ends in `5428` — possibly CONFIG_MEMSIZE GPU register (0x5428)
- No bridge error handler (`[SN2-BRIDGE-ERR]`) fires before MCA

### Theories RULED OUT

| Theory | Evidence | Status |
|--------|----------|--------|
| DMA mapping failure | Zero FAILED messages across all runs | RULED OUT |
| 64-bit DMA mask | Ring test fails with coretalk addresses, GPU MC is 36-bit | RULED OUT |
| GPU lockup → PIO timeout | No STALL detected, fences progressing | RULED OUT |
| DMA write buffer exhaustion | 531K+ flushes had no effect, fallback flush confirmed working | RULED OUT |
| sn_dma_flush no-op (BAR mismatch) | Fixed with fallback, still crashes | RULED OUT (as sole cause) |
| DMA ring missing PIO readback | DMA ring not used by Minecraft (no [SN2-DMA-RING] messages) | RULED OUT |
| PCIe NoSnoop attribute | Disabled via setpci (RlxdOrd- NoSnoop-), same crash timing | RULED OUT |
| PCIe Relaxed Ordering | Disabled via setpci, same crash timing | RULED OUT |
| PLX bridge bandwidth | Same GPU+PLX works on x86-64 | RULED OUT |
| Region bit strip needed | Not needed for Turks on v7.0 | RULED OUT |
| pci_iomap skip needed | Not needed for Turks | RULED OUT |
| fbdev GTT creation needed | Not needed with UC caching fix | RULED OUT |

### Theories STILL OPEN

1. **PIO write accumulation without read flush**: During heavy rendering, many PIO writes (WREG32) happen. The GFX ring WPTR write HAS a readback (`RREG32` after `WREG32` in `cayman_gfx_set_wptr`). But other PIO writes (GART entries, HDP flush, etc.) may accumulate. The PDF requires a PIO read after every significant PIO write sequence [PDF Page 4, 11]. However, the GART bind path does include a TLB flush with RREG32 polling, so this may be properly handled.

2. **GPU generates bad DMA transaction**: Under heavy load, the GPU may generate a DMA read or write that violates SN2's ccNUMA protocol. The DMA itself succeeds (valid address) but triggers a coherence error in the SHub. This would explain the asynchronous MCA.

3. **PIC bridge resource exhaustion**: The PIC has per-slot resources (RRBs, WRBs, split transaction buffers). Under heavy GPU DMA, these resources may be exhausted. The PROM configured them for a simple PCI bridge, not a GPU.

4. **Something about the WB (writeback) fence polling path**: With WB enabled, fence reads go to system memory via `*drv->cpu_addr`, never touching GPU registers. The `no_wb=1` module parameter was attempted but did NOT disable WB on Turks (the driver overrides it). Need to force WB off in source code.

5. **Interrupt delivery failure under load**: Only 9 GPU interrupts delivered during entire test. The `Invalid provider_call 3` (SAL_INTR_REDIRECT) during MSI setup may indicate incomplete interrupt configuration. Without interrupts, the PIC never gets the signal to flush DMA write buffers via the interrupt mechanism [PDF Page 5].

### Applied Changes in Source Tree (turks-clean branch)

**Essential fixes (keep)**:
- `drivers/gpu/drm/ttm/ttm_bo_util.c`: UC for device memory on SN2 (THE fix)
- `drivers/gpu/drm/radeon/radeon_device.c`: `need_swiotlb = false`

**Instrumentation (remove or update for next session)**:
- `arch/ia64/kernel/mca.c`: SAL record 2KB hex dump + pmsa_iip/ipsr
- `arch/ia64/sn/pci/pcibr/pcibr_dma.c`: GPU DMA tracing, sn_dma_flush BAR trace + fallback fix + counters
- `arch/ia64/sn/pci/pcibr/pcibr_provider.c`: Bridge error handler logging
- `drivers/gpu/drm/radeon/evergreen.c`: Lockup probe logging
- `drivers/gpu/drm/radeon/radeon_fence.c`: Heartbeat, STALL logging, periodic RREG32 flush
- `drivers/gpu/drm/radeon/radeon_irq_kms.c`: IRQ delivery counter
- `drivers/gpu/drm/radeon/ni_dma.c`: DMA ring WPTR counter + readback

### Suggested Next Steps (Prioritized)

1. **[HIGH] Force WB off in source code**: Change `radeon_fence.c` line 93 to force `!rdev->wb.enabled` path. This makes every fence poll do `RREG32(scratch_reg)` — a full PIO round-trip. If MCA goes away, the WB DMA path is the problem.

2. **[HIGH] Instrument the actual PIO that triggers the timeout**: The 20-25 second freeze before MCA suggests a PIO operation is stuck. Add a printk before EVERY RREG32/WREG32 in the radeon driver's hot path (ring commit, GART update, DPM) to identify which PIO is the last one before the hang.

3. **[HIGH] Check PIC RRB/WRB allocation**: The PIC allocates Read Response Buffers per device slot. If the PLX bridge's slot has too few RRBs, heavy GPU DMA reads would exhaust them. Check if `pcibr_bus_fixup` or PROM allocates RRBs for the PLX bridge's slot.

4. **[MED] Try with DPM disabled**: `radeon.dpm=0` disables dynamic power management, reducing periodic GPU register reads. If DPM's register reads trigger the timeout, this would help.

5. **[MED] Read PIC bridge error registers directly**: Before MCA, read PIC's error status registers (widget 15) to see if any PCI-X errors are accumulating. The bridge error interrupt handler never fires, but errors might be silently accumulating.

6. **[MED] Try smaller VRAM allocation**: The GPU has 1GB VRAM but only 256MB is accessible through BAR0. Under heavy rendering, the GPU's internal memory controller handles the full 1GB. If the GPU generates DMA reads beyond the BAR aperture, the addresses might be wrong.

7. **[LOW] Decode SAL error record**: The 9352-byte SAL record contains detailed SHub/PIC error information in SGI's proprietary format. If SGI documentation for the platform error section format can be found, it would immediately reveal the exact error.

### Reference: Normal Working dmesg (Turks boot + X)
```
[drm] initializing kernel modesetting (TURKS 0x1002:0x675D 0x1028:0x2B20 0x00).
ATOM BIOS: TURKS
radeon 0002:01:00.0: VRAM: 1024M, GTT: 1024M
[drm] PCIE GART of 1024M enabled (table at 0x0000000000170000).
radeon 0002:01:00.0: WB enabled
radeon 0002:01:00.0: radeon: using MSI.
salruntime_sn_intr_handler: Invalid provider_call 3
[drm] ring test on 0 succeeded in 1 usecs
[drm] ring test on 3 succeeded in 4 usecs
[drm] ring test on 5 succeeded in 2 usecs
[drm] ib test on ring 0/3/5 succeeded
[drm] Initialized radeon 2.51.0
Console: switching to colour frame buffer device 160x64
```

### Reference: PEX8111 PLX Bridge Datasheet
Uploaded to `/mnt/user-data/uploads/PEX8111-AA66FBCF.pdf` — contains bridge register details, transaction forwarding rules, and error handling. The PLX PEX8111 is a simple transparent bridge; it should pass through all transactions without modification. Key: MaxPayload 128 bytes, MaxReadReq 512 bytes, PCIe x1 Gen1 (250 MB/s).
