# SGI Prism AGP bring-up

Progress and notes for getting AGP working on a Prism. The box belongs to someone
else and is remote from the build workstation.

Modern Linux has never booted on a Prism or on TIOCA. The owner has a disk image of pople's
T2 install, which has not booted on that box yet. SLES9 is the fallback. Nathan runs the box,
with console and power control, and pastes results back.

[BRINGUP-PLAN.md](BRINGUP-PLAN.md) has the stages and their gates. The notes in `fglrx/` and
the older ones in `../radeon/fglrx/` and `../docs/` are unverified, apart from the `lspci`
output from a Prism, which an owner ran.

## Setup

- Tree: `src/mainline/linux-sn2-prism`, a worktree on branch `sn2-prism`, branched from
  `master-epic-sn2-gpu` at `0e787cc6dd9d`. All work and builds happen there.
- `firmware/qlogic/12160.bin` is gitignored, so it was copied into the worktree by hand.
  `CONFIG_EXTRA_FIRMWARE` needs it.
- Config: `../configs/7.3-epic-sn2-prism.config`.

| Branch | Worktree | Contents |
| --- | --- | --- |
| `sn2-prism` | `linux-sn2-prism` | Base plus the MC base and `sgi-agp` fixes. Not run. Covers Stages 3 to 5, because the `sgi-agp` fixes only run once that module is loaded |
| `sn2-prism-fallback` | `linux-sn2-prism-fallback` | Base plus the debug `sn2_no_tioca` argument |

The tarball at the top of the share is the base commit, which is what Stage 1 tests. Don't
run a plain `prism-build.sh` before Stage 1 passes: it would put `sn2-prism`'s tip on the
share as the newest tarball, and `prism-install.sh` would install that instead.

## Build and install

On the workstation:

```bash
sn2-kernel-tools/prism-build.sh
```

This builds the worktree and puts `linux-<release>.tar.gz`, `prism_probe-<release>.ko`,
`prism-install.sh`, `prism-capture.sh` and the radeon CP firmware in
`/mnt/nfs/altix/prismkerns/`. Nothing goes to the netboot server or to `release/`.
`prism-build.sh --scripts` refreshes only the scripts and firmware.

`prism-build-fallbacks.sh` builds the `notioca`, `novga` and `notiocx` kernels into
`fallback/` on the share. `prism-install.sh` doesn't look there unless told to.

On the Prism, as root:

```bash
prism-install.sh
```

This fetches the newest tarball from the VPN host's `/nfs/altix/prismkerns` into
`/root/prismkerns`, installs the kernel, modules, `prism_probe` and any missing radeon
firmware, adds a grub entry and makes it the default. It does not reboot.

A preflight runs first. It stops if the root filesystem isn't built in to the new kernel,
and warns if a driver in use has no counterpart there, or if `/` isn't `ROOTDEV`. That last
one is only a warning, because disk names change between kernels: pople's stock kernel has
its root as `sdb2`, and the no-initrd kernel has it as `sda2`.

| Variable | Default | Use |
| --- | --- | --- |
| `ROOTDEV` | `/dev/sda2` | `root=` for the entry |
| `TEST_ARGS` | `panic=0 modprobe.blacklist=amdgpu,radeon` | Replaces any `panic=`, `modprobe.blacklist=` and `radeon.*` from the running command line |
| `REMOTE_DIR` | `/nfs/altix/prismkerns` | `.../fallback` for a fallback kernel |
| `PICK` | Empty | Only tarballs with this in their name, such as `novga` |
| `REMOTE` | From `prism/remote` | The VPN host |

A rerun for the same release rewrites its entry. `/boot/grub/grub.cfg` is backed up each time.

The VPN host stays out of this repo. `prism/remote` is gitignored and holds its `user@host`,
and `prism-build.sh` writes that into the copy of `prism-install.sh` on the share. Set
`REMOTE=user@host` on the Prism to override it.

## Capture and probe

