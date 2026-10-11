# Write combining on SN2: is all-UC necessary? (2026-10-10)

Follow-up to `ALTIX-GPU-UPLOAD.md`. Measured on pople as configured today:
- Altix 350, **1 node** (NASID 0), 2× Madison 1.5 GHz, 3.8 GB, SHub 1.2.
- R7 240 (Oland) behind the PLX 8112.
- Kernel `cd807ef4f11b`, Mesa 26.2.3.

ALTIX-GPU-UPLOAD.md was measured on an 8-node configuration, so its remote-node rows don't apply
to this box. Its node-0 row matches the UC baseline below exactly.

## Answer

The current `ttm_io_prot()` forces UC for both VRAM and GTT. Only the VRAM half is necessary.

| Buffer kind | WC? | Evidence |
|---|---|---|
| **GTT (system memory)** | **Safe, and 70× faster** | Porting Guide 007-4520-007 p.25: "UC, WB, and WC attributes are supported for cacheable memory space". Measured: correct data, no SHub errors, 150k GPU round-trip checks clean |
| **VRAM (PCI BAR, PIO space)** | **Fatal** | p.25: "global MMR space must be accessed uncached"; p.68 says a BAR mmap uses `pgprot_noncached()`. Measured: hangs the box (below) |

The original commit (`83116d147525`) cites "pages 89–90", which are the PDF page numbers of printed pp. 67–68. Those pages
cover mmap of PCI BARs only. They say nothing about system memory.

## Raw store bandwidth (`sn2wc/`, no GPU driver involved)

`sn2wc.ko` exposes `/dev/sn2wc`. Its mmap offset selects either DMA32 node-0 pages (allocated,
zeroed and flushed exactly like ttm_pool on SN2) or a 64 MB window at +128 MB in BAR0, mapped
UC or WC. `wcbench` copies data in with glibc memcpy and verifies it through a UC alias.

| Target | UC | WC |
|---|---|---|
| DMA32 RAM (GTT-like) | 20.4 MB/s | **1448 MB/s**, data verified |
| VRAM via BAR0 | 35.0 MB/s | **hang** after ~836 KB |

Other results for WC to RAM:
- 1-, 2-, 4- and 8-byte scattered WC stores leave the neighbouring bytes intact.
- Without a fence, a WC store becomes visible to the other CPU (polling a UC alias) in 3–9 µs.
  That holds for an 8-byte store, for a full line, and after a syscall.
- SHub `SH_FIRST_ERROR`, `SH_PI_FIRST_ERROR` and `SH_PI_ERROR_SUMMARY` all read 0 afterwards.

### Why WC to the BAR kills the box

Dump: `errdmp_26_Sat_Oct_10_20_07-bar-wc-memcpy-hang3`.
- `SH_XNIILB_FIRST_ERROR` = CHIPLET_NOMATCH, source PI, address `0xB80CC380`. That is a
  128-byte-aligned line inside the test window, with bit 35 (global MMR) gone.
- `SH_MEM_ERROR_SUMMARY` = NONEXIST_ADDR.
- `SH_PI_FIRST_ERROR` = PIO_TO_ERR, plus MEM_TO_ERR.
- Both CPUs frozen.

SHub1 routes a coalesced line write to PIO space as a memory request, and nothing on the
crossbar claims it. SHub2 added dedicated WC request types (`BWWCD`/`BWWCF` in IST
`pi_tools.pm:decode_wrb_type`); SHub1 has none.

A single 8-byte WC store to the BAR followed by `mf` does work. Only coalesced lines fail. So
VRAM must stay UC on SHub1.

### Side finding: glibc memcpy *reading* from a UC VRAM mapping is also fatal

My first two BAR runs hung, with WC and with plain UC. Both were in the verification step:
memcpy *from* the UC BAR mapping. The dumps (`errdmp_26_Sat_Oct_10_19_54-bar-wc-hang1`, `…20_01-bar-uc-hang2`) show:
- `FSB_PROTO_ERR` + `FSB_TBL_MISS`;
- `SH_PI_ERROR_DETAIL_1` = SN2NET_READ at `0xB8000000`, the first line of the window.

