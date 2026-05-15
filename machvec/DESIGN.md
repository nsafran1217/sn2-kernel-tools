# IA-64 Runtime Machvec Shim via Static Key

## Goal

Produce a single IA-64 kernel image (`CONFIG_IA64_GENERIC=y`) that boots on
both generic IA-64 hardware and on SGI Altix (SN2) hardware.  The platform is
detected at boot via the ACPI XSDT/RSDT OEM ID; all platform-specific
dispatch flips on a single static key.

Dedicated SN2 and dedicated generic builds retain their original
zero-runtime-overhead compile-time paths.

## Three build modes

| Config                                | `ia64_platform_is("sn2")` | SN2 code compiled |
|--                                     |--                         |--                 |
| `IA64_GENERIC=y` (selects SN2)        | runtime (static key)      | yes               |
| `IA64_SGI_SN2=y`, `IA64_GENERIC=n`    | compile-time `true`       | yes               |
| neither                               | compile-time `false`      | no                |

The three-mode header structure gates every use site, so the runtime
overhead is contained entirely within `IA64_GENERIC` builds.

## The static key

`DEFINE_STATIC_KEY_FALSE(sn2_platform_key)` lives in
`arch/ia64/kernel/machvec.c`.  Default is OFF (generic path is the
fall-through).  `ia64_platform_detect()` inspects the ACPI XSDT (or
RSDT) header's `oem_id` field and calls `static_branch_enable()` iff
the OEM ID begins with "SGI".

On IA-64 today, `HAVE_ARCH_JUMP_LABEL` is not implemented, so
`CONFIG_JUMP_LABEL=n` and `static_branch_unlikely()` falls back to the
generic `atomic_read(&key->enabled) > 0` path — a memory load + test +
conditional branch.  Once arch jump-label support lands, the same call
sites automatically become patched-nop fast paths with no data
dependency and no branch on the hot path.

## Call flow at boot

```
setup_arch()
  efi_init()
  io_port_init()
  uv_probe_system_type()
  parse_early_param()
  early_console_setup()
  acpi_table_init()          <-- ACPI tables now mappable
  ia64_platform_detect()     <-- inspects XSDT OEM ID, sets static key
  early_acpi_boot_init()
  acpi_numa_init()
  find_memory()
  ia64_sal_init()
  cpu_init()
    sn_cpu_init() if SN2     <-- runtime-gated
  ia64_mca_init()
  if (ia64_platform_is("sn2"))
      sn_setup()
  else
      uv_setup() / init_smp_config() / primary_display_setup()
```

By the time *any* platform-conditional code runs past
`acpi_table_init()`, the key is set correctly.

## Dispatch sites converted

### Hot path (per-operation)

| Site                                   | Native        | SN2             |
|--                                      |--             |--               |
| `inb`/`inw`/`inl` (`asm/io.h`)         | MMIO load + `mf.a` | `___sn_in*()` via SHUB codec |
| `outb`/`outw`/`outl` (`asm/io.h`)      | MMIO store + `mf.a` | `___sn_out*()` |
| `readb`/`readw`/`readl`/`readq`        | `__raw_read*` + barriers | `___sn_read*()` |
| `readb_relaxed` … `readq_relaxed`      | volatile load | `___sn_read*_relaxed()` |
| `mmiowb()` (`asm/mmiowb.h`)            | `ia64_mfa()`  | `__sn_mmiowb()`  |
| `irq_to_vector` (`asm/hw_irq.h`)       | `irq_cfg[irq].vector` | identity |
| `local_vector_to_irq` (`asm/hw_irq.h`) | `vector_irq[vec]` | identity |

### Warm / cold paths

| Site                                      | Converted from         | To                         |
|--                                         |--                      |--                          |
| `ia64_send_ipi` (`kernel/irq_ia64.c`)     | `__weak` + strong override | runtime dispatcher    |
| `ia64_global_tlb_purge` (`mm/tlb.c`)      | `#ifdef SN2` at caller | runtime dispatcher         |
| `sn_irq_init` (`kernel/irq_ia64.c`)       | `#ifdef SN2`           | runtime branch             |
| `sn_setup` / `sn_cpu_init` (setup.c)      | `#ifdef SN2`           | runtime branch             |
| `sn_cpu_disable_allowed` (smpboot.c)      | `#ifdef SN2`           | runtime branch             |
| `sn_flush_all_caches` (uncached.c)        | `#ifdef SN2`           | runtime branch             |
| `sn_setup_msi_irq` / `sn_teardown_msi_irq`| `#ifdef SN2`           | runtime branch             |
| `sn_pci_fixup_bus` (pci/pci.c)            | `#ifdef SN2`           | runtime branch             |
| `check_crashkernel_memory` (setup.c)      | `IS_ENABLED(SN2)`      | `ia64_platform_is("sn2")`  |

### Not dispatched (remain compile-time)

| Site                                      | Reason                                  |
|--                                         |--                                       |
| `sn2_smp.c`'s strong `ia64_send_ipi` override | guarded off under IA64_GENERIC so the generic dispatcher wins |
| `sn_console.c` (drivers/tty/serial/)      | already used `ia64_platform_is()` at runtime |
| `qla1280.c`, `qla2xxx` driver SN2 hooks   | already used `ia64_platform_is()` at runtime |
| `mspec.c`                                  | already used `ia64_platform_is()` at runtime |

## Cost characteristics

Each runtime dispatch site becomes, in the no-HAVE_ARCH_JUMP_LABEL
fallback:

```
    ld8     r14 = [r15]     ;; load sn2_platform_key.enabled
    cmp.gt  p6 = r14, r0    ;; test > 0
(p6) br.cond.sptk  sn2_path
    <generic path>
```

For port and MMIO I/O on non-SN2 Itanium, that's one extra load and
one extra conditional branch per operation.  The branch predictor will
lock onto the not-taken direction after the first few calls so the
in-order cost is dominated by the load latency (a cache hit if
`sn2_platform_key` stays in L1, ~2-3 cycles).

For `mmiowb()` the added load is serialized with the `mf.a`, so
effectively free.

For warm paths (`sn_setup`, `sn_cpu_init`, etc.) the overhead is
unmeasurable since they run once at boot.

Once `HAVE_ARCH_JUMP_LABEL` is implemented, the same call sites drop
to a patched `nop`/`br.cond.sptk` pair and the cost goes to zero on
the expected path.

## Files changed

```
 arch/ia64/Kconfig                 |  26 +++++-
 arch/ia64/Kbuild                  |   (unchanged; sn/ built on SN2)
 arch/ia64/include/asm/hw_irq.h    |  13 ++-
 arch/ia64/include/asm/io.h        | 183 +++++++++++++++++++++++++++++--
 arch/ia64/include/asm/machvec.h   |  83 +++++++++++++--
 arch/ia64/include/asm/mmiowb.h    |  22 ++++-
 arch/ia64/kernel/Makefile         |   1 +
 arch/ia64/kernel/irq_ia64.c       |  37 ++++++-
 arch/ia64/kernel/machvec.c        |  79 ++++++++++++++  (new)
 arch/ia64/kernel/msi_ia64.c       |   9 +-
 arch/ia64/kernel/setup.c          |  41 +++++--
 arch/ia64/kernel/smpboot.c        |   5 +-
 arch/ia64/kernel/uncached.c       |  11 +--
 arch/ia64/mm/tlb.c                |  14 ++-
 arch/ia64/pci/pci.c               |   5 +-
 arch/ia64/sn/kernel/sn2/sn2_smp.c |   7 ++
 15 files changed, 484 insertions(+), 52 deletions(-)
```

## Patch series

| # | Patch                                                | Purpose                                   |
|--:|--                                                    |--                                         |
| 1 | `ia64-Kconfig-add-IA64_GENERIC-option`               | Kconfig scaffolding                       |
| 2 | `ia64-add-runtime-machvec-shim-static-key-ACPI`      | `machvec.c` + `machvec.h` three-mode      |
| 3 | `ia64-setup.c-wire-ia64_platform_detect`             | call detection; convert setup SN2 hooks   |
| 4 | `ia64-convert-core-ifdef-SN2-init-hooks`             | irq, msi, uncached, smpboot, pci          |
| 5 | `ia64-mm-tlb.c-runtime-dispatch-for-global-TLB-purge`| always-compile TLB purge; runtime branch  |
| 6 | `ia64-io.h-runtime-dispatch-for-port-I-O-and-MMIO`   | the hot path                              |
| 7 | `ia64-mmiowb.h-runtime-dispatch-for-SN2-vs-generic`  | mmiowb                                    |
| 8 | `ia64-hw_irq.h-runtime-dispatch-for-irq_to_vector`   | per-interrupt hot-path inlines            |
| 9 | `ia64-Kconfig-IA64_GENERIC-depends-on-FLATMEM`       | inherit SN2's `depends on !FLATMEM`       |

## Testing checklist

Before this can be declared "proven to work":

1. **Boot-test IA64_GENERIC=y on a non-SN2 IA-64 box.**
   Expect `pr_info`: `ia64: platform detected: generic (OEM ID '<XXX>')`
   and normal generic boot.  No SN2 path should be exercised.

2. **Boot-test IA64_GENERIC=y on an SN2 (Altix) box.**
   Expect `pr_info`: `ia64: platform detected: SN2 (OEM ID 'SGI...')`.
   SHUB-based I/O, IPIs, TLB purge, and MMIO barriers must work.  No
   "Invalid provider_call" or similar SAL errors.

3. **Rebuild-test IA64_SGI_SN2=y, IA64_GENERIC=n.**
   `objdump -d` on `setup.c`, `irq_ia64.c`, `tlb.c`, `io.h` users
   should show the SN2 path as direct calls with no static-key load.
   Binary size should match a pre-patch SN2 build.

4. **Rebuild-test with both off.**
   No references to `sn_*` symbols in the final `vmlinux`.

## Follow-up: HAVE_ARCH_JUMP_LABEL for ia64

Once the above is proven to work, the next patch implements
`HAVE_ARCH_JUMP_LABEL` for ia64.  Scope:

- `arch/ia64/include/asm/jump_label.h` with `arch_static_branch()`
  and `arch_static_branch_jump()` using `asm goto`; emit `nop.m 0`
  or `br.cond.sptk` as appropriate, in the correct bundle slot.
- `arch/ia64/kernel/jump_label.c` implementing
  `arch_jump_label_transform()` — rewrite bundle template + slot
  atomically (128-bit aligned store), then `fc.i` / `sync.i` /
  `srlz.i` for icache coherency across CPUs.  The kprobes code
  already does the icache flush dance for ia64; that's the pattern
  to mirror.
- `JUMP_LABEL_NOP_SIZE` = size of one ia64 instruction slot.
- `select HAVE_ARCH_JUMP_LABEL` in `arch/ia64/Kconfig`.

Roughly 100–150 lines of new arch code, comparable to arm64's
implementation.  No source-level changes to any of the call sites
added by this series.
