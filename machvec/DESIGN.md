# SN2 runtime platform dispatch ("machvec")

Branch `sn2-machvec-7.3` in `src/mainline/linux-sn2` (worktree
`src/machvec/linux-sn2-7.3`), on top of `master-epic-sn2`.  It replaces the
earlier `sn2-machvec` branch (one squashed "Boot working" commit on 7.0-rc1)
and the `0001`–`0009` patches now in `OLD/`, which are kept only for
reference.

## Goal

- **Combined kernel**: one image that boots on SGI Altix (SN2) and on HP
  Integrity / other generic ia64, with no measurable cost on Integrity.  Where
  there is a cost, SN2 pays it.
- **SN2-only kernel**: identical code to the compile-time SN2 layer, no
  runtime tests.
- **Generic kernel**: identical to upstream linux-ia64.

## Build modes

| Config                                     | `ia64_is_sn2()`                          | Boots on        |
|--                                          |--                                        |--               |
| `IA64_SGI_SN2=n`                           | `false` (constant)                       | generic         |
| `IA64_SGI_SN2=y`, `IA64_SGI_SN2_ONLY=n` (default) | `unlikely(ia64_sn2_platform)` (plain `__read_mostly` bool) | SN2 and generic |
| `IA64_SGI_SN2=y`, `IA64_SGI_SN2_ONLY=y`    | `true` (constant)                        | SN2 only        |

`CONFIG_IA64_SGI_SN2` still means "SN2 code is compiled in", so the ~30k lines
under `arch/ia64/sn` and the SN2 drivers are untouched.  Every platform test in
shared code is written `if (ia64_is_sn2()) … else …` (inside the existing
`#ifdef CONFIG_IA64_SGI_SN2` where the SN2 side needs SN2-only symbols), so
the constant modes fold the dead branch away.

The pre-5.4 `ia64_platform_is("sn2")` spelling is gone (the series' first
SN2 commit, `b9638f628a2a`): the SN2 code and drivers call `ia64_is_sn2()`
too, so there is one name for the test.

SWIOTLB and ZONE_DMA32 are selected in every mode, with SN2's
`MAX_DMA_ADDRESS` set to the top of the PIC direct32 window (GPU-layer
commit 8f8f9696915e, adopted into this series as its first commit because it
is well tested).

## Detection

`ia64_platform_detect()` (`arch/ia64/kernel/machvec.c`) runs in `setup_arch()`
right after `uv_probe_system_type()`, before early params and the early
console.  ACPICA isn't up yet, so it reads the XSDT header through
`__va(efi.acpi20)` and treats OEM ID "SGI" without "UV" in the OEM table ID as
SN2, the same test as the pre-5.4 `acpi_get_sysname()`.

- Combined: sets `ia64_sn2_platform`.  (The old branch enabled a static key
  here, before `jump_label_init()`, which WARNs.)
- SN2-only: panics with a clear message on non-SGI hardware.
- Logs `ia64: platform SN2|generic (ACPI OEM ID '…')`.

## Dispatch sites

| Site | Kind | Notes |
|--|--|--|
| `inb/w/l`, `outb/w/l` (`asm/io.h`) | hot | SN2 path out of line (`sn2/io.c`) |
| `insb/w/l`, `outsb/w/l` | hot | one test per call, not per element |
| `readb/w/l/q` | hot | wraps asm-generic's own `readX` (tracepoints kept); SN2 path out of line |
| `readX_relaxed`, `writeX` | — | not dispatched: identical on SN2 |
| `mmiowb()` (`asm/mmiowb.h`) | hot-ish | only on unlock after MMIO writes |
| `irq_to_vector`, `local_vector_to_irq` (`asm/hw_irq.h`) | per IRQ | |
| `ia64_send_ipi` (`irq_ia64.c`) | warm | no longer `__weak`; SN2 override dropped |
| `__flush_tlb_range` global purge (`mm/tlb.c`) | warm | |
| `sn_setup` / `uv_setup` / `init_smp_config` / `primary_display_setup`, `sn_cpu_init`, crashkernel (`setup.c`) | cold | |
| `sn_irq_init`, SN2 MSI, `sn_cpu_disable_allowed`, `sn_flush_all_caches`, `sn_pci_fixup_bus` | cold | |
| qla1280 (vchannel DMA, NVRAM), qla2xxx (NVRAM defaults), mspec (fetchop) | driver init | were compile-time and would misbehave on HP |
| `acpi.c`, `sal.c`, `sn_console`, `snsc`, `mbcs`, `sgi-agp`, `arch/ia64/sn` initcalls | — | already runtime |

### Why a plain flag and not a static key

Without `HAVE_ARCH_JUMP_LABEL`, `static_branch_unlikely()` is `atomic_read()`,
a volatile load, and ia64 gcc prints every volatile memory operand with
`.acq` (`ia64_print_operand`, case `'O'`).  So the static key put an
`ld4.acq` (an acquire fence that also can't be speculated or hoisted) at
every dispatch site: 3765 in vmlinux and 19626 in 1165 modules of the
combined distribution-style config.  The flag is written once, before
secondary CPUs start, so a plain `ld1` is correct, and gcc may hoist it out
of loops.

In combined mode each hot site costs a GOT-relative address load, a 1-byte
load of the flag, a compare and a predicted-not-taken branch on generic
hardware.  On SN2 it also costs an out-of-line call.  The SN2 bodies are kept
out of line so they don't grow every driver's I-cache footprint on Integrity.

## Not done

- **Jump labels.** ia64 has no `HAVE_ARCH_JUMP_LABEL`; the `OLD/jump_label/`
  patch here is not ready: it patches possibly read-only module text, enables
  keys before `jump_label_init()`, and costs a full nop bundle with a stop
  bit per site, which may not beat a load on in-order Itanium.  It would also
  change every static key in the kernel.  Only revisit if the benchmarks show
  a real cost on Integrity, and then as separate linux-ia64 work.
- **GPU layer.** Its `#ifdef CONFIG_IA64_SGI_SN2` hunks in `ttm_pool.c`,
  `ttm_bo_util.c`, `drm_cache.c` (uncached TTM pages, `drm_need_swiotlb()`
  forced false) and `amdgpu_uvd.c` would apply SN2 behaviour on HP in a
  combined kernel.  They must become runtime tests when the GPU layer is
  restacked on this series.

## Configs and toolchain

Mode configs live in `src/machvec/cfg/` (to be saved as
`configs/7.3-epic-sn2-{combined,only}.config` and
`configs/7.3-epic-generic.config` once tested).  They differ only in the
platform options; the combined config also builds in the IGB, E1000(E), TG3,
TULIP and BNX2 NIC drivers so the HP boxes can NFS-root boot the same image.

Kernels for this work are built with gcc 16.2.0 + binutils 2.47 carrying T2
SDE's ia64 patches (`sn2-kernel-tools/build-cross-gcc.sh`, selected with
`IA64_GCC_VERSION=16.2.0`).  Every kernel in a comparison must use the same
compiler.

## Measuring

See `bench/README.md`.
