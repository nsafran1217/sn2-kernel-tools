# Prism bring-up plan: TIOCA, FireGL X3, radeon

## Context

The goal is `radeon` running over AGP through the TIO CA on an owner's SGI Prism. Modern Linux has never booted on a Prism or on TIOCA, so nothing above the SN2 layer is proven there, and the disk image of pople's T2 install has never booted on that box.

Nathan drives the Prism, with console and power control. Claude prepares the kernels and scripts, then reads what is pasted back. SLES9 is the fallback OS.

The first step is to find out whether `master-epic-sn2-gpu` boots. Each later stage changes one thing and has a gate. A failed gate tells us which layer to fix.

`sn2-prism` started at the same commit as `master-epic-sn2-gpu` (`0e787cc6dd9d`). The tarball on the share is that commit built with the trimmed config.

## How much to trust each source

| Level | Source | Use |
| --- | --- | --- |
| Ground truth | The owner's `lspci`: R420 FireGL X3 at `17:00.0`, BAR0 128M, BAR1 I/O, BAR2 64K, ROM 128K disabled | Compare the live box against it. Confirm this Prism has the same card |
| Measured, pople only | SN2 core, multi-node (8 C-bricks), PIC, WC GTT, VGA console (`Console: colour VGA+`) | Proven on PIC only, not through the CA |
| Read in the tree on 2026-10-31 | Handoff problems 1, 2, 4 and 5 exist in the code, and all three patches apply at `0e787cc6dd9d` | The code is confirmed. Its effect on hardware is a prediction |
| Unverified | Every other claim in the old fglrx notes, `tagp` and PROM findings, the big-window address decode, `AGP_ENABLE` state, CA register behaviour | Hypotheses. Each one needs a capture before code depends on it |

The handoff's own "expected" lines are predictions too. One already looks wrong for this card: it expects `VRAM: 128M`, which is the aperture. An X3-256 should report 256M VRAM, with 128M visible.

## What this adds to the handoff

- **R420 goes first.** The trusted `lspci` makes ATOM and `r420_init` the primary path, not COMBIOS. `r420_init` uses `r300_mc_init`, so MC fix 4 applies. `radeon_agp_disable()` does select PCI mode on R420.
- **The VBIOS is required.** Without it `r420_init` continues into COMBIOS with no tables, so outputs and clocks can't work. Problem 5 therefore comes before any display work.
- **ATOM I/O uses BAR1 on this box.** The Prism's PROM takes the ACPI path, where BAR1 is a plain port number, so `rio_mem` is set and `Unable to find PCI I/O BAR` does not appear (confirmed 2026-11-01). The earlier prediction of MMIO fallback only applies to the legacy path. `sn_io_addr()` still returns NULL for ports below 64K, so the boot VGA card's BAR1 at port 0x1000 should read all ones and drop writes. `prism_probe io_regs=1` tests this: `CONFIG_MEMSIZE` should read `ffffffff` on `0017` and the real size on `001b`.
- **TIO boot code has never run on a modern kernel.** These paths run on Prism and not on pople:
  - the TIO branch of `build_cnode_tables()`
  - `sal_get_hubdev_info()` for a TIO nasid
  - `ice_error_init()`, and `panic("Fatal TIO Error")` in `huberror.c`
  - `tioca_bus_fixup()` with its `BUG_ON(!bus)`
  - `tioca_gart_init()`
  - `request_irq(SGI_TIOCA_ERROR)`
- **A failed `tioca_bus_fixup()` oopses.** `sn_common_bus_fixup()` dereferences `SN_PCIBUS_BUSSOFT(bus)` after it returns NULL. This hits the PROM-rev check and GART allocation failure too.
- **The ACPI IO path is a separate branch.** `SN_ACPI_BASE_SUPPORT()` needs DSDT OEM rev `>= 0x20101`, and pople reports `0x20001`. If this PROM reports higher, `sn_io_acpi_init()` runs instead, and that has never been tested.
- **`radeon` may autoload on first boot.** The image comes from pople, where X runs. A first-boot crash could then be `radeon` rather than the kernel, so block it for that boot.
- **The image's kernel is unknown.** Check `uname -r` rather than assuming `0e787cc6dd9d`. That matters on a multi-node box because of the stale-TLB fix.
- **`fallback=0` doesn't help after a panic.** Grub only falls back if it fails to load the entry. `CONFIG_PANIC_TIMEOUT=30` would also reboot mid-errdmp, so test entries use `panic=0`.

## Handoff claims checked

Add to this as captures come in. Only "Hardware" means it ran on a Prism.

