# FireGL AGP on SN2 (TIOCA): kernel handoff

This is a handoff for the Altix kernel work in `~/projects/altix_cross`. Kernel paths are relative to the tree root (branch `master-epic-sn2-gpu`). I read a clean clone at `a107c0ed2d38`, in `fglrx/linux-sn2`. Your working tree is at `0e787cc6dd9d`, which differs from it only in `arch/ia64/mm/tlb.c`.

I assumed the target is a FireGL in a TIO CA AGP slot, as on a Prism. The `prompt.md` notes say the Altix 350 `pople` has no TIO, so **none of this has run on hardware**. On a PIC bus, only the MC base fix and the VBIOS notes apply.

The evidence for each claim, and corrections to the older notes, are in [fglrx-re-notes.md](fglrx-re-notes.md).

## Summary

Use `radeon`, not a port of fglrx. fglrx has very little SN2-specific logic, and most of what looked special was the 2.6.5 platform macros. The kernel side has five problems. Three are bugs in existing code, and two need a read on the box.

| # | Problem | Status | Fix |
| --- | --- | --- | --- |
| 1 | `sgi-agp` stores a bad `pci_dev`, so `agp_find_bridge()` returns a bad bridge | Read from source | Patch 0001 |
| 2 | `sgi-agp` rejects every TTM AGP bind with `-EINVAL` | Read from source | Patch 0001 |
| 3 | Nothing in Linux sets `AGP_ENABLE` on the card, and `mode` is ignored | Unknown whether firmware sets it | Patch 0001, conditional |
| 4 | `r300_mc_init()` uses a CPU address as the GPU MC base | Read from source | Patch 0001 |
| 5 | The VBIOS is probably unreadable on a root-bus card | Likely, not proven | Test first, no patch yet |

[patches/0001-tioca-agp-radeon-proposed.patch](patches/0001-tioca-agp-radeon-proposed.patch) covers problems 1-4. [patches/0002-tioca-no-dma32-restriction.patch](patches/0002-tioca-no-dma32-restriction.patch) and [patches/0003-sn2-set-pci-dev-numa-node.patch](patches/0003-sn2-set-pci-dev-numa-node.patch) keep GTT pages near the card, which matters because the cards won't be on nasid 0 ([ZONE_DMA32](#zone_dma32-and-swiotlb)). All three apply to `a107c0ed2d38` and compile cleanly against your `.config`. None has been run.

