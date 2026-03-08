# SN2 v5.10 Build Issues

# THESE ARE INCLUDED IN THE MAIN PATCHES NOW

Tracking file for build issues found after applying sn2-v5.10-complete.patch
to a clean Linux 5.10 tree.

---

## Issue 1: `arch/ia64/mm/init.c:84` — `#endif without #if`

**Error:**
```
arch/ia64/mm/init.c:84:2: error: #endif without #if
   84 | #endif
```

**Cause:** The v5.5 patch had two hunks for init.c.  Hunk #1 added
`#ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU` before `arch_sync_dma_for_cpu()`.
Hunk #2 added `#endif` after it.  In v5.10, the function was renamed to
`arch_dma_mark_clean()` so hunk #1 was rejected — but hunk #2's context
still matched and applied, leaving an orphan `#endif`.

**Fix:** Remove the stray `#endif`.  The guard is no longer needed since
`ARCH_HAS_DMA_MARK_CLEAN` is unconditionally selected in v5.10 and the
function is always compiled.

**Patch:** `fix-0001-init-remove-orphan-endif.patch`
**Status:** Fixed

---

## Issue 2: `arch/ia64/mm/tlb.c:249` — unused function warning

**Warning:**
```
arch/ia64/mm/tlb.c:249:1: warning: 'ia64_global_tlb_purge' defined but
not used [-Wunused-function]
```

**Cause:** The SN2 patch adds an `#ifdef CONFIG_IA64_SGI_SN2` block at
the only call site (line 336) that redirects to `sn2_global_tlb_purge()`
instead.  Since `ia64_global_tlb_purge()` is `static` and its only
caller is bypassed when SN2 is configured, the compiler warns it's unused.

**Fix:** Wrap the function definition with `#ifndef CONFIG_IA64_SGI_SN2`
so it is not compiled when SN2 is configured.  The function body is
entirely inside the existing `#ifdef CONFIG_SMP` block.

**Patch:** `fix-0002-tlb-guard-unused-function.patch`
**Status:** Fixed

---

## Issue 3: `arch/ia64/sn/kernel/setup.c:326` — `struct efi` has no member `hcdp`

**Error:**
```
arch/ia64/sn/kernel/setup.c:326:16: error: 'struct efi' has no member named 'hcdp'
  326 |         if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
arch/ia64/sn/kernel/setup.c:329:24: error: 'struct efi' has no member named 'hcdp'
  329 |         pcdp = __va(efi.hcdp);
```

**Cause:** In v5.7, Ard Biesheuvel's EFI cleanup series (commit series
"efi: clean up contents of struct efi") moved HCDP and MPS table handling
from the generic `struct efi` into ia64-local code.  The `hcdp` member was
removed from `struct efi` and replaced with `unsigned long hcdp_phys` in
`arch/ia64/kernel/efi.c`.

**Fix:** In `sn_scan_pcdp()`, replace:
- `extern struct efi efi;` → `extern unsigned long hcdp_phys;`
- `efi.hcdp` → `hcdp_phys` (two occurrences)

**Patch:** `fix-0003-setup-hcdp-phys.patch`
**Status:** Fixed

---

## Issue 4: `arch/ia64/sn/kernel/tiocx.c:378` — `uninitialized_var()` macro removed

**Error:**
```
arch/ia64/sn/kernel/tiocx.c:375:9: warning: parameter names (without types)
  in function declaration
arch/ia64/sn/kernel/tiocx.c:378:49: error: 'ioboard_type' undeclared
```

**Also affects:** `arch/ia64/sn/pci/pcibr/pcibr_provider.c:85` (same pattern)

**Cause:** The `uninitialized_var()` macro was removed in v5.10 (commit
3f649ab728cd).  It previously expanded to `(x = x)` to suppress GCC
"may be used uninitialized" warnings.  Without the macro, the declaration
fails entirely — the compiler sees it as a function declaration rather
than a variable declaration, so the variable is never defined.

