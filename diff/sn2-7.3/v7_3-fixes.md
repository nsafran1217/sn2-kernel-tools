# SN2 on v7.3-rc3-epic1

Base: `v7.3-rc3-epic1` (linux-ia64; latest 7.3 tag as of 2026-09-27 — an rc, taken early to
evaluate the upstream TLB change). Previous version: `v7.2-epic3-sn2` / `v7.2-epic3-sn2-gpu`.

Tags (linux-sn2): `v7.3-rc3-epic1-sn2`, `v7.3-rc3-epic1-sn2-gpu` — boot-tested on hardware with
the GPU tag (2026-09-27). `master-epic-sn2` / `master-epic-sn2-gpu` point at these tags
(linux-ia64 `master-epic` == `v7.3-rc3-epic1` at the time).

Boot-test result: with the notifier removed, amdgpu use no longer shows the intermittent crashes
seen on earlier versions (they were never reproducible every boot, so this is an observed
improvement, not a proof).

## Patches

- `sn2-v7.3-rc3-epic1-complete.patch` — `git diff v7.3-rc3-epic1..v7.3-rc3-epic1-sn2`
- `sn2-gpu-v7.3-rc3-epic1.patch` — `git diff v7.3-rc3-epic1-sn2..v7.3-rc3-epic1-sn2-gpu`

Both verified to apply cleanly, in order, to a clean `v7.3-rc3-epic1` checkout.

## Layout

| Layer | Commits on top of v7.2 |
|---|---|
| SN2 | **sn2: Kconfig: drop redundant !FLATMEM dependency**; **sn2: remove VM_FLUSH_RESET_PERMS module notifier**; **sn2: use alloc_pages_node() now that __alloc_pages_node() is gone** |
| GPU | unchanged (6 commits; `git range-diff` identical apart from Kconfig context) |

All v7.2 commits cherry-picked without conflicts.

## Kconfig recursive dependency — `arch/ia64/Kconfig`

`88f9f27bb3d2` "ia64: disentangle NUMA <-> !FLATMEM cycle" follows mm's
`FLATMEM depends on !NUMA`. With `IA64_SGI_SN2` still `depends on !FLATMEM` and
`select NUMA`, `olddefconfig` fails:

```
symbol NUMA is selected by IA64_SGI_SN2
symbol IA64_SGI_SN2 depends on FLATMEM
symbol FLATMEM depends on NUMA
```

Fix: drop `depends on !FLATMEM`. Selecting `NUMA` already excludes `FLATMEM`.

## `__alloc_pages_node()` removed — `uncached.c`, `pci_dma.c`

`bcdd8d43a7ca` "mm: remove __alloc_pages_node()" dropped the helper after converting its callers
to `alloc_pages_node()`. The SN2 copies in `arch/ia64/kernel/uncached.c` (uncached pool chunk
allocation) and `arch/ia64/sn/pci/pci_dma.c` (`sn_dma_alloc_coherent()`) are converted the same
way. Both already pass a valid node (explicit `nid` + `__GFP_THISNODE`; `node >= 0` checked), so
the added `NUMA_NO_NODE` check never fires — no behavior change.

## flush_tlb_kernel_range() and the module notifier

### Upstream change

`618e86355c42` "ia64: implement flush_tlb_kernel_range() properly". Before it,
`flush_tlb_kernel_range()` was `flush_tlb_all()` (`/* XXX fix me */`) — `on_each_cpu()` IPI to
every CPU, each running a full local `ptc.e` sweep. Now it computes a purge size from
`purge.mask` and runs a ranged `ptc.l` loop on each CPU via `on_each_cpu()`, falling back to
`flush_tlb_all()` only if the range crosses a region or would take > 1024 purges per CPU. With
Montecito purge sizes up to 4 GB the fallback is not reached in practice. Its changelog cites
stale translations surviving thousands of `ptc.e` flushes on Montecito (module sections
overwritten through stale TLB entries) and Altix GPU driver loading breaking.

### History of the SN2 workaround

| Version | Workaround | Doc |
|---|---|---|
| 5.2 | `module_alloc()` override without `VM_FLUSH_RESET_PERMS` (bisect: `868b104d7379`) | `sn2-5.2-ModuleLoading/5.2-module-fixes.md`, `bisect-notes/5.x-USB-issues.md` |
| 6.4 | + `module_memfree()` override clearing the flag (`module_enable_x()` re-adds it) | `sn2-6.4/6.4-module-memfree.md` |
| 6.12 / 6.16 | execmem removed both hooks → module notifier clearing the flag at `MODULE_STATE_LIVE` / `GOING` (patch 0012) | `sn2-6.16/v6.16-fixes.md`, `sn2-6.16/build-issues.md` |
| 6.17 – 7.2 | notifier carried forward | per-version fixes notes |

### The recorded rationale was wrong

Every doc above attributes the crash to `flush_tlb_kernel_range()` → `sn2_global_tlb_purge()`
→ SHub PTC.GA broadcasts colliding with PIO. That call path never existed: since at least 4.19
(`src/kerns/linux-4.19.325*/arch/ia64/include/asm/tlbflush.h`) `flush_tlb_kernel_range()` was
`flush_tlb_all()` → IPI + local `ptc.e`. `sn2_global_tlb_purge()` is only reached from
`__flush_tlb_range()` for user mms (the SN2 hunk in `arch/ia64/mm/tlb.c`, still needed).

A better fit for the 5.2 symptoms (intermittent, varying fault types, corrupted addresses, always
during module load) is the stale-TLB behavior described in `618e86355c42`: freed module VA gets
reused while a translation that `ptc.e` failed to remove is still live. Suppressing the eager
flush made VA reuse rare during boot (lazy purge only), which hid it.

### Fix

Notifier removed from `arch/ia64/sn/kernel/setup.c`, along with `#include <linux/vmalloc.h>`
(added in 5.2 for the `module_alloc()` override, unused since). Module memory takes the normal
`vfree()` → `vm_reset_perms()` → `flush_tlb_kernel_range()` path.

No other TLB/vmalloc/module workarounds exist in generic code in any per-version patch
(checked every `*complete.patch` under `diff/` and all branches in linux-sn2).

### Boot test focus

- Module loading at boot (USB, sound — the original 5.2 crash site) across several boots.
- GPU driver load (`amdgpu` / `radeon`).
- Repeated load/unload of a module that probes hardware (e.g. a USB HCD or sound driver):
  `for i in $(seq 50); do modprobe -r <mod>; modprobe <mod>; done`, watching dmesg for faults.
