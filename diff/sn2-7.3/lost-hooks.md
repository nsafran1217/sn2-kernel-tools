# SN2 hooks lost in the 5.4 machvec removal

Found 2026-10-16 while reviewing the machvec series. These bugs are in the
**SN2 layer** (`v7.3-rc3-epic1-sn2`, and every SN2 port since 5.4), not the
machvec work.

Until 5.4, generic ia64 code reached the platform through `platform_*()`
machvec hooks. On SN2 those were the `sn_*` functions listed in 4.19's
`asm/machvec_sn2.h`. Upstream deleted the machvec framework and then SN2
(`cf07cb1ff4ea`). The SN2 restore (`4026282cf505 "Apply sn2 patch"`) brought
back the `sn_*` functions and re-added most of the call sites as
`#ifdef CONFIG_IA64_SGI_SN2` blocks. It missed three of them, so those
functions are compiled but never called. Two are fixed below. The third
(legacy PCI) is left unhooked on purpose; see section 3.

The audit went through every hook in 4.19's `machvec_sn2.h` and every
non-SN2 hunk of `cf07cb1ff4ea`, and checked each one for a caller in
`v7.3-rc3-epic1-sn2`.

## Patches

Merged into `master-epic-sn2` (2026-10-16) as `e13906a6780a` and
`9d2082de92b7`, after rebasing that branch onto linux-ia64 `master-epic`
(`67a35586068b`, the strace/ptrace fix). `master-epic-sn2-gpu` is rebased on
top. `lost-hooks/` has the same two commits as `git format-patch` output,
made against `v7.3-rc3-epic1-sn2`:

| Patch | Fixes |
|--|--|
| `0001-sn2-call-sn_timer_interrupt-from-the-timer-tick-agai.patch` | lost-interrupt workaround, heartbeat LED, SHub 1.1 workaround |
| `0002-sn2-drain-the-old-CPU-s-PIO-writes-when-a-task-migra.patch` | PIO write ordering when a task migrates |

- Each patch applies cleanly to both `v7.3-rc3-epic1-sn2` and
  `v7.3-rc3-epic1-sn2-gpu`.
- Built with gcc 16.2 and `configs/7.3-epic-sn2-gpu.config` (the
  `SN2_PLX_GPU` option drops out on olddefconfig, as usual for the SN2
  layer). vmlinux links. The changed files add no warnings.
- `objdump -r` shows the new calls: `time.o` calls
  `sn_timer_interrupt`, and `core.o` calls `sn_migrate` (through
  `switch_to()`).
- **Boot-tested on pople** (2026-10-16, 2 CPUs, SHub 1.2), on the SN2 layer
  without the GPU layer. The test kernel had a debug-only commit that
  counted calls per hook in debugfs; that commit is not kept. Results are in
  sections 1 and 2. Not yet tested on top of the GPU layer.

The style follows the SN2 layer: `#ifdef CONFIG_IA64_SGI_SN2` with a local
`extern`, as in `pcibios_fixup_bus()`.

## 1. `sn_timer_interrupt()` is never called (important)

**4.19:** `timer_interrupt()` → `platform_timer_interrupt(irq, dev_id)` →
`sn_timer_interrupt()` (`arch/ia64/kernel/time.c:169`), on every tick, on
every CPU.

**Now:** `arch/ia64/sn/kernel/sn2/timer_interrupt.c` is built, but nothing
calls the function. Three things depend on it:

- **`sn_lb_int_war_check()`, the lost-interrupt workaround for SHub1.** It
  runs every 100 ticks per CPU, and only when `is_shub1()`. **SHub 1.2
  counts, so this applies to pople.** For each IRQ the CPU owns
  (`pda->sn_first_irq`..`sn_last_irq`), it reads the PIC's
  `INT_STATUS` register. Suppose the PIC says it sent an interrupt, and the
  same was true at the previous check. If the CPU has it neither pending
  (IRR) nor in service (`pda->sn_in_service_ivecs`), the interrupt was
  lost, and the workaround re-raises it through the provider's
  `force_interrupt`. Without the workaround, a lost interrupt stays lost:
  the device waits until its driver's timeout, or for ever. Symptoms to
  look for are SCSI command timeouts and aborts, NIC TX watchdog resets, a
  GPU fence timeout or ring stall, or a device that stops interrupting
  until the next reboot. It covers PIC-attached devices only; TIO bridges
  return early.
