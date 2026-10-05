# SN2 Radeon GPU MCA Investigation — Knowledge Document

## Session Log

### Sessions 1-6 (prior)
- Established basic GPU operation on SN2 Altix 350 (Turks behind PLX PEX8111)
- Identified sn_dma_flush() BAR matching failure for devices behind PPBs
- Implemented fallback flush using dev=0 on same widget
- Identified WB fence polling path skips PIO reads (no sn_dma_flush trigger)
- Added periodic RREG32 in fence check to force PIO flush
- Attempted set_pages_array_uc() for GTT — no-op on ia64
- MCA persists under heavy 3D load (Minecraft), 20-25 second freeze then crash

### Session 7 — IST Tools Analysis & Root Cause Confirmation

**IST Archive Analysis:**
- Extracted SGI Internal Service Tools CD contents
- Discovered `pic_01_mmrs.pm` (13,582 lines) — complete PIC ASIC register map
  with bit-field definitions from SGI's hwreg database
- Discovered `pi_tools.pm` — PI CRB (WRB/PRB/RRB/IRB) read and decode functions
- Discovered `shub_subs.pm` — `decode_pi_err_detail()` function for PI error registers
- Discovered `ii_regs.pm` — SHub II chiplet decode including Opus PIC access

**Altix 350 Architecture Discovery:**
- PIC is NOT in JTAG scan chain on Altix 350 (Opus form factor)
  [ii_regs.pm:2090: "PIC mmrs since they aren't accessable via jtag on Opus bricks"]
- PIC registers are only readable via packet-injected MMR reads through SHub II
- errdmp `-ii` flag triggers Opus-specific PIC register reading via packet injection
- System has single C-brick `001c02`, board `NODE`, chip `SHUB0` (shub_02 type)
- mmr_dump cannot directly target PIC on this system

**CRB Architecture Decoded (from pi_tools.pm):**
- WRBs (type 1, 32 slots): Track DMA writes from I/O → system memory
- PRBs (type 2, 32 slots): Track CPU PIO requests → I/O devices  
- RRBs (type 0, 32 slots): Track read responses returning to CPU
- IRBs (type 3, 8 slots): Track interrupt requests from I/O
- "GOOFY" = default string when 5-bit WRB type doesn't match known values;
  errdmp retries 7 times before accepting [pi_tools.pm:1533,990-996]

**PI_ERROR_DETAIL Decode (from shub_subs.pm:671-780):**
- Format selected by PI_FIRST_ERROR bits:
  - `& 0x8FC00000 > 0` → AFI format (FSB hardware errors)
  - `& 0x7E7F > 0` → CRBP format (timeout/protocol errors)
  - `& 0x400000000 > 0` → MSG_LEN format

**Post-MCA errdmp Capture (DUMP-HUNG):**
- `SH_PI_FIRST_ERROR = 0x0000000000000001` → **bit 0 = FSB_PROTO_ERR**
- `SH_PI_ERROR_SUMMARY = 0x0000000200000001` → FSB_PROTO_ERR + FSB_TBL_MISS (bit 33)
- CRBP format confirmed (PI_FIRST_ERROR & 0x7E7F = 0x1 > 0)
- DETAIL_1: Command = 0x01 = **SN2NET_RDEXC (Read Exclusive)**,
  Address = 0x0003009170500
- DETAIL_2: Source = 0x01D8 (Node=0x1D8, Chiplet=**MD**),
  WRB_idx=30, RRB_idx=31
- All PI CRBs returned identical data — **PI completely hung**
  (all 4 WARNING: unreliable messages)
- BUS1 (GPU bus): **ZERO errors** — INT_STATUS=0, ERR_INT_VIEW=0,
  DMA_ERR_ADDR=0, DMA_ERR_ATTR=0
- BUS0 (base I/O): PCI_X_ARB_ERR on device 1 (unrelated)
- BUS1_DEV2_REG = 0x0000000012040000:
  **COHERENT=0, BARRIER=0**, PREFETCH=1, EN_VIRTUAL=1, EN_ERROR_LOCK=1
- CPU A: LED 0x57 = SAL_PMI entered; CPU C: LED 0x38 = SAL entered due to MCA

**Root Cause Confirmed:**
- Error address 0x3009170500 = node 0 cacheable memory, offset ~145MB
- With Direct32 (dir_xbase=0): physical 0x3009170000 → DMA 0x89170000
- Address is in GPU's Direct32 DMA range (0x80000000-0xFFFFFFFF)
- Pages are TTM-allocated buffer objects accessed by both CPU (Mesa writes
  vertex/texture data via WB identity map) and GPU (DMA reads)
- RDEXC = MD requesting exclusive ownership to service directory intervention
  when GPU DMA reads a cache line in Modified state in CPU cache