The likely cause is glibc's ia64 memcpy loading with `ldfp8` (16-byte paired loads). The fault
went away when the read loop used 8-byte volatile loads, so it is the access width, not UC itself.
- **Consequence:** any userspace path that memcpys *out of* a VRAM-placed mapping can MCA or
  hang the box, with any attribute. Examples are a GL map-for-read of a VRAM buffer that Mesa
  serves directly, or a readback through a VRAM map.
- This is the same SHub error class as the April MCAs and is worth keeping in mind for "random"
  GPU crashes.
- I haven't checked whether Mesa ever does this. Moving CPU-mapped buffers to GTT (below) also
  removes this exposure.

## With the kernel change: GTT → WC, VRAM stays UC

The change is linux-sn2 `69571599c577` on `master-epic-sn2-gpu`, in `drivers/gpu/drm/ttm/ttm_bo_util.c`, `ttm_io_prot()`: under SN2, return
`pgprot_writecombine()` when `man->use_tt` and `pgprot_noncached()` otherwise. Nothing else
changes.
- The zero-and-flush in `ttm_pool_alloc_page()` still runs for every page.
- On ia64 the TTM page pool is never used, because `ttm_pool_select_type()` returns NULL
  without DMA-alloc. So no page is ever re-cleared through the WB identity map before reuse.

`gpu-upload-bench 32` (MB/s):

| Path | UC baseline | WC GTT |
|---|---|---|
| memcpy RAM→RAM | 752 | 760 |
| `glNamedBufferSubData` | 18.0 | **141.3** |
| persistent coherent map (VRAM) | 35.6 | 35.4 |
| same + `GL_CLIENT_STORAGE_BIT` (GTT) | 20.3 | **1467** |

`glNamedBufferSubData` now looks bound by the GTT→VRAM DMA over the Gen1 x1 link, not by CPU
stores.

`gl-wc-verify` (CPU writes GTT → GPU copies to a VRAM-only buffer → read back and compare,
random offsets and lengths of 1–3000 bytes plus full 4 MB, both the map and subdata paths):
- 20k iterations plus 3 × 50k (pinned to CPU 0, to CPU 1, unpinned): **0 mismatches**;
- no WARN, oops or MCA on the console.

glmark2-drm subset (`glm.sh`), FPS:

| Scene | UC | WC GTT |
|---|---|---|
| build use-vbo=false (client arrays) | 40 | **111** |
| build use-vbo=true | 1882 | 2442 |
| texture linear | 1768 | 2251 |
| buffer map, interleave=false | 40 | 40 |
| buffer subdata | 26 | **159** |
| buffer map, interleave=true | 43 | 44 |
| shading phong | 1734 | 2155 |
| terrain | 157 | 157 |
| **Score** | **710** | **918** |

The GPU-bound scenes also gain about 25–30%, probably because command and IB uploads to GTT
are now WC.

## 8-node results (same day, GTT-WC kernel only)

pople after the other bricks were reconnected: 8 nodes × 2 CPUs, 31 GB, node distance 25,
GPU on node 0. The L2 is now the hardware L2 `nl4r`.

All GTT pages still come from node 0 (`ZONE_DMA32`).

Raw stores into node-0 DMA32 pages (`WCB_WCPU=<cpu> ./wcbench mem`, reader on CPU 0):

| Writer node | UC | WC | Unfenced 8 B visible | Full line visible |
|---|---|---|---|---|
| 0 | 20.4 MB/s | 1447 MB/s | 2.0 µs | 8.0 µs |
| 1–7 (each) | 13.5 MB/s | 1418–1423 MB/s | 6.5–7.6 µs | 13–16 µs |

- WC hides the NUMAlink hop almost entirely; UC didn't.
- Data and partial stores verify from every node.

`gpu-upload-bench 32`, `numactl --cpunodebind=N --membind=N` (MB/s):

| Node | `glNamedBufferSubData` | persistent map (VRAM) | `GL_CLIENT_STORAGE_BIT` (GTT) |
|---|---|---|---|
| 0 | 141.0 | 35.6 | 1461 |
| 1 | 127.2 | 35.6 | 1442 |
| 4 | 123.0 | 35.6 | 1443 |
| 7 | 124.0 | 35.6 | 1430 |
| CPU 7, mem 0 | 123.0 | 35.6 | 1149 (source buffer remote) |
| unpinned | 129.3 | 35.6 | 1444 |

