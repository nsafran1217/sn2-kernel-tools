# SN2 v6.16 — Build Issues

Tracking file for build issues found after applying `sn2-v6.16-complete.patch`.
Each fix gets an individual patch (0001, 0002, ...) which will be combined
into the final complete patch at the end.

---

## 0001 — `arch/ia64/Kconfig`: NUMA vs FLATMEM dependency conflict

**Symptom:**
```
WARNING: unmet direct dependencies detected for NUMA
  Depends on [n]: !FLATMEM [=y]
  Selected by [y]:
  - IA64_SGI_SN2 [=y]
```

**Cause:** `IA64_SGI_SN2` does `select NUMA`, but `NUMA` has
`depends on !FLATMEM`.  Kconfig `select` overrides `depends on`,
so when FLATMEM=y the select forces NUMA=y despite the dependency,
producing the warning.

**Fix:** Add `depends on !FLATMEM` to the `IA64_SGI_SN2` config
block.  SN2 (Altix) is inherently a NUMA machine — FLATMEM makes
no sense for it.  This hides the SN2 option when FLATMEM is selected.

**Patch:** `0001-kconfig-sn2-depends-flatmem.patch`

---

## 0002 — `arch/ia64/sn/kernel/bte_error.c`: del_timer rename + missing prototype

**Symptom:**
```
bte_error.c:123:9: error: implicit declaration of function 'del_timer'
bte_error.c:235:1: warning: no previous prototype for 'bte_crb_error_handler'
```

**Cause:** `del_timer()` was renamed to `timer_delete()` in 6.12.
Also, `bte_crb_error_handler()` is called from `huberror.c` via
its own extern but had no prototype visible in `bte_error.c`.

**Fix:**
- Add `#include <linux/timer.h>`
- Replace `del_timer()` → `timer_delete()` (2 call sites)
- Add forward declaration for `bte_crb_error_handler()`

**Patch:** `0002-bte_error-timer-delete-prototype.patch`

---

## 0003 — `bte.c` + `msi_sn.c`: from_timer rename + missing prototypes

**Symptom:**
```
bte.c:419:37: error: implicit declaration of function 'from_timer'
bte.c:430:6: warning: no previous prototype for 'bte_init_node'
msi_sn.c:31:6: warning: no previous prototype for 'sn_teardown_msi_irq'
msi_sn.c:66:5: warning: no previous prototype for 'sn_setup_msi_irq'
```

**Cause:**
- `from_timer()` was renamed to `timer_container_of()` in 6.12
- `bte_init_node()` called from `setup.c`, `sn_setup_msi_irq()` and
  `sn_teardown_msi_irq()` called from `msi_ia64.c` — all via their
  own externs but no prototype visible at the definition site.

**Fix:**
- `bte.c`: `from_timer()` → `timer_container_of()`
- `bte.c`: add forward declaration for `bte_init_node()`
- `msi_sn.c`: add forward declarations for both MSI functions

**Patch:** `0003-bte-msi-timer-prototypes.patch`

---

## 0004 — `arch/ia64/sn/kernel/tiocx.c`: const device_driver in bus match

**Symptom:**
```
tiocx.c:146:18: error: initialization of 'int (*)(struct device *,
  const struct device_driver *)' from incompatible pointer type
  'int (*)(struct device *, struct device_driver *)'
```

**Cause:** The `bus_type.match` callback was constified — it now
takes `const struct device_driver *` instead of `struct device_driver *`.

**Fix:** Add `const` to the `drv` parameter in `tiocx_match()` and
propagate to the local `cx_drv` pointer derived via `container_of`.
No other SN2 files define bus_type `.match` callbacks.

**Patch:** `0004-tiocx-const-device-driver.patch`

---

## 0005 — `drivers/tty/serial/sn_console.c`: from_timer rename + missing prototype

**Symptom:**
```
sn_console.c:611:37: error: implicit declaration of function 'from_timer'
sn_console.c:1005:12: warning: no previous prototype for 'sn_serial_console_early_setup'
```