- Different address every crash but always in same TTM memory region
- COHERENT=0 is irrelevant — COHERENT controls DMA write coherency,
  but the problem is DMA reads of CPU-Modified lines

**ia64 Cache Attribute Discovery:**
- `set_pages_array_uc()` is a no-op on ia64
- TTM `ttm_uncached` only changes mmap pgprot, NOT physical page cache attribute
- ia64 kernel identity map (region 7) is ALWAYS WB — no per-page PAT like x86
- Only way to get UC access is through uncacheable region (0xc0...)
- TTM zeros pages and fills IBs via kmap which uses WB identity mapping
- Those WB writes create Modified cache lines → directory interventions

---

## Confirmed Findings

1. **Root cause is FSB protocol error from directory intervention overload**
   — GPU DMA reads of CPU-Modified cache lines trigger RDEXC interventions
   from MD chiplet via PI→FSB→CPU. Under heavy 3D load, FSB saturates.
   [errdmp DUMP-HUNG: SH_PI_FIRST_ERROR=0x01 (FSB_PROTO_ERR),
   DETAIL_1 cmd=0x01 (RDEXC), DETAIL_2 source chiplet=MD]

2. **PIC bridge has zero errors during MCA** — The GPU/PCI side is clean.
   [errdmp DUMP-HUNG: BUS1_INT_STATUS=0, BUS1_ERR_INT_VIEW=0,
   BUS1_PCI_X_DMA_ERR_ADDR=0]

3. **COHERENT bit is NOT set (=0) for GPU device slot** — DMA writes are
   non-coherent. The problem is DMA reads, not writes.
   [errdmp DUMP-HUNG: BUS1_DEV2_REG=0x12040000, bit 16=0]

