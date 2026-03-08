# Plan: Re-adding SN2 to Linux v5.4 Without Machvec

## Philosophy

The v3 patch set brings back the full machvec dispatch infrastructure (runtime
platform selection, function pointer tables, DIG/ZX1/UV/hpsim machvec
definitions). This touches **67+ existing files** and rewrites core ia64
subsystems (I/O, IPI, DMA, TLB) to route through machvec function pointers.

**Our approach instead:** compile-time platform selection via `CONFIG_IA64_SGI_SN2`.
SN2 hooks into core ia64 code through `#ifdef` guards and weak symbol overrides,
NOT through machvec dispatch. This means:

- No `struct ia64_machine_vector` or runtime machvec selection
- No DIG/ZX1/UV/hpsim machvec definitions needed
- No rewriting of io.h I/O functions to use `platform_*` dispatch
- Existing ia64 code remains largely untouched
- SN2 can be enabled as a Kconfig option for dedicated SN2 kernels

## Key Design Decisions

### 1. `ia64_platform_is()` — Minimal Compatibility Shim

SN2 code calls `ia64_platform_is("sn2")` ~19 times across platform code and
drivers. Rather than bringing back machvec, we provide a **minimal stub
`asm/machvec.h`** that defines `ia64_platform_is()` as a compile-time check:

```c
#ifdef CONFIG_IA64_SGI_SN2
static inline int ia64_platform_is(const char *name) {
    return strcmp(name, "sn2") == 0;
}
#else
static inline int ia64_platform_is(const char *name) {
    return strcmp(name, "dig") == 0;
}
#endif
```

This satisfies all existing SN2 code without changing it, and costs nothing at
runtime (compiler optimizes the strcmp on string literals to a constant).

### 2. I/O Functions — `#ifdef` Override in io.h

SN2 needs custom inb/outb/readl/writel that route through SHUB. Instead of
the machvec approach (renaming all functions, adding platform_* dispatch for
ALL platforms), we add a targeted `#ifdef CONFIG_IA64_SGI_SN2` block at the
end of io.h:

```c
#ifdef CONFIG_IA64_SGI_SN2
#include <asm/sn/io.h>
/* SN2 overrides port and MMIO I/O to route through SHUB */
#undef inb
#define inb(p)  ___sn_inb(p)
/* ... etc for inw, inl, outb, outw, outl, readb, readw, readl, readq,
   and relaxed variants */
#endif
```

**This is ~30 lines added to io.h vs the 189-line rewrite in patch 06.**
The existing ia64 I/O implementations remain untouched; they're just
overridden for SN2 builds.

### 3. IPI Sending — Weak Symbol Override

SN2 uses SHUB registers for IPIs instead of the standard ia64 IPI mechanism.
`sn2_send_IPI()` has the SAME signature as `ia64_send_ipi()`. We make
`ia64_send_ipi` a weak symbol in irq_ia64.c (1-line change), and SN2's
sn2_smp.c provides the override. **Zero changes to any IPI callers.**

### 4. TLB Purge — Weak Symbol Override

SN2 has a custom global TLB purge (ptc_deadlock.S) to avoid SHUB deadlocks.
`ia64_global_tlb_purge()` can be made weak; SN2 provides its override in
sn2_smp.c. **Zero changes to TLB callers.**

### 5. DMA — Standard dma_ops Registration

v5.4 already has `extern const struct dma_map_ops *dma_ops` with
`get_arch_dma_ops()` returning it. SN2's `sn_setup()` just sets
`dma_ops = &sn_dma_ops`. **No changes to dma-mapping.h.**

### 6. mmiowb — `#ifdef` in mmiowb.h

SN2 needs a custom MMIO write barrier. Small `#ifdef CONFIG_IA64_SGI_SN2`
addition to mmiowb.h (~5 lines).

### 7. MSI — `#ifdef` Delegation

SN2 has custom MSI setup (msi_sn.c). Small `#ifdef` block in msi_ia64.c
to delegate to SN2's MSI functions when configured.

