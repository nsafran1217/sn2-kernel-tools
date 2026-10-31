# SGI Prism AGP bring-up

Progress and notes for getting AGP working on a Prism. The box belongs to someone
else and is remote from the build workstation. It runs the same T2 install as pople.

## Setup

- Tree: `src/mainline/linux-sn2-prism`, a worktree on branch `sn2-prism`, branched from
  `master-epic-sn2-gpu` at `0e787cc6dd9d`. All work and builds happen there.
- `firmware/qlogic/12160.bin` is gitignored, so it was copied into the worktree by hand.
  `CONFIG_EXTRA_FIRMWARE` needs it.
- Config: `../configs/7.3-epic-sn2-prism.config`.

## Build and install

On the workstation:

```bash
sn2-kernel-tools/prism-build.sh
```

This builds the worktree and puts `linux-<release>.tar.gz` and `prism-install.sh` in
`/mnt/nfs/altix/prismkerns/`. Nothing goes to the netboot server or to `release/`.

On the Prism, as root:

```bash
prism-install.sh
```

This fetches the newest tarball from the VPN host's `/nfs/altix/prismkerns` into
`/root/prismkerns`, installs the kernel and modules, adds a grub entry and makes it the
default. It does not reboot.

The VPN host stays out of this repo. `prism/remote` is gitignored and holds its `user@host`,
and `prism-build.sh` writes that into the copy of `prism-install.sh` on the share. Set
`REMOTE=user@host` on the Prism to override it.

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

- [ ] `prism-install.sh` run for the first time (not yet tested anywhere)
- [ ] Confirm `/nfs/altix/prismkerns` on the VPN host; port 22 timed out from the workstation
- [ ] Confirm the Prism's root disk is `/dev/sda2` and which IO brick it has
- [ ] First boot of the no-initrd kernel
- [ ] Check the Prism's command line for `modprobe.blacklist=amdgpu,radeon`, which would block the GPU driver
- [ ] AGP working

## Log

### 2026-10-30

Set up the worktree, the config and the build and install scripts. Dropped `amdgpu` and
moved `mspec` to a module. The Prism build at `0e787cc6dd9d` is on the share as `linux-7.3.0-rc3-epic1-SN2-PRISM-0e787cc6dd9d-ia64.tar.gz`.
`System.map` confirms ext4, `qla1280`, `sata_vsc`, `tg3` and the 12160 firmware are built
in. No kernel has been installed or booted yet.