`prism-capture.sh [label]` runs on T2 or SLES9 and writes one read-only report to
`/root/prism-captures/`. Keep copies in `prism/logs/`, which is gitignored because this repo
is public and the reports hold the owner's network details. The report is synced after each
section, so if the box dies, the last header names what killed it.

`prism_probe` reads the CA and the card without `radeon`. Use one step at a time, in this
order, with `rmmod prism_probe` in between:

```bash
modprobe prism_probe                 # config space and software state only
modprobe prism_probe ca_regs=1
modprobe prism_probe gpu_regs=1      # add enable_mem=1 if it says Memory Space is off
modprobe prism_probe io_regs=1
modprobe prism_probe rom_test=1
modprobe prism_probe rom_off=1       # may raise a CA error, which is the point
modprobe prism_probe rom_dump=1      # then copy /sys/kernel/debug/prism_probe/rom
```

Don't load it before the capture from that boot is safely copied off.

## Console logging

If the Prism's L2 is reachable from the workstation, point the `altix` tool at it. Use a
separate log directory so nothing lands in pople's logs:

```bash
export ALTIX_L2_HOST=<prism L2> ALTIX_L2_PORT=23 ALTIX_IST_L2=<prism L2> \
       ALTIX_LOG_DIR=~/projects/altix_cross/logs/prism
altix console start
```

Check `ALTIX_BRICK` before using `altix mmr`, because it defaults to pople's brick. Don't use
`altix boot`, because it's built around pople's ssh target. If the L2 isn't reachable, keep a
`script` log of the console session.

When reading errdmp output, read the dump itself and don't rely on `errdmp-summary` alone.
Its noise filter hides `SH_NI0/NI1_LLP_*` because pople has no NUMAlink cable. A Prism may
reach its TIO over NUMAlink, so those flags could be the real fault there.

## Boot

No initrd, to save test-cycle time. Grub entries use `root=/dev/sda2`, because without an
initrd the kernel can't resolve `/dev/disk/by-uuid/`. The rest of the command line is
copied from the running kernel. The stock entry and its `/boot/vmlinuz` symlinks are left
alone as the way back.

## Config

Made from the full `7.3-epic-sn2-gpu` config by dropping `=m` down to a keep list, so all
of its `=y` options carry over unless they depended on a dropped module. `LOCALVERSION` is
`-SN2-PRISM`, which keeps its release names apart from pople's.

| | Full config | Prism config |
| --- | --- | --- |
| Modules built | 5364 | 90 |
| Module size | 364.7 MB | 17.7 MB |
| Tarball | 136.7 MB | 31.2 MB |

`amdgpu` is left out because the work is on `radeon`. The last rebuild, after the config
change that removed it, took 3m16s on the 8-core workstation.

- Built in: ext4, `sd`, `qla1280` (IO9 disk), `sata_vsc` (IO10 disk), `pata_sgiioc4`, `tg3`,
  and the Altix drivers (IOC4, `snsc`, `tiocx`, `mbcs`, L1 and IOC4 serial).
- Modules: `agpgart`, `sgi-agp`, DRM with `radeon`, `mspec`, USB, HID, sound, `qla2xxx`,
  vfat (needed for the `/boot/efi` line in fstab), plus the small set pople loads.
- `TUN` and `WIREGUARD` stay as modules because how the Prism reaches the VPN host is
  unknown.

## Status

- [x] `prism-install.sh` tested on pople with `REMOTE=nathan@nfs`
- [x] No-initrd kernel boots on pople, through grub to a login
- [ ] Confirm `/nfs/altix/prismkerns` on the VPN host; port 22 timed out from the workstation
- [ ] Stage 0: firmware details captured, disk seen from the EFI shell
- [x] Stage 1: `sn2-prism` (`e85b45c55b4d`) boots on the Prism
- [x] Confirm the Prism's root disk, which IO brick it has, and that the card is the X3: `sda` on `0001:00:03.0`, two OPbricks, two X3-256 cards
- [ ] `prism-install.sh` run on the Prism through the VPN host
- [x] First boot of the no-initrd kernel on the Prism
- [ ] Stage 2: hardware read with `prism_probe`, ATOM image available (ATOM works, probe not run)
- [ ] Stage 3: PCI mode, ring and IB tests pass (both pass, but `Fatal TIO Error` on the run with a monitor, interrupt counts still to check)
- [ ] Stage 4: `sgi-agp` loads
- [ ] Stage 5: AGP working
- [ ] Stage 6: display and userspace
- [ ] Stage 7: tuning, and merged into the `-sn2` and `-gpu` layers