| Claim | Status | Evidence |
| --- | --- | --- |
| `sg4.bin` is an ATOM image for `1002:4a4d` | File confirmed | Parsed from the `sg2flash` RPM: PCIR ID, `ATOM` header, checksum 0, 56832 bytes. Whether it suits this card is untested |
| All five `sg*.bin` PCI IDs and BIOS types match the table | File confirmed | Same parse. Only `sg4.bin` has an `ATOM` header |
| ATOM IIO uses BAR1 | Handoff right on this box, Hardware | No `Unable to find PCI I/O BAR` line on either card, so `rio_mem` is set. The MMIO prediction only holds on the legacy path. On the ACPI path BAR1 is a plain port number. Card `0017` is at port 0x1000, which `sn_io_addr()` drops because it is below 64K, so its IIO should be lost. Confirmed by `prism_probe io_regs=1`: `ffffffff` on `0017`, `10000000` on `001b` |
| `VRAM: 128M` expected | Wrong, Hardware | `VRAM RAM=256M, BAR=128M` on both cards |
| Patches 0001-0003 apply | Source confirmed | Clean at `0e787cc6dd9d`. 0001 is now four commits, identical apart from comments |
| Problems 1, 2, 4, 5 exist in the code | Source confirmed | Read in the tree. Their effects are predictions |
| Problem 3, `AGP_ENABLE` | Card side set by firmware, Hardware. CA side open | `lspci` on both cards: `AGP+`, `Rate=x8`, `SBA+`, `FW-`. CA registers need Stage 2 |
| Problem 5, ROM reads back when enabled | Not needed for `radeon`, Hardware | PROM shadows the ROM in reserved RAM at `0x138f6817000` and `0x138f6825800`. `sn_acpi_slot_fixup()` points the ROM resource there. `ATOM BIOS: RADEON` on both cards with no `sg4.bin`. The log doesn't show which `radeon_get_bios()` route won |
| Big-window address decode | Open | Stage 2 |
| Ring runs in WC GTT | Passed, Hardware | Ring and IB tests pass on both cards in PCI mode |
| `radeon` load is stable | Failed once, Hardware | With a monitor on `0017`, `Fatal TIO Error` right after the IB test: `WRC_CT_WR_REQ_BAD_BE`, a write from Coretalk source 0x2 to memory, data enables 0, address 0x801080. The kernel had only reached the connector list, before `radeon_hpd_init()`, EDID or any modeset. The PROM prints that field shifted by 3, so the real address is 0x4008400. A second panic under `radeon test=1` hit 0x4008000, the same 16K page. Offsets 0x400 and 0 match the CP writeback slots, so WB is the prime suspect. Intermittent, 2 of 5 loads. `no_wb=1` not tested yet |
| INTx through the CA | Open | Irq 66 and 67 assigned. Counts after `radeon` loads not captured |
| `numa_node` reads 0 | Wrong, Hardware | Reads -1 on all devices, because ACPI has no node for the root buses and `dev->numa_node` is set before the SN fixups. `controller->node` is set later |
| Explicit `modprobe` bypasses `modprobe.blacklist=` | Hardware | `radeon` loaded with the blacklist on the command line |

## Stages

Each stage ends with a capture pasted back and a line in the `README.md` log.

### Stage 0: firmware, no OS

Record the SAL version, the L1/L2 brick list, memory per node, and the Altix IO topology, which should show the TIO bus. From the EFI shell, run `map` and `pci`, and read the card's config space if the shell allows it. `AGP_COMMAND` here tells us whether firmware set `AGP_ENABLE`.

Find the path to `\EFI\boot\bootia64.efi`, because the Prism's NVRAM has no entry for the new disk. Don't flash or change firmware.

**Gate:** the machine reaches the EFI shell and sees the disk.

### Stage 1: does the branch boot?

1. Boot the image's grub from the EFI shell. Its grub may have no working timeout, so expect a keypress.
2. Edit the entry to add `modprobe.blacklist=amdgpu,radeon panic=0 ignore_loglevel printk.time=1 systemd.unit=multi-user.target`, and keep `console=ttySG0,38400n8 earlyprintk=serial`.
3. If `uname -r` isn't `0e787cc6dd9d`, install the share tarball and boot that too. That also tests `root=/dev/sda2` without an initrd.

**Gate:**
- login over serial and ssh, and `uname -r` shows the expected sha
- no oops, and `dmesg` shows all CPUs, nodes and memory
- the card is at bus `17` with BARs matching the trusted `lspci`
- `lspci -k` shows no driver bound
- the DSDT rev is logged, which settles ACPI versus non-ACPI

