# SN2 on v7.1-epic2

Base: `v7.1-epic2` (linux-ia64). Previous version: `v7.0-epic2-sn2` / `v7.0-epic2-sn2-gpu`.

Tags (linux-sn2): `v7.1-epic2-sn2`, `v7.1-epic2-sn2-gpu`. Boot-tested on hardware with the
GPU tag (2026-09-27).

Method: cherry-pick of the v7.0 commits onto the new base (linux-ia64 epic tags descend from
one another), not re-application of the complete patch.

## Layout

| Layer | Range | Commits |
|---|---|---|
| SN2 | `v7.1-epic2..v7.1-epic2-sn2` | Apply sn2 patch; Change ifdefs to CONFIG_IA64_SGI_SN2; Remove newlines; Fix mspec driver compile |
| GPU | `v7.1-epic2-sn2..v7.1-epic2-sn2-gpu` | radeon/TTM fixes; swiotlb override in drm_cache.c; plx_bridge_fixup.c; UVD writel; ZONE_DMA32 / MAX_DMA_ADDRESS; PLX8112 |

Change from v7.0: the mspec compile fix (`09b7ab554340` in v7.0) moved from the GPU layer to
the SN2 layer. In v7.0 it landed after the `v7.0-epic2-sn2` tag, so that tag did not build
mspec. The ZONE_DMA32 commit deliberately stays in the GPU layer for now.

## Conflicts

### drivers/gpu/drm/ttm/ttm_pool.c (GPU layer)

v7.1 (`ae80122f3896` "drm/ttm: use gpu mm stats to track gpu memory allocations") added braces
around the `if (p)` after `alloc_pages_node()` in `ttm_pool_alloc_page()` and a
`mod_lruvec_page_state(p, NR_GPU_ACTIVE, 1 << order)` call — the same spot the SN2
`sn_flush_all_caches()` block goes. Resolution: keep the upstream accounting line, SN2 flush
block after it.

v7.1 also reworked the pool (list_lru, NUMA-aware shrinker, per-node pools dropped). Checked
that page handling relevant to SN2 is unchanged: fresh pages still come only from
`alloc_pages_node()` in `ttm_pool_alloc_page()` (flushed), recycled pool pages are still
`clear_page()`d in `ttm_pool_type_give()` as in v7.0.

`git range-diff` against the v7.0 stack is otherwise identical (Kconfig context only).

## Config

`sn2-kernel-tools/configs/7.1-epic-sn2-gpu.config` — `7.0-epic-sn2-gpu` + `olddefconfig`.
v7.1 made `CONFIG_IPV6` built-in only (`309b905deee5`) and `CONFIG_MULTIPLEXER` a visible
symbol (`ce5c7c17e706`); both were `m` and are now `y`.

## Patches

- `sn2-v7.1-epic2-complete.patch` — `git diff v7.1-epic2..v7.1-epic2-sn2`
- `sn2-gpu-v7.1-epic2.patch` — `git diff v7.1-epic2-sn2..v7.1-epic2-sn2-gpu`

Both verified to apply cleanly, in order, to a clean `v7.1-epic2` checkout.

## Upstream items to watch

- `618e86355c42` "ia64: implement flush_tlb_kernel_range() properly" (in `v7.3-rc3-epic1`,
  not 7.1/7.2) — may make the SN2 `VM_FLUSH_RESET_PERMS` module notifier in
  `arch/ia64/sn/kernel/setup.c` unnecessary. Evaluate at 7.3.
