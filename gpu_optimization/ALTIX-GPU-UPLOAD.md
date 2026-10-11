# Slow CPU→GPU uploads on the Altix (pople): findings for the SN2 kernel work

Written 2026-10-10 from the IA-64 OpenJDK project, where Minecraft 26.3 runs on pople. All numbers
are measured unless marked otherwise. The kernel source was only read, at
`~/projects/altix_cross/src/mainline/linux-sn2`, HEAD `cd807ef4f11b` ("Add PLX8112 support").

## The machine

- **pople:** SGI Altix (SN2), 8 nodes × 2 Itanium 2 Madison 1.5 GHz, 31 GB, NUMAlink router.
  Node distance 10 local, 25 to every other node (`/sys/devices/system/node/node0/distance`).
- **GPU:** AMD Radeon R7 240 (Oland, GCN1) on `amdgpu` (SI support), 2 GB GDDR5, 256 MB BAR.
  - Mesa 26.2.3 radeonsi.
  - PCI `0002:01:00.0`, `numa_node` 0, local CPUs 0–1.
- **Kernel:** `7.3.0-rc3-epic1-SN2-GPU-cd807ef4f11b` (custom). GART 1024M; "15584M of GTT memory
  ready".
- **Path:** PIC → PLX 8112 PCI/PCI-X-to-PCIe bridge (`0002:00:02.0`, `sn2_plx_bridge_fixup`) → GPU.
  - The bridge's PCIe side is Gen1 x1 by design (LnkCap 2.5GT/s x1); the card trains Gen1 x1
    (it can do Gen3 x8).
  - The bridge's primary status reports 66MHz+.
  - So anything crossing the bridge is capped at roughly 200–250 MB/s even when ideal
    (inferred from the link width, not measured).

## Symptom

In Minecraft 26.3 the **render thread is the bottleneck**:
- ~95% of one CPU, 82% user, 1% system time (from `/proc/<pid>/task/<tid>/stat`);
- the server thread is at 68%, Mesa's driver threads at 8% and 3%;
- the GPU sits at a low DPM level (sclk 400 MHz in `amdgpu_pm_info`), so the GPU itself is not
  the limit.

40 `jstack` samples of the render thread (0.5 s apart, in game):

| Where | Samples |
|---|---|
| `glNamedBufferSubData` (Mesa copies into a GTT staging buffer) | 10 |
| `Unsafe.copyMemory0` ← `StagedVertexBuffer.uploadDrawsToBuffers` (Java memcpy into a mapped GL buffer) | 9 |
| `glClientWaitSync` (waiting on a GPU fence) | 3 |
| other native GL | 4 |
| Java game/render logic | ~14 |

**About half the render thread's time is CPU stores into GPU-visible memory.**

## Measured upload bandwidth

`tools/minecraft/gpu-upload-bench.c` in the OpenJDK project:
- a headless EGL surfaceless GL 4.5 context;
- 32 MiB × 8 passes;
- `glFinish` inside the timing.

It must run from `/root`, because `/tmp` is noexec.

```
gcc -O2 -o gpu-upload-bench gpu-upload-bench.c -lEGL -lGL && ./gpu-upload-bench 32
```

Rows (MB/s):