## Log

### 2026-10-30

Set up the worktree, the config and the build and install scripts. Dropped `amdgpu` and
moved `mspec` to a module. The Prism build at `0e787cc6dd9d` is on the share as `linux-7.3.0-rc3-epic1-SN2-PRISM-0e787cc6dd9d-ia64.tar.gz`.
`System.map` confirms ext4, `qla1280`, `sata_vsc`, `tg3` and the 12160 firmware are built
in. No kernel has been installed or booted yet.

### 2026-10-31

`set default="$REL"` didn't select the new kernel. grub runs `grub_strtoul` on the value
first, so `7.3.0-...` parses as index 7 with no error, and an out-of-range index falls back
to entry 0. `prism-install.sh` now gives entries `--id "sn2-$REL"` and sets the default to
that id. Re-running it upgrades an existing entry that has no `--id`.

Tested the whole flow on pople, which has the same OS. Installed the timer-fixed grub as
`\EFI\boot\bootia64.efi`, with the old image kept beside it as `bootia64-old.efi`. Ran
`prism-install.sh` with `REMOTE=nathan@nfs`, which upgraded the old entry to `--id`. With the
firmware menu selected by hand, grub's 8 s countdown auto-booted the new default after about
11 s, and the kernel mounted `/dev/sda2` with no initrd and reached a login 16 s after it
started. No failed units.

`prism-install.sh` also sets `fallback=0` now. `fallback=1` pointed at the new entry itself
once it became the default. That line has not been run yet; pople's `grub.cfg` was edited by hand.

Corrected the status above: modern Linux has never booted on a Prism or on TIOCA, and the
disk image has not booted on the Prism yet.

Wrote [BRINGUP-PLAN.md](BRINGUP-PLAN.md) and did its workstation preparation. Nothing below
has run on a Prism or on pople.

- Added `prism-capture.sh` and `prism_probe`. The probe builds against the base kernel and
  its vermagic matches the tarball on the share. The capture script ran on the workstation
  only, without root.
- `prism-install.sh` gained a preflight, `ROOTDEV`, `TEST_ARGS`, `REMOTE_DIR`, and firmware
  and probe installs. Only the grub argument logic was tested, in a scratch directory
  against a fake `grub.cfg`. The whole script needs a real run. The preflight's driver names
  match the base tarball's `modules.builtin` and `modules.order`.
- Split patch 0001 into four commits on `sn2-prism`, and dropped its `tagp` references from
  code comments, because those findings are unverified. The tip (`05e62f518ca5`) builds with
  no warnings and is not on the share.
- Extracted the `sg*.bin` images and parsed them directly. `sg4.bin` is an ATOM image for
  `1002:4a4d`, the FireGL X3 in the owner's `lspci`, and is on the share in
  `firmware/vbios/`.
- `pci_iomap()` should return NULL for the I/O BAR on SN2, so `radeon`'s
  `Unable to find PCI I/O BAR` line is expected, and ATOM IIO uses MMIO. From source only.
  Wrong on this box, see 2026-11-01.

### 2026-11-01

First boot on the Prism: `e85b45c55b4d` with no initrd reached a login, and `prism-capture.sh`
finished with 0 errors. This is the first modern kernel on a Prism or a TIOCA, and the first
real run of the ACPI IO path (DSDT rev 0x20101).

- The box has 6 CPUs, 3 nodes, 60 GB, SAL 5.02, two OPbricks and a GAbrick with two TIO ASICs.
  It has two FireGL X3-256 cards, `0017:00:00.0` (boot VGA) and `001b:00:00.0`. BARs match the
  trusted `lspci`.