- **The SHub 1.1 PIO workaround write** (`pio_shub_war_cam_addr`). It
  only runs on SHub 1.1 (`enable_shub_wars_1_1()`), so it doesn't affect
  SHub 1.2.
- **The heartbeat LED** (`LED_CPU_HEARTBEAT` toggles every HZ/2). The
  activity LED does work: `ia64_mark_idle = snidle` is still set and
  `arch_cpu_idle()` still calls it.

**Fix (0001):** call `sn_timer_interrupt(irq, dev_id)` after
`timer_interrupt()`'s offline check, in the same place as 4.19.

**Tested:** over 60 s idle, `sn_timer_interrupt()` ran 36,018 times
(300 Hz × 2 CPUs) and `sn_lb_int_war_check()` ran 360 times (every 100
ticks per CPU). During 90 s of NFS reads (tg3 on the PIC), the workaround
re-raised 2 interrupts. That is either 2 lost interrupts or 2 that were in
flight; the code comment says it can't tell the two apart. No new dmesg
errors or warnings. Not checked yet: whether the heartbeat LEDs blink.

## 2. `sn_migrate()` is never called (PIO ordering)

**4.19:** `switch_to()` (`asm/switch_to.h`) called
`platform_migrate(current)` = `sn_migrate()` when the task had
`IA64_THREAD_MIGRATION` and `task_cpu(current) != last_cpu`. `sn_setup()`
sets that flag on the boot task, and every task inherits it.
`sn_migrate()` spins until the **previous** CPU's SHub has no pending PIO
writes.

**Why:** SN2 doesn't order PIO writes from different CPUs. A thread that
writes to MMIO, migrates, and writes again can have its second write reach
the device before its first. Inside the kernel, the `mmiowb()` in
`spin_unlock()` covers writes made under a lock. Nothing covers
user-space MMIO (DRM BOs in VRAM, mmapped BARs, mspec, user-space drivers)
or a kernel thread preempted between two writes.

**Now:** upstream deleted the call but kept the `IA64_THREAD_MIGRATION`
test and the `last_cpu` update in `switch_to()`. The SN2 layer still sets
the flag. So the check still runs on every context switch, and the drain
never does.

**Fix (0002):** `ia64_platform_migrate(current)` in `switch_to()`, defined
as `sn_migrate()` with `CONFIG_IA64_SGI_SN2` and as empty otherwise. A
non-SN2 kernel never sets the flag, so the block is dead there anyway.

**Tested:** by the end of the test (boot, hackbench, 90 s of NFS reads),
`sn_migrate()` had run 11,557 times. In 1,962 of them (17%), the old CPU's
SHub still had PIO writes pending when the task arrived on its new CPU. So
the drain does real work: without it, those writes were not ordered
against the task's next writes.

## 3. Legacy PCI I/O and memory: known, deliberately not restored

**4.19:** `pci_get_legacy_mem()`, `pci_legacy_read()` and
`pci_legacy_write()` were machvec hooks, and SN2 supplied
`sn_pci_get_legacy_mem()`, `sn_pci_legacy_read()` and
`sn_pci_legacy_write()` (`arch/ia64/sn/pci/pci_dma.c`).

**Now:** the generic versions in `arch/ia64/pci/pci.c` run, and the SN2
routines are unused (hence their `-Wmissing-prototypes` warnings). The
generic versions are wrong for SN2. On pople, reading VGA port 0x3cc
through `/sys/class/pci_bus/0001:00/legacy_io` returns `0x67`, but bus
`0001:00` has no VGA device; the value almost certainly comes from the
Radeon on `0002:01`.