| Symptom | Next step |
| --- | --- |
| Silent hang or freeze | errdmp before reset, then add `initcall_debug keep_bootcon` |
| `BUG` or oops in `tioca_bus_fixup` or `tioca_gart_init` | `sn2_no_tioca` kernel to prove the CA is the cause, then fix it |
| `Fatal TIO Error`, or MCA during PCI init | errdmp. Decode `TIO_CA_*` and `TIO_ICE_*`, then compare with SLES9 |
| Dies in or near `console_init` | `VGA_CONSOLE=n` kernel |
| `ACPI` branch taken and it fails | Debug `io_acpi_init.c`, which is new ground |
| Kernel is fine, userspace stuck | Probably pople's image: `fstab` NFS mounts, network config, host identity. Use a serial login on this box |
| Wrong root device, or no network | Kernel works. Fix `ROOTDEV` or the trimmed config |

If it can't be solved from T2, boot SLES9. It's the only OS expected to work here, so captures from it show what correct looks like. Run `prism-capture.sh` there and compare. If the 7.3 failure stays unexplained, step through older kernels (`src/kerns` 3.14, 4.19) to find where TIO broke.

### Stage 2: read the hardware, no `radeon`

Load `prism_probe` one step at a time: CA registers, then GPU registers, then the ROM test, then the ROM dump.

These questions get answered:
- Is the card POSTed, and is Memory Space enabled?
- Are `AGP_ENABLE`, `ca_control1` and calibration set?
- Is the big-window decode right?
- Does `numa_node` read 0, as patch 0003 predicts?
- Can the ROM be read with the enable bit set?

**Decision on the ROM:**
- If it reads `55 aa`, copy it at fixup and set `pdev->rom` and `romlen`.
- If not, supply `sg4.bin` through `request_firmware()`.
- If the live ROM reads fine, compare it with `sg4.bin`.

**Gate:** a valid ATOM image is available by one of those routes, and any CA error raised by the disabled-ROM read is understood.

### Stage 3: PCI mode

Apply commit (a) plus the ROM fix from Stage 2. After boot, run `modprobe radeon agpmode=-1 msi=0` over ssh, with `sgi-agp` not loaded. Loading it by hand means a crash can't block the next boot. Confirm that explicit `modprobe` bypasses `modprobe.blacklist=`, or use `insmod`.

**Gate:** `Forcing AGP to PCI mode`, ATOM detected, CP firmware loaded, ring test and IB test pass, and `/proc/interrupts` counts rise on the card's IRQ.

| Failure | First suspect |
| --- | --- |
| Ring or IB test fails | WC, because `radeon` may never have run its ring in WC. Test with UC in `ttm_io_prot()` before suspecting the CA |
| Ring passes, IB times out | INTx routing through the CA, which is unproven |
| Stale GTT data | `r100_pci_gart_tlb_flush()` is an empty TODO |
| Fault around the writeback page | Try `radeon.no_wb=1` |
| VRAM reads back shifted | Write `CONFIG_APER_0_BASE = 0` |
| ATOM hangs or misbehaves | ATOM IIO through MMIO, the fallback from `rio_mem` being NULL |

### Stage 4: `sgi-agp` loads

Add commit (b). Load `agpgart` and `sgi-agp` by hand, then read `/proc/driver/agpgart`. Add `softdep radeon pre: agpgart sgi-agp`.

**Gate:** the bridge registers with a real `pci_dev`, the aperture matches the code's constants, and PCI mode still passes Stage 3.

### Stage 5: AGP

Add commits (c) and (d). Boot with `radeon.agpmode=8`, since the driver describes the CA as 8x only. Keep FastWrite off. The `TIOCA AGP:` log line shows whether firmware enabled AGP.

**Gate:** `GTT:` shows the AGP aperture, ring and IB tests pass, and there are no CA errors in `ca_gart_err` or `ca_pcierr_type`.

If DMA hangs, compare `AGP_COMMAND`, `ca_control1` and `ca_control2` with a SLES9 capture under working `fglrx` (`kernel-rtgfx` and `km-rtgfx-fglrx` are on the share). Treat `tagp`'s sequence as a guide only. Check `CA_AGP_INIT_CAL_ENB` next, then retry at 4x.

### Stage 6: display and userspace

Check connectors, EDID and `modetest` without X, then fbcon, then X and Mesa r300. Headless evidence comes first (`/sys/class/drm/*/status`, EDID, framebuffer readback). The owner only needs to look at a monitor at the end.

**Gate:** a stable display, plus a soak with `gpu_optimization/gpu-upload-bench.c`.

### Stage 7: tuning and merge

- Apply patches 0002 and 0003 only after AGP works, and measure before and after. Pull them forward only if Stage 2 shows `ZONE_DMA32` is unusable on this box.
- Test WB GTT on TIOCA as an experiment.
- Sort the commits into layers: `sgi-agp` and SN2 fixes go in `-sn2`, and the `r300.c` hunk goes in `-gpu`, under `#ifdef CONFIG_IA64_SGI_SN2`.
- Regression-boot pople before touching `master-epic-sn2-gpu`, after asking first.