- Both `TIOCA error` and both `SN_TIO_error` IRQs registered, all at 0 counts. `tioca_bus_fixup()`,
  `tioca_gart_init()` and `ice_error_init()` ran without complaint.
- `modprobe radeon` with no options brought up both cards in PCI mode: `ATOM BIOS: RADEON`,
  256M VRAM, 512M GTT, microcode loaded, ring and IB tests pass, and no MCA or oops. The VBIOS
  came without `sg4.bin` and with no ROM patch.
- `Cannot find any crtc or sizes` on both cards. Connector status not captured, so this is
  either no monitor or failed detection.
- `ata10`, the second IOC4's DVD (`SR-8177`), loses every interrupt. It holds up boot for
  132 s and logs every 22 s after that. Cause unknown. `ata9`, on the first IOC4, works.
  `libata.force=10:disable` should remove the delay, not tested.

Captures are on the share: `capture-boot-7.3.0-epic1-SN2-PRISM-e85b45c55b4d-ia64-20261101-201538.txt`
and `modprobe-radeon.txt`.

Second `modprobe radeon`, with a monitor connected, panicked at 176.5 s, just after the ring and
IB tests on `0017`. The PROM printed `Coretalk write request bad byte enables`, which is
`WRC_CT_WR_REQ_BAD_BE` in `TIO_ICE_WRC_CT_ERROR_DETAIL_1/2`: `WRITE REQUEST`, source 0x2, partial
cacheline, TNUM 0x82, data enables 0, memory, address 0x801080. Then `Fatal ICE HW error`. The
last radeon line was the first connector name, so this came before HPD, EDID and any modeset.
Coretalk addresses are `nasid << 40 | node offset`, with the cached address-space bits dropped.
The PROM prints the `DETAIL_2` address field shifted right by 3, so the real address is 0x4008400,
phys `0x3004008400`, ordinary RAM on node 0. See the `dbg1` run below.

A later boot loaded `radeon` without a panic, and `prism_probe` then ran with it loaded.
- `io_regs`: `CONFIG_MEMSIZE` reads `10000000` on `001b` and `ffffffff` on `0017`, confirming
  that `sn_io_addr()` drops `0017`'s BAR1 at port 0x1000.
- `ca_regs`: no CA errors on either card. `CA_CORELET_ID` is 2, so source 0x2 in the panic was
  the CA. `AGP_ENABLE` stays set with `radeon` loaded in PCI mode. INTB is masked, so its
  uninitialized `intb_dest` is harmless. INTA interrupts target the TIO's own `TIO_INT1`.
- `arch/ia64/pci/pci.c`: uncommitted change in `sn2-prism`, `new_space()` no longer shares
  space 0 on SN2, so `0017` gets ports above 64K like `001b`. Not built or booted.

Controlled run at 281 s uptime, plain `modprobe radeon`, monitor on `0017`: no panic, and **the
monitor showed the fbcon login**, the first modern display output on a Prism. `DVI-I-1` is
connected. EDID failed its checksum with the same remainder (249) on both reads, so radeon fell
back to 1024x768.
- IRQ 66 counted once and stayed at 1. IRQ 67 stayed at 0, yet `001b` passed its IB test, so
  that test does not need an interrupt.
- `CA_INT_STATUS.INTA` was set on `0017` with the INTA pin idle, the same as the earlier boot.
  Nothing in the kernel clears it. Whether it blocks later interrupts is open.
- Before radeon, `CA_STATUS1.CA_GART_TLB_VAL` was 0, with no CA errors and `AGP_ENABLE` set. It
  read `ff` after radeon, so the CA TLB held no stale entries before the load.
- `intb_dest` is the same across boots, so it isn't random.
- Panics so far: 1 of 4 loads.

Reported, no logs yet: X starts on `radeon`, but `glxgears` crashes. One run gave GPU lockups, the
next an MCA.