**Why it stays that way:** the only callers are the sysfs
`/sys/class/pci_bus/*/legacy_io` and `legacy_mem` handlers
(`drivers/pci/pci-sysfs.c`). Nothing in the kernel uses them: not
amdgpu, radeon, vgaarb or the console. Only user space does, mainly Xorg's
libpciaccess for legacy VGA (the `vesa` driver's int10/VBE path), which
isn't needed with a KMS driver. On the test boots, the counters for these
routines stayed at 0 until the test opened the files itself.

Restoring the SN2 routines was tried (an earlier patch 0003, now dropped)
and made things worse:

| Kernel | Read of 0x3cc on `0001:00` (no VGA device) |
|--|--|
| 7.3 SN2 layer, generic routines | returns `0x67` instantly (misrouted) |
| 7.3 SN2 layer + SN2 routines | about 20 s stall, then `MCA: External bus check fatal status` and an automatic reset |
| 4.19 (SGI's routines, `init=` script) | corrected platform error (CPE, vector 0x1e), returns `0xff` |

On 4.19 the CPE vector hit `handle_bad_irq`, so the CPE handler never ran.
7.3 has a working CPE handler (`cpe_hndlr`, IRQ 30), which may be what
turns the abort into a fatal MCA, but that wasn't investigated. The errdmp
was taken after the automatic reset, so it holds nothing from the MCA. If
legacy PCI is ever needed, start there. A safer alternative would be not
to create the legacy files on SN2 at all.

## Checked and fine

| 4.19 hook / removed hunk | 7.3 SN2 layer |
|--|--|
| `sn_setup`, `sn_cpu_init`, `sn_irq_init` | called from `setup.c` / `irq_ia64.c` |
| `sn2_send_IPI`, `sn2_global_tlb_purge` | `sn2_smp.c` strong `ia64_send_ipi`, `mm/tlb.c` |
| `sn_irq_to_vector`, `sn_local_vector_to_irq` | identity, inlined in `asm/hw_irq.h` |
| `__sn_in*/out*/read*/mmiowb` | `asm/io.h`, `asm/mmiowb.h` |
| `sn_setup_msi_irq`, `sn_teardown_msi_irq` | `msi_ia64.c` |
| `sn_pci_fixup_bus` | `pci/pci.c` |
| `sn_dma_init` (`dma_ops = &sn_dma_ops`) | replaced by per-device `sn_dma_set_ops()` (7.2+) |
| `sn_dma_get_required_mask` | in `sn_dma_ops.get_required_mask` |
| `sal.c` SAL 2.9 → 3.2 fixup | restored |
| `acpi.c` SRAT proximity and IOSAPIC message | restored |
| `smpboot.c` `sn_cpu_disable_allowed()` | restored |
| `uncached.c` `sn_flush_all_caches()` | restored |
| `setup.c` crashkernel above 4 GB | restored |

## Lost, but not worth restoring now

- **`sn_tlb_migrate_finish()`** (flushed a single-user mm's TLB after a
  migration). The scheduler's `tlb_migrate_finish()` hook no longer exists
  upstream. As far as I can tell it was an optimization:
  `sn2_global_tlb_purge()` still handles an mm whose CPU mask holds more
  than one CPU, by IPI/ptc.ga or by `flush_tlb_mm()` giving it a new
  context.
- **`is_affinity_mask_valid()`** (rejected multi-CPU `smp_affinity` masks on
  SN2). The generic hook was removed from `kernel/irq`.
  `sn_set_affinity_irq()` takes the first online CPU in the mask, so a
  multi-CPU mask is accepted and quietly reduced to one CPU.
- **`sn_kernel_launch_event()`** (tells the PROM before kexec). The SN2
  configs have `CONFIG_KEXEC` off. Restore it in `machine_kexec()` if kexec
  is ever turned on.

## Carrying these into the machvec series

Done on 2026-10-16: `sn2-machvec-7.3` is rebased onto `master-epic-sn2`
(`9d2082de92b7`).

- `time.c` now has a runtime test, folded into "sn2: test the platform at
  run time in the arch init hooks" (`bb842f2924b3`). Without it,
  `sn_timer_interrupt()` would write through a NULL `pda->led_address` on HP:
  `if (ia64_is_sn2()) sn_timer_interrupt(irq, dev_id);`
- 0002 stays `#ifdef`. `IA64_THREAD_MIGRATION` is only set by `sn_setup()`,
  so on HP the existing flag test already skips it.