| Run (pople idle, game closed) | memcpy RAM→RAM | `glNamedBufferSubData` | memcpy → persistent coherent map | same + `GL_CLIENT_STORAGE_BIT` |
|---|---|---|---|---|
| unpinned | 763 | 12.3 | 35.7 | 13.5 |
| `numactl --cpunodebind=0 --membind=0` (GPU's node) | 805 | **18.0** | 35.6 | **20.3** |
| node 1, 3 or 7 (each identical) | 767 | 12.3 | 35.7 | 13.5 |
| CPU node 7, memory node 0 | 412 | 12.3 | 35.7 | 13.5 |
| CPU node 0, memory node 7 | 399 | 18.0 | 35.6 | 20.3 |
| `AMD_DEBUG=nowc`, `nowcstream` or both, node 0 | ~760 | 18.0 | 35.6 | 20.4 |
| `AMD_DEBUG=nowc`, node 7 | 766 | 12.3 | 35.7 | 13.5 |
| **rx2800 for comparison** (HP Integrity, Tukwila, RX 550 on a normal PCIe slot, stock T2 kernel 7.2.8) | 359 | 515 | 465 | 524 |

- The game showed the same numbers while it ran: 12.0 / 33.5 / 13.4.
- `--membind` only moves the benchmark's source buffer. GTT pages are allocated by the kernel
  (see below).
- `AMD_DEBUG=nowc` asks Mesa not to request USWC for GTT; it has no effect.
- The rx2800 memcpy baseline was low in that one run; the GPU paths there are not limited by it.

Read as time per store, assuming 8-byte stores (an assumption; glibc's ia64 memcpy may use other
widths):
- system-memory GTT costs ~390 ns per store from node 0 and ~590 ns from other nodes;
- the VRAM BAR path costs ~225 ns from any node.

## Why: the kernel source

1. **`drivers/gpu/drm/ttm/ttm_bo_util.c`, `ttm_io_prot()`** (commit `83116d147525`) returns
   `pgprot_noncached()` for **every** buffer on SN2. That covers VRAM (`!use_tt`) and
   system-memory GTT (`use_tt`) alike. The in-source reasons:
   - VRAM: WC means PIO write buffers never flush through SHub→PIC.
   - GTT: WB creates Modified lines, so GPU DMA reads trigger RDEXC interventions, then
     `FSB_PROTO_ERR`, then an MCA.

   Citation in the source: SGI Altix Porting Guide 007-4520-007, pp. 89–90.

   This is why userspace cannot change anything: `AMD_DEBUG=nowc` has no effect, and every CPU
   store into any GPU buffer is a UC store. `drm_arch_can_wc_memory()` in
   `include/drm/drm_cache.h` is unchanged and still returns true for ia64. The forcing happens
   only in `ttm_io_prot`.

2. **`arch/ia64/sn/kernel/setup.c`** (commit `8f8f9696915e`) sets `MAX_DMA_ADDRESS` to the end of
   the PIC direct32 window. That window is the bottom 2 GB of **NASID-0** memory, so
   `ZONE_DMA32` is that memory.
   - amdgpu sets a 40-bit mask (`gmc_v6_0.c:835`), so TTM adds `__GFP_DMA32` and **all GTT pages
     live on node 0**.
   - That matches the measurements: UC stores from node 0's CPUs are ~1.5× faster than from any
     other node, and all remote nodes are equal.

3. **`drivers/gpu/drm/ttm/ttm_pool.c`** flushes each newly allocated page with
   `sn_flush_all_caches()` after zeroing. That is an allocation cost, not a steady-state upload
   cost.

## Where the time goes, by path

- **System-memory GTT** (Mesa's staging for `BufferSubData`, `GL_CLIENT_STORAGE_BIT`):
  - UC stores to node-0 RAM, 13–20 MB/s.
  - These never touch the PCI bus at store time, so the PLX/x1 link is not the limit here.
  - The UC attribute, and the NUMAlink hop for remote CPUs, are.
- **VRAM through the BAR** (the persistent coherent mapping, judging by its node-independence):
  - UC PIO through SHub → PIC → PLX → x1, ~36 MB/s from any node.
  - Here the PIO path is the limit.

## Ideas for the kernel side

These are hypotheses for you to evaluate; none were tried.

1. **WC instead of UC for system-memory GTT pages only.**
   - The commit's reasons for UC are WB-specific for GTT (Modified lines, interventions). WC is
     also non-cacheable, so it creates no Modified lines.
   - It would let the CPU coalesce stores into full-line writes to node-0 RAM.
   - Open questions:
     - Does SHub support the WC attribute for cacheable memory?
     - The page is also mapped WB in the region-7 identity map. That aliasing already exists for
       UC, and the zero-and-flush in `ttm_pool.c` was added for it. Is WC aliasing any riskier?
   - Possible split in `ttm_io_prot()`: UC when `!bo->ttm` or `!ttm_tt_is_populated(...)` (VRAM),
     `pgprot_writecombine()` when `bo->ttm` (GTT).
2. **VRAM BAR with WC plus an explicit flush.**
   - The commit says WC PIO buffers "never flush" through SHub→PIC.
   - Worth checking what the SDM and the Porting Guide say flushes a coalescing buffer (`mf`?
     `mf.a`? a UC access to the same page?). Mesa's radeonsi would not issue such a flush itself,
     so this may not be viable.
3. **CPU placement (no kernel change).**
   - Pinning the uploading thread to node 0 gave 1.5× on GTT uploads.
   - Node 0 has only two CPUs, so for Minecraft it would mean pinning the render thread alone, by
     TID with `taskset -pc 0-1 <tid>`, after startup. Not tried in game.
4. **Expected gain** (inferred): uploads are ~50% of the bottleneck thread. Even making them free
   gives at most ~2× on the render thread; after that, Madison's per-core speed running Java is
   the limit.

## Also noted

- `ttm_page_pool` stayed empty (all zeros) after runs, with or without `nowc`. So it gives no
  evidence of which caching type TTM used; the source above is the evidence.
- dmesg: `System can't access extended configuration space`, `PCIE atomic ops is not supported`,
  `Runtime PM not available`.