**Fix:** Replace `u16 uninitialized_var(x)` with plain `u16 x` in both
files.  The variables are always set by `ia64_sn_sysctl_ioboard_get()`
before use; the original warning suppression was unnecessary.

**Patch:** `fix-0004-uninitialized-var-and-pci-bus-fwd-decl.patch`
**Status:** Fixed

---

## Issue 5: `pcibr_provider.h:149` — `struct pci_bus` declared inside parameter list (warning)

**Warning:**
```
./arch/ia64/include/asm/sn/pcibr_provider.h:149:41: warning: 'struct pci_bus'
  declared inside parameter list will not be visible outside of this definition
  or declaration
```

**Cause:** `pcibr_provider.h` uses `struct pci_bus *` in the prototype for
`sn_ioboard_to_pci_bus()` but neither includes `<linux/pci.h>` nor provides
a forward declaration.  The compiler treats `struct pci_bus` as a new,
locally-scoped type — which means callers that do include `<linux/pci.h>`
would see a type mismatch.

**Fix:** Add `struct pci_bus;` forward declaration after the includes.

**Patch:** `fix-0004-uninitialized-var-and-pci-bus-fwd-decl.patch` (combined)
**Status:** Fixed

---

## Issue 6: `drivers/tty/serial/ioc3_serial.c:20` — `linux/ioc3.h: No such file or directory`

**Error:**
```
drivers/tty/serial/ioc3_serial.c:20:10: fatal error: linux/ioc3.h:
  No such file or directory
```

**Also affects:** `drivers/sn/ioc3.c` (same include)

**Cause:** The IOC3 submodule driver infrastructure header
(`include/linux/ioc3.h`) existed in mainline through v5.5 but was removed
when the MIPS IOC3 driver was completely rewritten by Thomas Bogendoerfer
(the old submodule-based architecture was replaced with a platform driver).
Since the header was already present in v5.5, the SN2 v5.5 patch never
needed to add it.

The SN2 IOC3 master driver (`drivers/sn/ioc3.c`) and the IOC3 serial port
driver (`drivers/tty/serial/ioc3_serial.c`) both depend on this header
for `struct ioc3_driver_data`, `struct ioc3_submodule`, and the
`ioc3_register_submodule()`/`ioc3_enable()`/`ioc3_disable()`/`ioc3_ack()`
APIs.

**Fix:** Re-add `include/linux/ioc3.h` from the last mainline version
(v5.5).  The header defines the IOC3 submodule infrastructure that the
SN2 IOC3 drivers require.

**Patch:** `fix-0005-add-linux-ioc3-header.patch`
**Status:** Fixed

---

## Issue 7: `drivers/char/snsc_event.c:29` — `DECLARE_TASKLET` passed 3 arguments

**Error:**
```
drivers/char/snsc_event.c:29:48: error: macro "DECLARE_TASKLET" passed 3
  arguments, but takes just 2
   29 | DECLARE_TASKLET(sn_sysctl_event, scdrv_event, 0);
```

**Cause:** In v5.10 (commit 12cc923f1ccc), the tasklet API was updated.
`DECLARE_TASKLET` changed from 3 arguments `(name, func, data)` to
2 arguments `(name, callback)`, and the callback signature changed from
`void (*func)(unsigned long)` to `void (*func)(struct tasklet_struct *)`.

**Fix:** Three changes in `snsc_event.c`:
- Forward declaration: `void scdrv_event(unsigned long)` →
  `void scdrv_event(struct tasklet_struct *)`
- Macro call: `DECLARE_TASKLET(sn_sysctl_event, scdrv_event, 0)` →
  `DECLARE_TASKLET(sn_sysctl_event, scdrv_event)`
- Function definition: `void scdrv_event(unsigned long dummy)` →
  `void scdrv_event(struct tasklet_struct *unused)`

The `data` argument was already unused (passed as 0, received as `dummy`).

**Patch:** `fix-0006-tasklet-api-update.patch`
**Status:** Fixed