The safest route is to bring the card up in PCI mode first. That needs only fix 4, plus `radeon.agpmode=-1`. See [Bring-up order](#bring-up-order).

## Problem 1: `sgi-agp` uses a list head as a `pci_dev`

`agp_sgi_init()` in `drivers/char/agp/sgi-agp.c:293-301` walks the bus, then uses the iterator after the loop:

```c
list_for_each_entry(pdev, info->ca_devices, bus_list) {
        ...
        if (!cap_ptr)
                continue;
}
sgi_tioca_agp_bridges[j] = agp_alloc_bridge();
...
sgi_tioca_agp_bridges[j]->dev = pdev;     /* line 306 */
```

The loop has no `break`, so it always runs to the end, and `pdev` is then `container_of()` the list head rather than a device. The 2.6.5 code used `list_for_each()` with `pdev = pci_dev_b(tmp)` inside the loop, so it was left holding the last real device. Commit `0a4af1473a7d` "sgi-agp: Use list_for_each_entry() for bus->devices traversal" (2012) changed that, and nobody with the hardware noticed.

What follows from reading the structs:

- The bogus `pdev` overlays `bus->devices`, so `pdev->bus` reads `bus->self`, which is NULL on a root bus.
- `sgi_tioca_find_bridge()` compares that with the real `pdev->bus`, never matches, and falls off the end of its own `list_for_each_entry()`. `sgi-agp.c:241-245` then returns a pointer built from the `agp_bridges` list head, which is not NULL.
- `radeon_agp_head_init()` (`radeon_agp.c:138`) trusts it and calls `agp_copy_info()` on it.
- `agp_add_bridge()` also prints through `bridge->dev->dev`.

Expect garbage or an oops, either at `sgi-agp` load or at the first `radeon` probe.

**Fix:** remember the matching device in the loop, and return NULL from `sgi_tioca_find_bridge()` when nothing matches.

## Problem 2: TTM binds always fail

`ttm_agp_bind()` sets `mem->type = AGP_USER_MEMORY` or `AGP_USER_CACHED_MEMORY` (`ttm_agp_backend.c:78`), which are `0x10000` and `0x10001`. `agp_bind_memory()` passes that type to the driver (`generic.c:424`), and `sgi_tioca_insert_memory()` refuses it:

```c
if (type != 0 || mem->type != 0) {     /* sgi-agp.c:169 */
        return -EINVAL;
}
```

`sgi_tioca_remove_memory()` has the same test at line 211. This check dates from 2.6.5, when fglrx allocated type 0. TTM didn't exist then, but v3.0 already has both sides of the mismatch, so `radeon` AGP on TIOCA can't have worked in any TTM-based kernel.

**Fix:** test through `agp_type_to_mask_type()`, as `agp_generic_insert_memory()` does. `agp_generic_type_to_mask_type()` returns 0 for the user types, and the CA has only one GART entry format.

## Problem 3: `AGP_ENABLE`

`sgi_tioca_agp_enable()` ignores `mode` and only calls `tioca_fastwrite_enable()`, which sets the FastWrite bit:

- It does not set `AGP_ENABLE`, the rate or SBA in `AGP_COMMAND`.
- It turns FastWrite on even though `radeon_agp_init()` clears `RADEON_AGP_FW_MODE`.

fglrx is no help here. The X driver calls `drmAgpEnable()`, which ends in the same hook. It then reads `AGP_COMMAND` back, and its only reaction is a log line: `[agp] AGP protocoll is NOT enabled for grafics board`. The kernel module has a matching `AGP protocoll not yet enabled - aborting check!`, and `_r6x_CheckAGPCommand` returns success anyway.

So either firmware or the VBIOS sets the bit, or Prism never ran the AGP protocol at all. I couldn't settle that statically: the PROM reaches its PCI config helpers through a function table.

SGI's `tagp` diagnostic does it explicitly, after POST: `AGP_COMMAND |= 0x80006312`. That is `AGP_ENABLE`, SBA, FastWrite, 8x and `ARQSZ=3`, plus the top bit of `RQ`, and it also sets `CA_AGP_FW_ENABLE` in `ca_control1`.

**Fix:** the patch reads `AGP_COMMAND` and logs it. If `AGP_ENABLE` is clear, it programs `RQ`, `ARQSZ=3`, SBA and the rate, then sets `AGP_ENABLE` as a second write. It enables FastWrite only if `mode` asks for it. If firmware already enabled AGP, it leaves the card alone, because the rate must not change while AGP is enabled.

The first log line from this code answers the open question.

## Problem 4: the MC base is a CPU address

`r300_mc_init()` (`r300.c:491`) takes `base = rdev->mc.aper_base`, which is `pci_resource_start(pdev, 0)` (`r100.c:2811`). On SN2 that is a PIO address with NASID bits, such as `...41c8000000`. `radeon_vram_location()` stores all 64 bits in `vram_start`.

Three things follow:

- `MC_FB_LOCATION` gets the low 32 bits, `0xc8000000`. The real bus address is `0x08000000` (see [address map](#address-map)), so that value is arbitrary, and it lands inside the CA PCI GART range `0xc0000000-0xffffffff`. A `dma_map` address there would hit VRAM instead of memory.
- `r100_copy_blit()` is the `.copy` function for R300 and R420. `r100.c:958-959` does `(pitch << 22) | (cur_src_offset >> 10)` on a 64-bit offset, so address bits 32-41 land in the pitch field. The R100 guide's Fix 3 addressed this on 5.10, and it isn't in this tree.
- `radeon_gtt_location()` does its size arithmetic on the same value, which only makes sense below 4GB.

The R100 guide calls the truncation correct "by accident". On TIOCA the NASID bits make it worse.

**Fix:** SGI's own R300 code uses MC address 0 for VRAM (`MC_FB_LOCATION = 0x07ff0000`), whatever BAR0 is. The patch sets `base = 0` on SN2. All VRAM offsets are then below 4GB, clear of both CA apertures, and fix 3 from the guide is no longer needed.

`tagp` also writes `CONFIG_APER_0_BASE = 0` (`0x100`), and `radeon` never writes that register. I left it out of the patch. If the first CPU write-and-read test of VRAM comes back shifted, add `WREG32(RADEON_CONFIG_APER_0_BASE, 0)` after `MC_FB_LOCATION` in `r300_mc_program()`.

## Problem 5: the VBIOS is probably unreadable

A TIOCA card sits on a root bus, so `sn_io_slot_fixup()` handles its ROM (`io_init.c:222-226`):

```c
if (idx == PCI_ROM_RESOURCE) {
        pci_disable_rom(dev);
        res->flags = IORESOURCE_MEM | IORESOURCE_ROM_SHADOW |
                     IORESOURCE_PCI_FIXED;
}
```

This clears the ROM enable bit, and it tells the core that a shadow copy exists at `pdi_pio_mapped_addr[ROM]`. `pci_enable_rom()` then returns early, so `pci_map_rom()` reads that address with the ROM decode off.

The evidence that this fails:

- The R100 guide records `Unable to locate a BIOS ROM` for a root-bus PCI card on PIC, and "The GPU's expansion ROM is not accessible on SN2".
- Your working VBIOS reads were on the card behind the PLX. It has no `pdi_pio_mapped_addr[ROM]`, so it uses a normal ROM BAR (`ROM [mem 0x00340000-0x0035ffff pref]`, boot log line 714). That path says nothing about this one.
- Shadowing was added in `a2302c68d923` (2006) "when running with an ACPI capable PROM". This box's PROM takes the non-ACPI path. The old Prism `lspci` shows the ROM at a PIO address, not memory.
- `240504adaf07` (2016) added the `pci_disable_rom()` call. v3.0 did not disable the ROM.

So the "shadow" is probably just the card's ROM BAR, turned off. I can't prove that without the hardware, and a read of a disabled ROM may also report a CA PCI error. Note that a normal `pci_enable_rom()` won't work either: `pcibios_resource_to_bus()` no longer translates BARs on SN2 ([v3.0 comparison](#changes-since-v30)), so it would write the low bits of the CPU address into the ROM BAR.

**What losing the VBIOS costs:**

- An R420 falls back to `radeon_combios_init()` with no tables, because `is_atom_bios` stays false.
- `radeon_boot_test_post_card()` returns false, and init fails, if EFI didn't POST the card.

**Test:** see [Instrumentation](#instrumentation). Set the enable bit by hand in the ROM BAR, keeping its existing address, and read the first bytes through the PIO address.

**If that reads `55 aa`:** copy the ROM once at fixup into kernel memory, then set `pdev->rom = virt_to_phys(copy)` and `pdev->romlen`. `radeon_read_platform_bios()` already uses these as its last fallback. `pdev->rom` is a physical address that it passes to `ioremap()`, and ia64's `ioremap_prot()` returns the cached mapping for kernel memory, so this is safe.

`radeon_read_bios()` still runs first and reads the disabled ROM. If that read raises an error, stop it reaching the ROM, for example by clearing the ROM resource after the copy.

**If it doesn't:** supply the matching `sg*.bin` the same way, through `request_firmware()`. That can't happen at fixup time, so do it from `radeon` or a late initcall.

## Checked, no change needed

| Item | Result |
| --- | --- |
| 32-bit DMA mask | `radeon_device.c:1362-1367` already uses 32 bits for AGP and for PCI up to RS740 |
| Bus fixup order | `tioca_bus_fixup()` runs from `pcibios_fixup_bus()`, after the scan, so `bus->devices` is populated and `pci_find_bus()` works |
| `force_interrupt`, `target_interrupt` NULL | Both callers check first (`sn/kernel/irq.c:193`, `:407`) |
| `readl` flush | `readl` is `___sn_readl`, which already calls `sn_dma_flush()` |
| `mmiowb` at unlock | `arch_spin_unlock` calls it unconditionally (`asm/spinlock.h:77`), so `CONFIG_MMIOWB` isn't needed |
| Page size | `sgi_tioca_insert_memory()` writes one entry per kernel page, which needs CA page size == `PAGE_SIZE`. Your config is 16KB, which matches. **64KB pages would break AGP** |
| `tioca_provider.c` | Matches 2.6.5 apart from API updates and a safer bitmap search |

## Hardware facts

### Address map

The existing notes have this wrong. These are the constants in `tioca.h:581-594`, whose `/* 2GB */` comments are stale:

| Bus range | Size | Use |
| --- | --- | --- |
| `0x00000000-0xbfffffff` | | Reachable by PIO, for BARs |
| `0x80000000-0xbfffffff` | 1GB | AGP GART, 65536 16KB entries, owned by `sgi-agp` |
| `0xc0000000-0xffffffff` | 1GB | PCI GART, 65536 16KB entries, owned by `tioca_provider.c` |

The GART table is one 1MB table, and it holds 2GB of aperture, not 4GB.

The old Prism `lspci` values decode cleanly. Take the TIO address bits below the NASID (`nasid<<38`), then apply `TIO_BWIN_WINDOWNUM`, `(x>>30)&7`:

| `lspci` value (nasid 1) | Offset | Decoded | Bus address |
| --- | --- | --- | --- |
| `Region 0 c0000041c8000000` | `0x1c8000000` | Big window 7 + `0x08000000` | Memory `0x08000000` |
| `Region 2 c0000041c0100000` | `0x1c0100000` | Big window 7 + `0x00100000` | Memory `0x00100000` |
| `ROM c0000041c0120000` | `0x1c0120000` | Big window 7 + `0x00120000` | Memory `0x00120000` |
| `Region 1 c000004023010000` | `0x23010000` | CA registers `0x20000000` + `CA_PIO_PCI_IO 0x03000000` + `0x10000` | I/O port `0x10000` |

This is an inference, but it fits three independent facts:

- `tagp` programs BAR0 to `0x08000000`.
- The CA register base is `0xc000000020000000 | nasid<<38`.
- EFI's `post_vbios()` has special handling for I/O BARs above `0xffff`.

Each CA has one device, at type 0 config offset `0x01010000`. `ca_discover` in the PROM probes only that slot.

### Reference bring-up sequence

The `tagp` SMDK diagnostic (`tagpAGPDmaBasicSSec2`) is SGI's bare-metal AGP test for "ATI R3xx cards". This is the sequence it uses for GART-mapped DMA:

1. `caBdgInit`: `ca_control1 = 0x800` (`CA_AGP_INIT_CAL_ENB`), `ca_control2 = 0x611fff0c00000000`, then clear error registers.
2. `tagpDevInit`: BAR0 `0x08000008`, BAR1 `1`, BAR2 `0x00200000`, latency `0xff`, COMMAND `7`.
3. `biosemu`: POST the card's BIOS under x86emu.
4. Write `TIO_ICE_FRZ_PIO_BIG_WINDOW_1` so that window 1 reaches this CA's PIO memory space.
5. Set `CA_AGP_FW_ENABLE`, `AGP_COMMAND |= 0x80006312`, then delay.
6. `ca_agp_dma_addr_extn = 0`, then build the GART: table, aperture, TLB flush, then `CA_GART_MEM_PARAM = 2`, then prefetch settings.
7. `R300DmaInit`: `MC_FB_LOCATION = 0x07ff0000`, `CONFIG_APER_0_BASE = 0`, `AGP_BASE = 0x08000000`, `MC_AGP_LOCATION = 0xdfff0800`.
8. Run the DMA.

Step 7 makes MC addresses above VRAM identical to bus addresses, so MC `0xc0000000` is bus `0xc0000000`. `radeon` gets the same effect for its GTT, with `gtt_start = agp_base = 0x80000000`.

The kernel doesn't touch `CA_AGP_INIT_CAL_ENB`, and I don't know whether the PROM sets it. The X driver has a `DisableAGPCalibrationFix` option. Compare `ca_control1` against step 1 if AGP transfers fail.

### Memory attributes

| Memory | fglrx | Current SN2 TTM |
| --- | --- | --- |
| Registers and VRAM | UC, via `remap_page_range` (`_PAGE_MA_UC`) | UC |
| AGP pages | Cached WB, faulted in by `vm_cant_nopage` | WC |
| PCI GART pages | Cached WB, from `page_address()` | WC |

fglrx never used write-combining: `__ke_mtrr_add_wc` is a stub that returns -1, and it never changes the attribute of RAM. That matches the rule in the old `asm-ia64/agp.h`: "we require that the AGPGART engine operate in coherent mode, which lets us map the AGP memory as normal (write-back) memory". The CA is coherent here (`CA_GART_MEM_PARAM = 2`).

This doesn't conflict with `a107c0ed2d38`. Keep WC for now, because `ttm_agp_tt_create()` already asks for it and it matches what you've tested on PIC.

Later it's worth testing WB on TIOCA. The "WB means `FSB_PROTO_ERR`" finding came from PIC, where DMA goes through the Shub II. CA DMA takes a different route (`tioca_provider.c:176-177`: "use GET semantics to fetch memory", "participate in coherency domain"), and fglrx ran WB on it. That is a hypothesis, not a result. One point in its favour: the kernel writes `ca_gart` through the WB mapping with `ca_gart_iscoherent = 1`, so the CA already fetches GART entries from cached memory without explicit flushes.

### `master-epic-sn2-gpu` changes on TIOCA

Nothing in the seven commits on top of `master-epic-sn2` breaks TIOCA, and none needs reverting. The nodes are SHub1, so the WC findings in `gpu_optimization/WC-FINDINGS.md` apply to the CPU side.

| Change | Effect on TIOCA | Verdict |
| --- | --- | --- |
| `ttm_io_prot()`: VRAM is UC | The hang is a SHub1 PIO limit, and TIOCA PIO goes through the same SHub. fglrx also used UC for I/O | Keep |
| `ttm_io_prot()`: GTT is WC | AGP matches what `radeon` asks for: `ttm_agp_tt_create()` uses `ttm_write_combined`. `cant_use_aperture` keeps the CPU on the pages, not the aperture | Keep |
| `ttm_pool.c` zero and flush | AGP pages come from the same `ttm_pool_alloc()`, so they're covered. `sgi_tioca_cache_flush()` is empty, so nothing else flushes them | Keep |
| `drm_need_swiotlb()` returns false | Still needed: it would also be true here. Its comment mentions only PIC | Keep |
| `ZONE_DMA32`, `MAX_DMA_ADDRESS` | Keep for PIC. Patches 0002 and 0003 handle TIOCA | Keep, with patches |
| `select SWIOTLB` | No effect | Optional cleanup |
| PLX fixup, UVD `writel` | PLX device IDs and `amdgpu` only | Not relevant |

**Not tested with `radeon`.** All the WC results are from `amdgpu` on Oland, behind PIC and PLX. The branch has no `radeon` SN2 code, and your notes only show `radeon` running with GTT forced to UC (`3b5859846492`). So this may be the first time its ring and IBs are in WC. `radeon` ends a ring update with `mb()` and a PIO write of WPTR, and WC stores took 3-9µs to appear without a fence. So if the ring or IB test fails, rule WC out before suspecting AGP. Temporarily change the GTT line in `ttm_io_prot()` to `return pgprot_noncached(tmp);`.

**PCI mode differs from AGP.** After `radeon_agp_disable()` the card isn't PCIe, so `radeon_bo_create()` clears the WC flags and GTT BOs are `ttm_cached`:

- `ttm_io_prot()` still gives WC for user mappings and multi-page `vmap()`.
- `ttm_bo_kmap_ttm()` maps a single-page `ttm_cached` BO through the WB identity map. With 16KB pages that includes the writeback page, and writeback stays on for R300 and later in this mode. The same is true on PIC. If Stage 1 faults there, try `radeon.no_wb=1`.
- The R300 PCI GART table is `dma_alloc_coherent()` memory, which the CPU writes through WB and the GPU reads. It's a small table with infrequent updates, but it's an exception to the "no Modified lines" rule.

AGP has none of these exceptions: BOs are always WC, writeback is off, and the CPU writes the CA GART instead.

Keep VRAM UC. fglrx did too, and the WC hang in `a107c0ed2d38` is a PIO-space problem.

### Cards and VBIOS

The `sg2flash` RPM shipped SGI's images in `/usr/share/gfx`. This settles the "tribal knowledge" about custom firmware. The ROMs are SGI-specific builds, and only the R420 is ATOM:

| File | PCI ID | Chip | Banner | BIOS type |
| --- | --- | --- | --- | --- |
| `sg1.bin` | `1002:4154` | RV350 | `ATI RADEON 9600 PRO`, 113-EVALUATION-100, 2005-05-13 | COMBIOS |
| `sg2.bin` | `1002:4e47` | R300 | `SGI-ATI FireGL X1-256p`, 113-99002-114, 2004-05-04 | COMBIOS |
| `sg3.bin` | `1002:4e4b` | R350 | `SGI-ATI FireGL X2-256p`, 113-A10503-110, 2004-05-06 | COMBIOS |
| `sg3a.bin` | `1002:4e4b` | R350 | `ATI FireGL X2-256p`, 2005-02-16 | COMBIOS |
| `sg4.bin` | `1002:4a4d` | R420 | `RADEON X800 ATOMBIOS A301`, 2005-05-13 | ATOM |

- All five PCI IDs are in `drm_pciids.h`.
- R300, R350 and RV350 use `r300_init()`, which demands COMBIOS. R420 uses `r420_init()` with ATOM.
- The other SN2 GPU work has mostly exercised ATOM. Expect `radeon_combios_*` to be new ground on this platform.
- These files are a known-good copy if the ROM can't be read ([Problem 5](#problem-5-the-vbios-is-probably-unreadable)). Extract them with `rpm2cpio prom/rpms/sg2flash-*.rpm | cpio -idm`.

### POST

EFI posts cards itself. `VgaClassDriverBindingStart` calls `post_vbios()`, which runs the BIOS under x86emu. A 16-bit BIOS can't reach port `0x10000`, so it temporarily moves any I/O BAR above `0xffff` to `0x400`, and restores it afterwards.

This only happens if EFI binds its VGA driver, so don't rely on it. `radeon_boot_test_post_card()` covers the other case. The kernel's `PV908234` note, "ATI config space problems after BIOS execution starts", applies to rev A only.

Rev A workarounds are effectively dead code: the PROM's `ca_discover` prints `Ignoring probe of rev 1 CA bus due to PV 908609`.

## ZONE_DMA32 and SWIOTLB

**History, from the commits:**

| Kernel | `MAX_DMA_ADDRESS` on SN2 | `ZONE_DMA32` (`ZONE_DMA` at v3.0) | `SWIOTLB` |
| --- | --- | --- | --- |
| v3.0 | `PAGE_OFFSET + MAX_PHYS_MEMORY` | Off (`depends on !IA64_SGI_SN2`) | Not selected by SN2 |
| Last upstream SN2 (`cf07cb1ff4ea~1`) | The same | Off (`depends on !IA64_SGI_SN2`) | Not selected by SN2 |
| `bf178c9b8de7` "Apply sn2 patch" | The same | Off (`select ... if !IA64_SGI_SN2`) | Off (`select ... if !IA64_SGI_SN2`) |
| `489599354cbc` (your tree: `6f6e32c8ba29`), 2026-04-23 | `PAGE_OFFSET + 0x3080000000` | On | On |

`MAX_PHYS_MEMORY` is `1UL << IA64_MAX_PHYS_BITS`, which is 2^50, so the old value was `0xe004000000000000`. That was SGI's way of saying "no DMA limit": it sits past any real memory. With no DMA zone, `GFP_DMA32` restricted nothing.

The new limit is correct for the PIC, and it should stay. The PIC has 1024 ATEs, or 16MB of reach, so GPU pages must land in its direct32 window.

The CA doesn't have that constraint:

| | PIC | CA |
| --- | --- | --- |
| Mapped reach | 1024 ATEs, 16MB | 65,536 PCI GART entries, plus 65,536 AGP GART entries, 1GB each |
| Where the table lives | On the chip | System RAM on `ca_closest_node`, one 1MB table for both |
| Where a mapped page can be | Anywhere | Anywhere |
| 32-bit direct window | Used, bottom 2GB of nasid 0 | Not used (`tioca_dma_map()`) |

### Keeping GTT pages near the card

The cards won't be on nasid 0, and two separate things pull GTT pages there. Reverting the `ZONE_DMA32` change would fix only the first, and it would break PIC GPUs. Use these two patches instead.

**1. `GFP_DMA32` (patch 0002).** `radeon` sets a 32-bit mask, and `sn_dma_get_required_mask()` returns 64 bits. So `dma_addressing_limited()` is true, and TTM allocates from `ZONE_DMA32`, the 2GB at `0x3000000000-0x307fffffff` on nasid 0. Only nasid 0 has that zone, so the card's GTT pages can't come from anywhere else, and they're capped at that 2GB.

Patch 0002 returns a 32-bit required mask for TIOCA devices, so TTM drops the flag for them only. PIC devices are unaffected.

**2. `dev->numa_node` is 0 (patch 0003).** TTM uses `dev_to_node()` as its preferred node, but that value is stale on a TIOCA card:

1. `sn_pci_controller_fixup()` allocates the controller with `kzalloc()`, so `controller->node` is 0.
2. `pci_scan_slot()` reaches `pci_device_add()`, which copies that 0 into the device.
3. `pcibios_fixup_bus()` runs afterwards, and only then does `tioca_bus_fixup()` set `controller->node = ca_closest_node`.

Nothing copies the corrected value to the device. `sn_dma_alloc_coherent()` isn't affected, because it reads `pcibus_to_node()` directly. Without patch 0003, patch 0002 alone would still fill node 0 first, and spill to other nodes only when node 0 runs out.

Patch 0003 calls `set_dev_node()` in `sn_pci_fixup_slot()`, which runs after the bus fixup. This is from reading the source. Your notes record `numa_node` 0, but that card really is on node 0, so they can't confirm it.

PIC, TIOCP and TIOCE devices have the same stale value, because `sn_io_late_init()` sets their node later still. Patch 0003 doesn't change them.

**Check on the box:**

```sh
cat /sys/bus/pci/devices/<card>/numa_node    # expect the CA's closest node, not 0
```

**What these patches don't cover:** the performance gain is unmeasured. `gpu_optimization/WC-FINDINGS.md` shows that CPU stores to node 0 GTT with write combining lose little across NUMAlink, but it doesn't measure GPU DMA reads across NUMAlink, which is the case that matters here.

**SWIOTLB is selected but does nothing here.** `20261030-104758.log` lines 619-625 show `swiotlb_memblock_alloc` failing at every size from 64MB down to 1MB, and `pci_dma.c` never uses it. `drm_need_swiotlb()` also returns false on SN2, through your `#ifdef`. AGP doesn't depend on it either way. Restoring `select SWIOTLB if !IA64_SGI_SN2` would remove those boot errors, but I haven't built that.

## Changes since v3.0

The TIOCA-specific code is almost unchanged. `tioca_provider.c` differs by 6 lines, and `tioca.h`, `tioca_provider.h` and `asm/sn/io.h` don't differ at all. These are the differences that matter here:

| Change | Commit | Effect |
| --- | --- | --- |
| `sgi-agp` loop conversion | `0a4af1473a7d` (2012) | Problem 1. v3.0 still used `pci_dev_b()` |
| `sn_pci_window_fixup()` removed | `c60fb074c0ba` (2013) | v3.0 gave the PCI core one offset per BAR. Now `pcibios_resource_to_bus()` and `pci_bus_address()` return the CPU address for SN2 BARs. This affects problems 4 and 5, and it's prior art for Option B in `prom/PREFETCH-WINDOW.md` |
| ROM flags changed, `pci_disable_rom()` added | `240504adaf07` (2016) | Problem 5 |
| `res->start` is the raw PROM value | | v3.0 ORed `__IA64_UNCACHED_OFFSET` into the address. That is why old listings show `0xc000...` and yours show `0x8000...`. The low 32 bits are the same |
| `sn_dma_ops` on PCI devices only, NULL `pcidev_info` checks | Your port | `tioca_dma_*` is reached only from `pci_dma.c` and `msi_sn.c`, and `pci_dma.c` checks first |

`radeon` AGP on TIOCA has no working baseline. v3.0 avoids problem 1, but its code has problems 2, 3 and 4 too. `r300_mc_init()` and `sgi_tioca_agp_enable()` are the same there as today. For problem 5, v3.0 didn't clear the ROM enable bit, but it didn't set it either.

## Bring-up order

Each stage needs the one before it.

**Stage 0: capture state.** Add the instrumentation below and boot with `sgi-agp` not loaded. Settle problem 5 here.

**Stage 1: PCI mode.** Apply fix 4 and boot with `radeon.agpmode=-1`.

`radeon_agp_disable()` selects PCI mode for R300, R350, RV350 and R420, and all DMA then goes through the CA PCI GART. That gives 1GB of reach, against the PIC's 16MB of ATEs. R420 tries MSI in this mode, `tioca_dma_map()` rejects it, and `radeon` falls back to INTx. Add `radeon.msi=0` to skip that.

Expect `VRAM: 128M 0x0000000000000000` and a passing ring test. `r100_pci_gart_tlb_flush()` is still an empty TODO, so try the R100 guide's Fix 4 if you see stale GTT data.

If `sgi-agp` simply isn't loaded, `radeon` falls back to the same mode by itself, logging `Unable to acquire AGP: -19`.

**Stage 2: `sgi-agp` loads.** Apply fix 1. Expect `SGI TIO CA GART driver initialized` and `AGP aperture is 1024M @ 0x80000000`.

There is no module autoload, so add this to modprobe config:

```
softdep radeon pre: agpgart sgi-agp
```

**Stage 3: AGP.** Apply fixes 2 and 3 and boot with `radeon.agpmode=4` or `8`. Expect `GTT: 1024M 0x0000000080000000 - 0x00000000BFFFFFFF`, then a passing ring and IB test.

`radeon` clears FastWrite, so it starts off, and that's the lower-risk setting. `bridge->mode` advertises 8x only, while `radeon` accepts 4 or 8. `tagp` always used 8x.

If the card hangs on first DMA, the most useful inputs are `AGP_COMMAND`, `ca_control1`, `ca_gart_err` and `ca_pcierr_type`.

## Instrumentation

Add this at the end of `tioca_bus_fixup()`:

```c
// [DEBUG INSTRUMENTATION]
{
	struct tioca __iomem *ca = (void __iomem *)tioca_common->ca_common.bs_base;

	printk(KERN_INFO "TIOCA rev %u nasid %u id %llx ctl1 %llx ctl2 %llx st1 %llx st2 %llx\n",
	       tioca_common->ca_rev, tioca_common->ca_closest_nasid,
	       readq(&ca->ca_id), readq(&ca->ca_control1), readq(&ca->ca_control2),
	       readq(&ca->ca_status1), readq(&ca->ca_status2));
	printk(KERN_INFO "TIOCA ap %llx ptr %llx mask %llx pciext %llx agpext %llx\n",
	       readq(&ca->ca_gart_aperature), readq(&ca->ca_gart_ptr_table),
	       readq(&ca->ca_int_mask), readq(&ca->ca_pci_dma_addr_extn),
	       readq(&ca->ca_agp_dma_addr_extn));
}
```

Add this in `radeon_device_init()` after the registers are mapped:

```c
// [DEBUG INSTRUMENTATION]
{
	u32 bar0, bar1, bar2, cmd, st = 0, ac = 0;
	int cap = pci_find_capability(rdev->pdev, PCI_CAP_ID_AGP);

	pci_read_config_dword(rdev->pdev, PCI_BASE_ADDRESS_0, &bar0);
	pci_read_config_dword(rdev->pdev, PCI_BASE_ADDRESS_1, &bar1);
	pci_read_config_dword(rdev->pdev, PCI_BASE_ADDRESS_2, &bar2);
	pci_read_config_dword(rdev->pdev, PCI_COMMAND, &cmd);
	if (cap) {
		pci_read_config_dword(rdev->pdev, cap + PCI_AGP_STATUS, &st);
		pci_read_config_dword(rdev->pdev, cap + PCI_AGP_COMMAND, &ac);
	}
	dev_info(rdev->dev, "BAR0 %08x BAR1 %08x BAR2 %08x CMD %08x AGPST %08x AGPCMD %08x res0 %pa\n",
		 bar0, bar1, bar2, cmd, st, ac, &rdev->pdev->resource[0].start);
	dev_info(rdev->dev, "FB_LOC %08x AGP_LOC %08x AGP_BASE %08x AGP_CNTL %08x APER0 %08x MEMSIZE %08x\n",
		 RREG32(0x148), RREG32(0x14c), RREG32(0x170), RREG32(0x174),
		 RREG32(0x100), RREG32(0xf8));
}
```

This tests the ROM (problem 5). Put it in the same place, and only on a card that has a ROM resource. A PIO read of a disabled ROM may raise a CA error, so run it after capturing the lines above:

```c
// [DEBUG INSTRUMENTATION]
{
	struct resource *rom = &rdev->pdev->resource[PCI_ROM_RESOURCE];
	void __iomem *p;
	u32 rb;

	pci_read_config_dword(rdev->pdev, rdev->pdev->rom_base_reg, &rb);
	dev_info(rdev->dev, "ROM res %pR ROM BAR %08x\n", rom, rb);
	p = ioremap(rom->start, 4096);
	if (p) {
		dev_info(rdev->dev, "ROM off: %02x %02x\n", readb(p), readb(p + 1));
		pci_write_config_dword(rdev->pdev, rdev->pdev->rom_base_reg, rb | 1);
		dev_info(rdev->dev, "ROM on:  %02x %02x\n", readb(p), readb(p + 1));
		pci_write_config_dword(rdev->pdev, rdev->pdev->rom_base_reg, rb);
		iounmap(p);
	}
}
```

These lines settle the open items: BAR values, the address decode, `AGP_ENABLE`, calibration state, and whether the ROM is a shadow or a disabled BAR.

On the live box, the PROM's POD mode has `tioca list`, `tioca dump`, `tioca dma`, `tioca op` and `tioca tlb`. sscope already has the `TIO_CA_*` and `TIO_ICE_FRZ_*` register names for errdmp work.

## Lower priority

- `tioca_dma_mapped()` stores an unaligned `xio_addr` in the first GART entry (`tioca_provider.c:432`), so bits 13:12 can be set when `ca_ap_pagesize` is 16KB. Mask with `~(ps - 1)`. 2.6.5 did the same, and it needs a mapping with a sub-page offset to matter.
- `tioca_dma_unmap()` walks a linear list, and `tioca_dma_map()` allocates per mapping with `GFP_ATOMIC`. PCI mode with a large GTT will be slow here.
- `BUG_ON(map == NULL)` in `tioca_dma_unmap()` can't fire, because `list_for_each_entry()` never yields NULL.
- Two pipes mean two CAs and two bridges. `sgi_tioca_fetch_size()` and `sgi_tioca_alloc_page()` use the global `agp_bridge`. The sizes match, so it's harmless for binding, but test one card first.
- ImageSync, CBOB and hyperpipe are not needed to get a display.

## Limits of this analysis

- Nothing here has been run. Problems 1, 2 and 4 come from reading source, and their failure modes are predictions.
- `AGP_ENABLE` is unresolved. The patch handles both outcomes.
- Problem 5 is inferred from history and the R100 notes. Whether this PROM ever shadows a ROM is unknown.
- `tagp` tests R3xx cards, and it's a diagnostic rather than a driver. Its register values are proof of what worked in that test, not of what fglrx programmed. I did not trace the X driver's MC layout in full.
- PROM findings are from SAL 4.53. `tagp` is from the 4.56 SMDK set.
- The `lspci` decode is inferred from a single old listing.