### 8. Platform Setup — `#ifdef` Hook in setup.c

Instead of replacing the entire setup flow with `platform_setup()` machvec
dispatch, we ADD an `#ifdef CONFIG_IA64_SGI_SN2` block that calls
`sn_setup()` at the right point. Existing setup.c flow (screen_info_setup,
UV probing, ROOT_DEV) remains untouched.

---

## Patch-by-Patch Plan

### KEEP AS-IS (drop-in new files)

| v3 Patch | Files | Action |
|----------|-------|--------|
| 02-ia64-sn2-headers.patch | 35 new files | Keep unchanged — SN2 headers have no machvec deps |
| 07-drivers-sn2-new.patch | 3 new files | Keep unchanged — drivers/sn/ |
| 10-misc.patch | 1 file | Keep unchanged — pci_ids.h |

### KEEP WITH MINOR MODIFICATIONS

| v3 Patch | Files | Changes Needed |
|----------|-------|----------------|
| 01-ia64-sn2-platform.patch | 42 new files | Remove `sn/kernel/machvec.c` (machvec definition, not needed). Modify `sn2/io.c` to compile without `CONFIG_IA64_GENERIC` guard (or just compile unconditionally; the wrappers are harmless). |
| 00-drivers-sn2-sources.patch | 14 new files | No changes likely needed — `ia64_platform_is()` calls work with our shim. |
| 08-drivers-build-system.patch | 14+ files | Keep Kconfig/Makefile additions. May need minor guard changes. |
| 09-drivers-source-mods.patch | 4 files | Keep — mspec.c, sgi-xp, qla changes. `ia64_platform_is()` works with shim. |

### REPLACE ENTIRELY

#### Patch 03: machvec-infra → sn2-compat-shim

**v3**: 21 new files, 891 lines — full machvec dispatch system
**New**: 1-2 new files, ~30 lines — minimal compatibility header

New files:
- `arch/ia64/include/asm/machvec.h` — Stub with `ia64_platform_is()`, `ia64_platform_name`

Skip entirely:
- All machvec_*.h headers (dig, dig_vtd, hpsim, hpzx1, hpzx1_swiotlb, uv, init)
- `machvec_sn2.h` — SN2 function declarations move to SN2's own headers
- `arch/ia64/kernel/machvec.c` — runtime selection, not needed
- `arch/ia64/dig/*` — DIG platform, not needed
- `arch/ia64/hp/zx1/*` — HP ZX1, not needed
- `arch/ia64/hp/common/hwsw_iommu.c` — not needed
- `arch/ia64/hp/sim/hpsim_machvec.c` — not needed
- `arch/ia64/uv/kernel/machvec.c` — not needed
- `arch/ia64/sn/kernel/machvec.c` — not needed

#### Patch 04: hpsim → SKIP ENTIRELY

Not needed. `IA64_HP_SIM` conditionals evaluate as always-false.

#### Patch 05: build-system → sn2-build (simplified)

**v3**: 11 files, +166/-48 — full system type choice menu, machvec build rules
**New**: ~5-6 files, ~80 lines — simplified SN2 Kconfig + Makefile additions

Changes:
- `arch/ia64/Kconfig`: Add `CONFIG_IA64_SGI_SN2` as a simple bool (NOT in a
  choice menu), `CONFIG_SGI_SN`, and guards for ZONE_DMA32,
  NUMA dependencies. Add `source "drivers/sn/Kconfig"`.
- `arch/ia64/Makefile`: Add `core-$(CONFIG_IA64_SGI_SN2) += arch/ia64/sn/`
- `arch/ia64/kernel/Makefile`: Add SN2 conditional objects
- `drivers/sn/Kconfig`: Already provided by patch 07

Skip:
- System type choice menu (IA64_GENERIC, IA64_DIG, etc.)
- Machvec build rules
- DIG/ZX1/UV/hpsim Makefile additions
- defconfig changes

#### Patch 06: core-mods → sn2-hooks (massively reduced)