4. **PI is completely hung after MCA** — All CRB CAM reads return identical
   data; errdmp flags all four buffer types as unreliable.
   [errdmp DUMP-HUNG: 4x "WARNING: Data returned from X reads appears
   to be unreliable!!!!"]

5. **Error address is always a GPU DMA page in cacheable node 0 memory**
   — Different page each crash, always in TTM buffer object region.
   [DETAIL_1 addr=0x3009170500 → DMA 0x89170500; cross-crash comparison
   shows v7j/v7k/v7l/v7m all in same memory region, different pages]

6. **FSB_TBL_MISS is secondary, not primary** — It appears in ERROR_SUMMARY
   but not FIRST_ERROR. FSB_PROTO_ERR came first.
   [errdmp: FIRST_ERROR=0x01 (bit 0 only), SUMMARY=0x200000001 (bits 0+33)]

7. **set_pages_array_uc() is a no-op on ia64** — Cannot change physical page
   cache attributes. Kernel identity map (region 7) is always WB. TTM's
   "uncached" setting only affects userspace mmap pgprot.

8. **PIC not accessible via JTAG on Altix 350** — Requires packet injection
   through SHub II, triggered by `errdmp -ii` on Opus bricks.
   [ii_regs.pm:2090, confirmed by errdmp output showing packet-injected
   BUS0/BUS1 register reads]

9. **SHub PI CRB types**: WRB=DMA writes (I/O→memory, type 1),
   PRB=PIO (CPU→I/O, type 2), RRB=read responses (type 0),
   IRB=interrupts (type 3)
   [pi_tools.pm: read_cam() type parameter, read_all_crb() structure]

10. **WRB states**: FREE(0), WACK(8), SNOOP(12), SNPP(13), SNPRY(14), SNPRR(15)
    [pi_tools.pm:2096-2111]

---

## Ruled Out

1. **WRB exhaustion from unflushed DMA writes** — WRBs track DMA writes
   (I/O→memory), but the actual error is on the DMA read path (GPU reading
   CPU-modified data). Also, COHERENT=0 means DMA writes don't generate
   snoops. The sn_dma_flush fallback fix is still useful but not the MCA fix.
   [Ruled out by: BUS1 PIC errors=0, COHERENT=0, FIRST_ERROR=FSB_PROTO_ERR
   not any WRB/DMA-write-related error]

2. **PCI/PIC-level error** — No PIC errors on BUS1 at all. The error is
   entirely internal to the SHub (PI↔FSB↔CPU path).
   [Ruled out by: BUS1_INT_STATUS=0, BUS1_ERR_INT_VIEW=0]

3. **Cache coherency pressure from DMA writes** — COHERENT=0 means GPU DMA
   writes don't trigger cache snoops. The earlier theory about write-path
   coherency pressure was wrong.
   [Ruled out by: BUS1_DEV2_REG bit 16=0]

4. **set_pages_array_uc() as a fix** — No-op on ia64. Cannot change physical
   page cache attributes via this API.
   [Ruled out by: ia64 architecture — region 7 is always WB, no PAT]

---

## Open Questions

1. **Where exactly should clflush_cache_range() be called?** — Need to
   identify the radeon/TTM code paths where CPU finishes writing GTT pages
   and GPU is about to read them. Candidates: radeon_ib_schedule(),
   radeon_ring_unlock_commit(), TTM's move/bind paths, dma_map_sg for GTT.

2. **Does ia64 SN2's dma_sync_for_device() flush CPU caches?** — The DMA
   streaming API should handle this, but SN2's sn_dma_ops may assume
   hardware coherence and skip the flush.

3. **Performance impact of per-page fc instructions** — Each ia64_fc() flushes
   one 128-byte cache line. A 4KB page requires 32 fc instructions. Under
   heavy GPU load with many pages, this adds CPU overhead. Need to measure.

4. **Can we use the uncacheable region (0xc0...) for GTT page access?** —
   If all kernel writes to GTT pages go through UC virtual addresses, no
   Modified lines are created. But this requires changing kmap/memset paths
   in TTM which use the WB identity map.

5. **Why does the FSB protocol error (bit 0) fire before FSB table miss
   (bit 33)?** — Protocol error may indicate a specific FSB transaction
   violated the protocol rules under congestion, while table miss is the
   subsequent overflow condition.

---

## Applied Changes

1. **sn_dma_flush fallback for PPB devices** — When no BAR match found for
   device behind PLX bridge, falls back to dev=0 flush on same widget.
   [pcibr_dma.c: sn_dma_flush() fallback path]

2. **Periodic RREG32 in fence check** — Forces PIO read (and thus
   sn_dma_flush) during fence polling when WB is enabled.
   [radeon_fence.c: radeon_fence_check_lockup()]

3. **UC for device memory (VRAM) on SN2** — Changed TTM to use UC for
   device memory type on SN2.
   [ttm_bo_util.c]

4. **need_swiotlb = false** — Disabled unnecessary SWIOTLB for radeon on SN2.
   [radeon_device.c]

5. **Debug instrumentation** (v6b patch) — MCA SAL record dump, bridge error
   logging, fence heartbeat, DMA ring tracing, IRQ counting, lockup probe
   logging.

---

## Next Steps

[Priority: **CRITICAL**] Implement clflush_cache_range() at GPU command
submission boundary — flush all GTT pages referenced by the IB before
GPU starts reading them. This eliminates Modified cache lines from the
directory, preventing RDEXC interventions on the FSB.

Candidate insertion points:
- `radeon_ib_schedule()` — after IB is filled, before ring doorbell write
- `radeon_cs_ioctl()` → after `radeon_cs_parser_relocs()` resolves BO list
- TTM `ttm_bo_move_memcpy()` / `ttm_tt_bind()` — when pages enter GTT
- Hook `dma_sync_single_for_device()` in SN2 DMA ops to call
  `clflush_cache_range()` for GPU device

Implementation approach:
```c
/* In radeon_ib_schedule() or radeon_cs_ioctl(), after CPU writes complete: */
#ifdef CONFIG_IA64_SGI_SN2
{
    /* Flush CPU cache lines for all GTT-resident BOs in this submission.
     * Without this, GPU DMA reads trigger RDEXC directory interventions
     * for every Modified cache line, saturating the FSB under heavy load.
     * ia64_fc() flushes 128 bytes (one Itanium 2 cache line). */
    struct radeon_bo *bo;
    list_for_each_entry(bo, &parser->validated, tv.head) {
        if (bo->tbo.mem.mem_type == TTM_PL_TT && bo->tbo.ttm) {
            struct ttm_tt *ttm = bo->tbo.ttm;
            int i;
            for (i = 0; i < ttm->num_pages; i++) {
                void *addr = kmap_atomic(ttm->pages[i]);
                clflush_cache_range(addr, PAGE_SIZE);
                kunmap_atomic(addr);
            }
        }
    }
}
#endif
```

[Priority: **HIGH**] Investigate using UC virtual addresses (region 5,
0xc000...) for ALL kernel access to GTT pages — kmap, memset, IB fill.
This would prevent Modified lines from being created in the first place,
eliminating the need for per-submission flushes. More invasive but
zero-overhead at submission time.

[Priority: **MED**] Check if ia64 SN2 `dma_sync_single_for_device()`
already calls cache flush — if so, ensuring radeon/TTM uses the DMA
streaming API correctly might be sufficient without driver-level changes.

[Priority: **MED**] Run errdmp -ii during light GPU load (before MCA)
to capture baseline PIC register state and compare with post-MCA dump.

[Priority: **LOW**] Investigate whether the SHub has any tuning knobs
for FSB table size or intervention timeout that could increase headroom.