`vblwait` on `0017`: 60 vblanks in 0.989 s, IRQ 66 went from 1 to 62. Interrupts work, and the
latched `CA_INT_STATUS.INTA` bit is harmless. Not tested on `001b`, which has no active CRTC.

Built `7.3.0-dbg1-epic1-SN2-PRISM-e85b45c55b4d-ia64` from uncommitted changes on `sn2-prism`, not
booted. The name comes from an untracked `localversion-dbg1`. It has the `new_space()` fix and
`tioca_dump_error_state()`, which prints CA error state and the TIO nasid before the Fatal TIO
panic. Next test is `modprobe radeon test=1`, which runs GPU blits through the CA without Mesa.

`dbg1` boot: `CONFIG_MEMSIZE` reads `10000000` on both cards, so the port fix works. `modprobe
radeon test=1` panicked after the second copy line with the same `WRC_CT_WR_REQ_BAD_BE`, on TIO
nasid 1 (`0017`). errdmp `errdmp_26_Sun_Nov_01_15_24` gives `DETAIL_2` raw 0x4008000 and detail 1
0x80000000000081E2. CA `first`, `mult`, `pcierr` and `gart_err` were all 0.
- The two failing addresses are offset 0x400 and offset 0 of one 16K page. Those are
  `RADEON_WB_CP_RPTR_OFFSET` and `RADEON_WB_SCRATCH_OFFSET`, and the fence log puts the WB page at
  GTT base. So these are almost certainly the CP's writeback writes. The physical page itself
  isn't confirmed.
- `radeon_wb_init()` turns WB off on AGP as "often unreliable", but `radeon_agp_disable()` has
  already cleared `RADEON_IS_AGP`, so this AGP card runs with `WB enabled`.
- Earlier dumps with no error latched show the same header (0x81E2) at another page-aligned
  address, so the header isn't what's bad. The bad byte enables must be in the data phase.
- `errdmp_26_Sun_Nov_01_14_58` and `_14_59` tell us nothing about the MCA. One was a test, and
  the box rebooted partway through the other, so their empty error registers don't clear anything.
- Next test: `modprobe radeon no_wb=1 test=1`.

`modprobe radeon no_wb=1 test=1` on `dbg1`: `WB disabled` on both cards, no panic, and the copy test
ran to the last GTT offset (0x1fe04000) on both, so every GTT->VRAM and VRAM->GTT copy verified.
With WB on, the same test died after two copies. IRQ 66 and 67 each counted 1019 after the run,
so interrupts work on both cards. fbdev failed on `0017` with -12 (`failed to allocate
framebuffer`). `radeon_do_test_moves()` only unpins its GTT objects on its error path, so a passing
test leaves GTT pinned full. That is the likely cause, and it would be a side effect of `test=1`.

`modprobe radeon no_wb=1` on `dbg1`: `WB disabled` on both cards. `startx` worked, and `glxinfo`
reported direct rendering on `ATI R420`, Mesa 26.2.4, OpenGL 2.1. `glxgears` then died with an MCA
on CPU 2, `External bus check fatal status`, with no `Fatal TIO Error`. The RCU dump showed CPU 2
in `sn_dma_flush()`, which `readl()` calls right after the PIO load, and IRQ 66 lands on CPU 2. So
a failed PIO read from the GPU is the suspect, not proven. The box cold booted, so errdmp
`errdmp_26_Sun_Nov_01_15_44` caught the PROM restarting and has no error state.

The cold boot is the kernel's doing: after `ia64_mlogbuf_finish(1)` (`Delaying for 5 seconds...`)
`ia64_mca_handler()` returns to SAL, and `panic=0` doesn't apply on that path.

Built `7.3.0-dbg2-epic1-SN2-PRISM-e85b45c55b4d-ia64`, uncommitted, not booted:
- `mca_hang` boot option spins in the MCA handler, so errdmp can read the error state
- prints the SAL bus check target, requestor, responder and `iip` on an external bus check
- `radeon_wb_init()` keeps WB off on SN2 for AGP-capable cards, replacing `no_wb=1`