**v3**: 46 files modified, +877/-259 — full machvec integration
**New**: ~15-20 files modified, ~250-300 lines — targeted `#ifdef` hooks

Files to modify (with approach):

| File | Lines | Approach |
|------|-------|----------|
| `asm/io.h` | +~30 | `#ifdef CONFIG_IA64_SGI_SN2` block at end to override I/O funcs |
| `asm/machvec.h` | NEW | Minimal shim (ia64_platform_is, ia64_platform_name) |
| `asm/mmiowb.h` | +~8 | `#ifdef` for SN2 mmiowb |
| `asm/acpi.h` | +~10 | `#ifdef` for SN2 ACPI hooks |
| `asm/hw_irq.h` | +~10 | `#ifdef` for SN2 IRQ defs (is_affinity_mask_valid, etc.) |
| `asm/mmzone.h` | +~8 | `#ifdef` for SN2 NUMA zone defs |
| `asm/pci.h` | +~5 | `#ifdef` for SN2 PCI controller data |
| `kernel/irq_ia64.c` | +~3 | Make `ia64_send_ipi` weak symbol |
| `kernel/setup.c` | +~20 | `#ifdef` block to call sn_setup(), sn_cpu_init(), early console |
| `kernel/acpi.c` | +~40 | `#ifdef` for SN2 ACPI node mapping (SAL calls) |
| `kernel/mca.c` | +~15 | `#ifdef` for SN2 MCA hooks |
| `kernel/msi_ia64.c` | +~15 | `#ifdef` for SN2 MSI delegation |
| `kernel/kprobes.c` | +~25 | `#ifdef` for SN2 uncached kprobe slots |
| `kernel/smpboot.c` | +~6 | `#ifdef` for SN2 CPU calibration bypass |
| `kernel/sal.c` | +~6 | `#ifdef` for SN2 SAL additions |
| `kernel/pci-dma.c` | +~10 | `#ifdef` for SN2 DMA init |
| `kernel/dma-mapping.c` | +~10 | `#ifdef` for SN2 DMA ops |
| `mm/tlb.c` | +~3 | Make `ia64_global_tlb_purge` weak symbol |
| `mm/init.c` | +~5 | `#ifdef` for conditional SWIOTLB |
| `pci/pci.c` | +~6 | `#ifdef` for SN2 PCI hooks |