**Cause:** Same `from_timer()` → `timer_container_of()` rename as
0003.  Also `sn_serial_console_early_setup()` is called from
`arch/ia64/kernel/setup.c` via block-scoped extern but had no
prototype visible in `sn_console.c`.

**Fix:**
- `from_timer()` → `timer_container_of()` in `sn_sal_timer_poll()`
- Add forward declaration for `sn_serial_console_early_setup()`

**Patch:** `0005-sn_console-timer-prototype.patch`

---

## 0006 — `drivers/char/snsc_event.c`: unaligned.h header path

**Symptom:**
```
snsc_event.c:23:10: fatal error: asm/unaligned.h: No such file or directory
```

**Cause:** `asm/unaligned.h` was moved to `linux/unaligned.h` in
6.12 (commit 2882b7626f49).  In earlier kernels (5.15–6.6) the old
path still existed or was pulled in transitively, so this never
surfaced.

**Fix:** `#include <asm/unaligned.h>` → `#include <linux/unaligned.h>`.
Only `snsc_event.c` is affected among SN2 files.

**Patch:** `0006-snsc_event-unaligned-header.patch`

---

## 0007 — `arch/ia64/kernel/mca.c`: ia64_mca_register_cpev must be non-static

**Symptom:**
```
ia64-linux-ld: irq.c: undefined reference to `ia64_mca_register_cpev'
```

**Cause:** SN2's `irq.c` calls `ia64_mca_register_cpev()` to
register/deregister the corrected platform error vector when IRQs
are enabled/disabled.  In the base ia64 re-addition for 6.16 this
function was made `static` since there were no external callers
without SN2.

**Fix:** Remove `static` from `ia64_mca_register_cpev()` in
`arch/ia64/kernel/mca.c`.  This is a base ia64 file, not an SN2
file — the function existed as non-static in the original ia64 tree.

**Patch:** `0007-mca-register-cpev-non-static.patch`

---

## 0008 — `asm/mca.h` + `arch/ia64/kernel/setup.c`: prototype + unused function

**Symptom:**
```
mca.c:611:1: warning: no previous prototype for 'ia64_mca_register_cpev'
setup.c:511:1: warning: 'screen_info_setup' defined but not used
```

**Cause:**
- `ia64_mca_register_cpev` was made non-static in 0007 but no
  visible prototype was added — the extern in SN2's `irq.c` is
  block-scoped and not visible at the definition site.
- `screen_info_setup()` is never called when `CONFIG_IA64_SGI_SN2`
  is enabled (SN2 disables VGA and calls `sn_setup()` instead).

**Fix:**
- Add `extern void ia64_mca_register_cpev(int)` to `asm/mca.h`
  alongside other `ia64_mca_*` prototypes.
- Wrap `screen_info_setup()` definition with
  `#ifndef CONFIG_IA64_SGI_SN2`.

**Note:** The remaining ~40 `-Wmissing-prototypes` warnings in the
build output are cosmetic — pre-existing SN2 code that uses
block-scoped externs and function pointers rather than header
prototypes. They don't affect correctness.

**Patch:** `0008-mca-prototype-screen-info-guard.patch`

---

## 0009 — `arch/ia64/kernel/crash.c`: sysctl table sentinel causes runtime warning

**Symptom (runtime):**
```
sysctl table check failed: kernel/(null) procname is null
sysctl table check failed: kernel/(null) No proc_handler
```

**Cause:** `kdump_ctl_table[]` has a trailing `{ }` sentinel entry.
In 6.16, `register_sysctl("kernel", table)` is a macro expanding to
`register_sysctl_sz("kernel", table, ARRAY_SIZE(table))`.
`ARRAY_SIZE` counts the sentinel as entry #3.  The sysctl validator
iterates all 3 entries, finds the sentinel's null `.procname`, and
prints the warning.