For comparison, the all-UC kernel in ALTIX-GPU-UPLOAD.md measured 12.3–18.0 / 35.6 / 13.5–20.3.

GPU correctness: `gl-wc-verify 30000` pinned to node 7, pinned to node 3, and unpinned gave
**0 mismatches** each.

glmark2-drm subset (FPS):

| Scene | node 0 | node 7 |
|---|---|---|
| build use-vbo=false | 110 | 110 |
| build use-vbo=true | 2191 | 1949 |
| texture | 1940 | 1812 |
| buffer map | 38 | 38 |
| buffer subdata | 157 | 155 |
| buffer map interleaved | 43 | 43 |
| phong | 1910 | 1725 |
| terrain | 157 | 157 |
| **Score** | **817** | **747** |

The upload-bound scenes don't depend on the node. The GPU-bound scenes are 5–10% slower from a
remote node, and about 10% below the 1-node box overall.

After all of this, `SH_FIRST_ERROR`, `SH_PI_FIRST_ERROR` and `SH_PI_ERROR_SUMMARY` on 001c02
read 0 (IST via nl4r). The console showed no WARN, oops or MCA.

## What's left: buffers Mesa places in VRAM and maps

The `buffer map` scenes and plain persistent maps stay at UC-PIO speed (35 MB/s), because
radeonsi puts those buffers in VRAM.

### Tried: `amdgpu.vis_vramlimit` (doesn't work)

When a VRAM BO is CPU-faulted and doesn't fit in visible VRAM,
`amdgpu_bo_fault_reserve_notify()` moves it to GTT, which is now WC.

- **`vis_vramlimit=16`:** the persistent-map row jumps to **1464 MB/s**. But fbdev can't fit its
  pinned 5 MB framebuffer: `fbdev: Failed to setup emulation (ret=-12)`. When the first DRM
  client then exits, `drm_release` → `drm_fbdev_client_restore` hits a WARN at
  `drm_atomic.c:2031` and then a **NULL dereference** at 0x8 in
  `__drm_fb_helper_restore_fbdev_mode_unlocked`. I reproduced it on two separate boots. This is
  a DRM bug in the fbdev-setup-failure path, triggered by the small limit.
- **`vis_vramlimit=64`:** fbdev is fine, but the benchmark's 32 MB buffers fit in visible VRAM,
  so nothing changes (35.5 MB/s; glmark2 923, the same as without the limit).

So the parameter only helps when a buffer happens not to fit. It isn't a fix.

### Options for the remaining gap (not tried)

1. **amdgpu policy under SN2.** In `amdgpu_bo_fault_reserve_notify()`, move an unpinned
   CPU-faulted VRAM BO to GTT and set its `preferred_domains` to GTT, so command submission
   doesn't move it back and ping-pong. The cost is that the GPU then reads those buffers over the
   Gen1 x1 link every time it uses them. That suits staging and streaming buffers, but could
   hurt mapped buffers that are written once and drawn many times. It needs measuring in
   Minecraft.
2. **Mesa/application side.** Buffers created with `GL_CLIENT_STORAGE_BIT` already land in GTT
   (1467 MB/s). If Minecraft's `StagedVertexBuffer` staging buffers don't set it, they are the
   ones stuck at 35 MB/s.

The Minecraft render thread spent about 10/40 samples in `glNamedBufferSubData` (now ~8× faster)
and 9/40 in memcpy into a mapped buffer (40× faster if that buffer is in GTT, unchanged if it is
in VRAM).

## Files

- `sn2wc/sn2wc.c`, `sn2wc/wcbench.c`: raw UC/WC store test.
  - `./wcbench mem` is safe.
  - `./wcbench bar-uc` and `./wcbench bar-wc1` are safe after `modprobe amdgpu`.
  - **`./wcbench bar` hangs the box** (WC line writes to PIO).
- `gl-wc-verify.c`: GPU-side correctness check for CPU writes to GTT.
- `glm.sh`: the glmark2-drm subset used above.