Files we **SKIP** (no longer needed):
- `asm/dma-mapping.h` — no platform_dma_get_ops dispatch
- `asm/iommu.h`, `asm/iosapic.h`, `asm/switch_to.h`, `asm/tlb.h` — were just machvec.h includes
- `asm/processor.h` — was just machvec include
- `asm/uv/uv.h` — UV machvec changes, irrelevant
- `asm/dma.h`, `asm/irq.h` — minor machvec-only changes
- `hp/common/sba_iommu.c` — machvec-specific IOMMU changes (SN2 doesn't use SBA)
- `uv/kernel/setup.c` — UV machvec setup changes
- `kernel/irq.c` — was mostly machvec IRQ init; SN2 does its own in sn_irq_init()
- `kernel/smp.c` — was platform_send_ipi; handled by weak symbol
- `kernel/signal.c` — was just machvec.h include
- `kernel/sys_ia64.c` — platform_intr_list; handle differently
- `kernel/time.c` — platform_timer_interrupt; SN2 registers its own
- `kernel/topology.c` — minor, can skip
- `kernel/unaligned.c` — was just machvec.h include
- `kernel/uncached.c` — SN2-specific but small; keep if needed
- `kernel/vmlinux.lds.S` — machvec section, not needed
- `kernel/module.c` — minor, can skip
- `kernel/machine_kexec.c`, `kernel/mca_drv.c` — just includes
- `kernel/iosapic.c` — machvec-only changes
- `lib/io.c` — machvec legacy I/O; not needed
- `mm/discontig.c` — machvec-only
- `pci/fixup.c` — machvec-only

**Result: ~20 files modified instead of 46, ~250 lines instead of 877+.**

---

## SN2 Platform Code Modifications

The SN2 code in `arch/ia64/sn/` needs a few adjustments to work without machvec:

1. **Remove `sn/kernel/machvec.c`** — This just defined the machvec entry point.
   Not needed for compile-time selection.

2. **`sn2/io.c`** — Currently guarded by `#ifdef CONFIG_IA64_GENERIC`. Either:
   - Remove the guard (compile unconditionally), OR
   - Change to `#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)`
   These wrappers convert inline I/O functions to callable function pointers.
   For our compile-time approach where io.h directly `#define`s to the `___sn_*`
   inlines, we may not need these at all. **Evaluate during implementation.**

3. **`sn/kernel/setup.c`** — References `platform_intr_list[]` which was defined
   in `kernel/irq.c` via machvec. We'll define it in SN2's own code or add a
   minimal definition to irq.c behind `#ifdef CONFIG_IA64_SGI_SN2`.

4. **`sn2/sn2_smp.c`** — Contains `sn2_send_IPI()` which becomes the weak
   override for `ia64_send_ipi()`. Need to add:
   ```c
   void ia64_send_ipi(int cpu, int vector, int delivery_mode, int redirect)
       __attribute__((alias("sn2_send_IPI")));
   ```
   Or rename `sn2_send_IPI` to `ia64_send_ipi` directly.

---

## Comparison: v3 Patches vs New Approach

| Metric | v3 (machvec) | New (compile-time) |
|--------|-------------|-------------------|
| New files added | ~118 | ~98 (skip machvec + hpsim) |
| Existing files modified | ~70 | ~30-35 |
| Lines changed in existing | ~1400 | ~400-500 |
| io.h changes | +189/-33 (full rewrite) | +~30 (ifdef block) |
| setup.c changes | +36/-60 (removes code) | +~20 (adds ifdef block) |
| Supports CONFIG_IA64_GENERIC | Yes | No (dedicated SN2 build only) |
| DIG/ZX1/UV/hpsim machvecs | Restored | Not needed |
| Forward-portability | Hard (46-file merge) | Easier (~20 small ifdefs) |

## Risks and Mitigations

1. **SN2 code assumes machvec_sn2.h function declarations exist.**
   → Move necessary declarations to SN2's own headers or the compat shim.

2. **Some SN2 code may call `platform_*` macros not just `ia64_platform_is`.**
   → Audit found only `platform_intr_list[]` and `platform_cpu_init` (comment only).
   These are easily handled.

3. **Weak symbol override may not work for all functions.**
   → Test with ia64 cross-compiler. Fallback: `#ifdef` in callers.

4. **SN2 drivers expect certain kernel infrastructure.**
   → The driver-level changes (patches 08, 09) are mostly Kconfig/Makefile and
   work regardless of machvec approach.

5. **`CONFIG_IA64_GENERIC` guards in SN2 code.**
   → Several SN2 files have `#ifdef CONFIG_IA64_GENERIC` blocks (notably sn2/io.c).
   These need to be changed to also trigger on `CONFIG_IA64_SGI_SN2`.

## Implementation Order

1. Create minimal `asm/machvec.h` shim
2. Modify Kconfig/Makefiles (simplified patch 05)
3. Add `#ifdef` hooks to core ia64 files (new patch 06)
4. Add weak symbol overrides (irq_ia64.c, tlb.c)
5. Apply SN2 platform code (patch 01, with machvec.c removed)
6. Apply SN2 headers (patch 02, unchanged)
7. Apply driver new files (patches 00, 07)
8. Apply driver build system (patch 08)
9. Apply driver source mods (patch 09)
10. Apply misc (patch 10)
11. Test build with ia64 cross-compiler

## Resolved Questions

- **`platform_intr_list[]`**: Already exists in v5.4's `kernel/acpi.c` (line 50).
  SN2's `extern int platform_intr_list[]` will just link. No changes needed.

- **`ia64_platform_name`**: Exists as `char ia64_platform_name[64]` in v5.4
  setup.c but is NEVER READ anywhere. Dead variable. Our shim does NOT need
  to provide it. If SN2 code needs it in the future, `sn_setup()` can just
  `strlcpy(ia64_platform_name, "sn2", ...)`.

- **`qla1280.h` buggy fallback macro**: The v3 patch 09 adds a fallback
  `#define ia64_platform_is(foo) (!strcmp(x, platform_name))` — this is buggy
  (wrong variable names) but harmless because our `asm/machvec.h` shim defines
  the real `ia64_platform_is()` first, so the `#if !defined` guard skips it.

## Open Questions

- **`sn2/io.c` function wrappers**: Do any callers need the non-inline
  `__sn_inb` symbols, or are the `___sn_inb` inlines sufficient? If only
  inlines are needed (likely for compile-time SN2), we can skip sn2/io.c entirely.

- **UV setup.c changes in v3 patch 06**: The v3 patches modify
  `uv/kernel/setup.c` significantly (adding MEDUSA support, sn_prom_type, etc.).
  These look like they may be SN2/UV shared infrastructure. Need to evaluate
  if any of these are needed for SN2, or if they're UV-specific.

---

## v5.10 Forward-Port Notes

### Summary

Forward-porting sn2-v5.5-complete.patch to v5.10 required resolving
3 hunk rejects and 8 additional build fixes for API changes.  All fixes
have been folded into the complete and split patches.

### Rejected Hunks (from v5.5 patch application)

| File | Hunk | Disposition | Reason |
|------|------|-------------|--------|
| `arch/ia64/Kconfig` | #1 | Dropped | `ARCH_HAS_SYNC_DMA_FOR_CPU` removed; `ARCH_HAS_DMA_MARK_CLEAN` always-on |
| `arch/ia64/mm/init.c` | #1 | Dropped | `arch_sync_dma_for_cpu()` renamed; no guard needed |
| `drivers/char/Kconfig` | #1 | Reanchored | Restructured; SGI entries placed before `endmenu` |

### Build Fixes (folded into patches)

| # | File(s) | Fix | API Change |
|---|---------|-----|------------|
| 1 | `init.c` | Remove orphan `#endif` | `ARCH_HAS_SYNC_DMA_FOR_CPU` → `ARCH_HAS_DMA_MARK_CLEAN` |
| 2 | `tlb.c` | Guard `ia64_global_tlb_purge` | SN2 bypasses it → unused function |
| 3 | `setup.c` | `efi.hcdp` → `hcdp_phys` | EFI struct cleanup v5.7 |
| 4 | `tiocx.c`, `pcibr_provider.c` | Remove `uninitialized_var()` | Macro removed v5.10 |
| 5 | `pcibr_provider.h` | Add `struct pci_bus` fwd decl | Missing forward declaration |
| 6 | `include/linux/ioc3.h` | Re-add header | Removed with MIPS IOC3 rewrite |
| 7 | `snsc_event.c` | `DECLARE_TASKLET` 2-arg API | Tasklet API change v5.10 |
| 8 | `pci_dma.c` | Add `dma-map-ops.h` | DMA header split v5.10 |
| 9 | `sn2_smp.c`, `sn_proc_fs.c` | `proc_ops` conversion | v5.6 proc API |
| 10 | `Kconfig` files | `---help---` → `help` | Kconfig syntax v5.10 |

### Split Patches

| Patch | Files | Description |
|-------|-------|-------------|
| **0001** | 94 | Drop-in: SN2 platform, headers, drivers, misc |
| **0002** | 1 | machvec.h shim |
| **0003** | 2 | Kconfig + Makefile |
| **0004** | 12 | Core ia64 hooks |
| **0005** | 12 | Driver Kconfig/Makefiles |
| **0006** | 4 | Driver source mods |

### Patch Lineage

- `sn2-v5.4-complete.patch` → original compile-time SN2 re-addition
- `sn2-v5.5-complete.patch` → forward-port to v5.5
- `sn2-v5.10-complete.patch` → forward-port to v5.10 (all build fixes folded in)