Modern ctl_table arrays in 6.16 no longer use the empty sentinel —
the `_sz` variant carries the explicit count.

**Fix:** Remove the `{ }` sentinel from `kdump_ctl_table[]`.

**Note:** This is a base ia64 file, not SN2-specific.

**Patch:** `0009-crash-sysctl-remove-sentinel.patch`

---

## 0010 — DEBUG: exec + binfmt_elf + mmap instrumentation

Temporary debug patch (not for production).  Instruments fs/exec.c,
fs/binfmt_elf.c, mm/mmap.c, and mm/vma_exec.c with pr_err() at
every failure path in the exec→load_elf_binary→mmap chain.  Used
to trace the ENOMEM/EINVAL boot failure across 5 rounds of
debugging.

**Patch:** `0010-exec-debug-enomem.patch`

---

## 0011 — `arch/ia64/kernel/sys_ia64.c`: zero-initialize vm_unmapped_area_info

**ROOT CAUSE of exec boot failure.**

**Symptom:**
```
offset_in_page addr=200000000000013e PAGE_SIZE=10000
__get_unmapped_area failed addr=ffffffffffffffea
```
Every dynamically-linked executable fails to load its interpreter
(ld.so) — `vm_mmap()` returns -EINVAL.

**Cause:** In 6.16, `struct vm_unmapped_area_info` gained a
`start_gap` field (commit 7c9712703a7c).  ia64's
`arch_get_unmapped_area()` declares the struct on the stack
without zero-initialization, leaving `start_gap` containing
stack garbage.  `vm_unmapped_area()` uses `start_gap` to offset
the returned address, producing a non-page-aligned result.
`__get_unmapped_area()` then hits the `offset_in_page(addr)` check
and returns -EINVAL.

The generic `arch_get_unmapped_area()` in `mm/mmap.c` uses `= {}`
for zero-initialization.  ia64's version predates this convention.

**Fix:** `struct vm_unmapped_area_info info;` →
`struct vm_unmapped_area_info info = {};`

**Note:** This is a base ia64 bug, not SN2-specific.

**Patch:** `0011-sys_ia64-zero-init-unmapped-area-info.patch`

---

## 0012 — `arch/ia64/sn/kernel/setup.c`: module notifier to suppress VM_FLUSH_RESET_PERMS

**Problem:** The `module_alloc()`/`module_memfree()` overrides that
suppressed `VM_FLUSH_RESET_PERMS` were removed because the execmem
subsystem (6.12+) replaced those hooks.  Without them, module load/
unload triggers SHUB PTC.GA TLB broadcasts that can interfere with
concurrent PIO/MMIO traffic.

**Solution:** Register a module notifier in `sn_setup()` that clears
`VM_FLUSH_RESET_PERMS` from all module memory regions at:
- `MODULE_STATE_LIVE` — before init sections are freed
- `MODULE_STATE_GOING` — before core sections are freed during unload

This is functionally equivalent to the old `module_memfree()` override
which cleared the flag just before `vfree()`.

On ia64, `set_memory_nx`/`rw`/`rox` and `set_direct_map` are all
no-ops, so `vm_reset_perms()` provides no real benefit — the flag
is purely harmful on SN2.

**Patch:** `0012-sn2-module-notifier-flush-perms.patch`

---

## 0013 — `arch/ia64/include/asm/io.h`: cast ins*/outs* data pointers through void*

The SN2 `insw`/`outsw`/`insl`/`outsl` macros cast the data pointer
directly to typed pointers (`unsigned short *`, etc).  Drivers that
pass `unsigned char *` buffers (e.g. `fdomain.c`) fail with
`-Wincompatible-pointer-types`.

Fix: cast through `(void *)`/`(const void *)` to accept any pointer
type, matching other architectures' implementations.

Base ia64 bug, not SN2-specific.

**Patch:** `0013-io-h-insw-outsw-void-pointer-cast.patch`