`dbg2`, plain `modprobe radeon`, `mca_hang`: writeback off held, fbcon and X came up, and `glxgears`
locked the GPU. Fences stuck at 0x18 with 0x1b emitted, and radeon logged `GPU lockup` for 30 s
until it started a reset. `r100_cp_disable()` then reported the GUI never went idle. The MCA came
next: bus check target `0x41c0100420`, `0017` BAR2 + 0x420, `OV0_SCALE_CNTL`, read by
`r100_mc_stop()` from `r300_asic_reset()`. Earlier reads in that function succeeded. So the MCA
follows the lockup, and the CP stall is the primary fault. `mca_hang` held the box, so errdmp ran.
Next: `lockup_timeout=0`, which stops radeon resetting, then read CP state from debugfs.

**AGP works.** `dbg2` with `modprobe agpgart sgi-agp`, then `modprobe radeon agpmode=8`, on a boot
that skipped the capture above: `sgi-agp` registered both bridges, aperture 1024M at 0x80000000.
Both cards came up with no `Forcing AGP to PCI mode`, `AGP mode requested: 8`, GTT 1024M at
0x80000000, ring and IB tests pass, `WB disabled`, and fbcon on `0017`. This is the first
`sgi-agp` and AGP-mode `radeon` on a modern kernel.

**3D works over AGP.** Same boot, X on `0017`: `glxgears` ran at 60 FPS (vsync) with no lockup, no
MCA and no radeon errors, on the same Mesa r300 stack that hung the CP in PCI mode. IRQ 66 went
from 1 to 2660. CA errors all 0 before the run. Not yet checked: uncapped load, a long soak, or
`001b`. glmark2 reported stable by eye, no numbers yet.

Committed the I/O port fix as `82ea9b3a6ef7` on `sn2-prism`, not pushed. PCI mode is dropped, so the
writeback hunk is off the tree and saved as `pci-mode-wb-off.patch`. The debug hunks stay uncommitted
in the worktree, saved as `debug-tio-mca.patch`.

`configs/7.3-epic-sn2-prism.config` now has `CONFIG_AGP=y` and `CONFIG_AGP_SGI_TIOCA=y`, so no module
load order to manage. radeon still defaults to PCI mode, so the command line needs
`radeon.agpmode=8`, or a load falls back to PCI with writeback on. Built
`7.3.0-dbg2-epic1-SN2-PRISM-82ea9b3a6ef7-ia64` with those and the debug hunks. It passed its boot
test: radeon loaded by itself in AGP mode.

The config is back to `=m`, which suits distribution better. `/etc/modprobe.d` now carries
`softdep radeon pre: agpgart sgi-agp` and `options radeon agpmode=8`. Built as `dbg3`, same commit,
and tested by the user. glmark2 2023.01 on `dbg3`-era AGP: score 779, 800x600 windowed, on `ATI R420`
with Mesa 26.2.4. `terrain` and the `loop` scenes failed on R420 shader limits, which are expected.

Merged to `master-epic-sn2-gpu` as `6f01b0b15c87`, five commits on `419986bac12b`, with the
`Compiled only` lines replaced by what was tested. The tree matches `sn2-prism` `82ea9b3a6ef7`.
Not pushed. pople booted `6f01b0b15c87` over NFS with no oops, on the legacy IO path, but with radeon
and amdgpu blacklisted, so its GPU wasn't exercised on this tree.

Moved the three `sgi-agp` commits and the port fix down to `master-epic-sn2`, now at `641358e48ce9`
(four commits on `24d78bf62c12`). `master-epic-sn2-gpu` was restacked on top and is now at
`eb5ca12536d3`, with the same tree as `6f01b0b15c87`. The r300 commit stays in `-gpu` because it is
radeon code, and is now titled `drm/radeon: use MC address 0 for VRAM on SGI Prism`. A Prism therefore
needs `-gpu` for radeon to work. `master-epic-sn2` is pushed. `-gpu` needs a force push because its
commits were rewritten. `sn2-prism` keeps the older commits and old r300 title.
