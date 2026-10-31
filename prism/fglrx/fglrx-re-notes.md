# fglrx and TIOCA reverse engineering notes

This is the evidence behind [TIOCA-AGP-HANDOFF.md](TIOCA-AGP-HANDOFF.md). It covers corrections to the older notes, what `fglrx.ko` does on SN2, and how to rebuild the working files.

## Sources

| Source | Where | Notes |
| --- | --- | --- |
| `fglrx.ko` | `altix_cross/sn2-kernel-tools/radeon/fglrx/`, same bytes as the RPM | Unstripped, but relocations are needed to resolve calls |
| `fglrx_drv.o` | `fglrx-4_3_99_8.12.1-sgi403r1.ia64.rpm` | X driver, unstripped, includes CAIL |
| 2.6.5 rtgfx kernel | `kernel-rtgfx-source-2.6.5-7.244.ia64.rpm` | Source for `sgi-agp`, `tioca_provider`, machvec headers |
| `tagp.mdk` | `prom/stand/boot/efi/sgi/smdk/` | SGI's AGP diagnostic: 1010 functions, nested gzip ELF |
| PROM 4.53 | `prom/proms/` | Raw stage, SAL and EFI |
| `sg2flash` RPM | `prom/rpms/` | SGI VBIOS images |

RPMs are in `/mnt/nfs/altix/propack4/cd3/sgi/ia64/`.

The existing `fglrx-disasm.txt` has no relocations, so every call appears as a branch to itself (`br.call b0=b910`). Use `objdump -dr`.

## Corrections to the older notes

These apply to `sgi-prism-fglrx-reverse-engineering.md`, `sgi-prism-fglrx-tioca-analysis.md` and `sgi-prism-rtgfx-analysis.md`. Those files were not edited. There are copies in both `radeon/fglrx/` and `docs/`.

| Older claim | What the code shows |
| --- | --- |
| The 32-bit DMA mask is the "single most important finding" and is set "before every DMA map" | `pci_set_dma_mask` has **one** call site, in `__ke_pci_alloc_consistent` at `b91c`. `__ke_pci_map_single` and `__ke_pci_map_page` don't set it. The handle is stored with `st4 [r34]=r8` at `b960`, so ATI's API holds a 32-bit handle. That likely explains the mask. `radeon` already uses 32 bits here |
| `dep r35=-1,r35,61,3` makes an uncached address | It makes `0xe000...`, the **cached** identity map. Uncached is `0xc000...`, which `__ke_ioremap` uses at `986`. The "consistent" buffer is cached memory |
| fglrx "bypasses the standard DMA API" | `machvec_sn2.h` defines `platform_dma_map_single` as `sn_dma_map_single`. An SN2-only build of `pci_map_single()` compiles to that symbol. It isn't a technique |
| Every I/O read has a special DMA flush, and every write an `mmiowb` | Same cause. `__ke_inl` and `__ke_outl` are `___sn_inl` and `___sn_outl` from `asm/sn/io.h`, which still does this today |
| fglrx "wraps every MMIO write sequence with `__sn_mmiowb()`" | There are 4 call sites: `__ke_out[bwl]` and `__ke_flush_io`. Register writes through the mapped BAR don't call it. Unlock wrappers call `__ke_flush_io` |
| Two `writel`s may reach the GPU reversed, so add `mmiowb()` between them | Nothing in fglrx shows this. `mmiowb` orders writes between CPUs at lock release, and ia64 `arch_spin_unlock` already does it |
| `dma_rmb()` or `dma_sync_*` replace `sn_dma_flush()` | They don't. It's already inside `___sn_readl` |
| `__ke_mtrr_add_wc` is "critical for performance" | `__ke_mtrr_add_wc` and `__ke_mtrr_del` are stubs returning -1, and `__ke_config_mtrr` returns 0. There is no WC on SN2 |
| fglrx allocates from the node closest to the TIOCA | `__ke_firegl_snia_closest_node` returns 0, so always node 0, with a fallback to `alloc_pages_current`. The strings claim more than the code does |
| `fglrxFindMasterNodeId` is used to find the CA's node | It runs only if `is_tioca` is 0, and `is_tioca` always returns 1. It is dead code here |
| `sn_attach_bdata` allocates and records platform state | It also touches the hardware. See below |
| AGP GART is 2GB, total aperture 4GB, `ca_gfxap_size = 2GB` | Each GART is 1GB, and the aperture is 2GB. The `/* 2GB */` comments in `tioca.h` are stale. The doc's diagram order is also wrong |
| `sgi-agp` "doubles" GART space, and no `sgi-agp` risks failure | `radeon` falls back to PCI mode by itself. That is the recommended first step |
| A 128MB framebuffer uses 32768 GART entries | VRAM isn't mapped through the GART. The BAR is reached by PIO |
| No SGI-specific driver changes are needed | See the five problems in the handoff |
| VBIOS risk is non-standard ATOM tables | Only the R420 image is ATOM. R300, R350 and RV350 are COMBIOS. The nearer risk is reading the ROM at all, handoff problem 5 |
| `radeon` handles Prism via "standard kernel DMA APIs" transparently | True for `dma_map`, but the TTM AGP path fails, as handoff problems 1 and 2 show |

## What fglrx.ko does on SN2

### `sn_attach_bdata` (`0x44650`)

1. Allocates a 72-byte `bdata` and stores it in `fglrx_boards[]`, with up to 64 boards.
2. Reads BAR0 from config space, masks with `~0xf`, and stores it as `fb_base` at `+24`. This is the bus address, unlike the two below.
3. Stores `pci_resource_start(0)` as `mem_addr` at `+8`, and `pci_resource_start(2)` as `reg_addr` at `+16`.
4. Reads `PCI_COMMAND`, writes it back with Memory Space set, writes `0x17` to GPU register `0x4018`, then restores `PCI_COMMAND`.
5. Calls `is_tioca` (always 1), stores it at `+40`, then `closest_node` (always 0), and stores that at `+28`.

The debug string for `cfg_addr` prints `mem_addr`: `+8` is loaded for both.

Register `0x4018` is `R300_GB_TILE_CONFIG`, so `0x17` is `ENABLE_TILING | PIPE_COUNT_R300 | TILE_SIZE_16`. I don't know why SGI writes this here. `r420_pipes_init()` sets this register anyway, so I didn't carry it into the patch.

Step 4 shows that fglrx expects Memory Space may be off at this point, so check that `pci_enable_device()` has really set it. `fb_base` is printed and shown by the KDB dump. I didn't trace any other use.

### Mapping: `__ke_vm_map` (`0x7980`)

The `type` argument indexes a 7-entry jump table at `.rodata+0x1a8`:

| Type | `vm_ops` | Attribute handling |
| --- | --- | --- |
| 0 | None, `remap_page_range` | See below |
| 1 | `vm_shm_nopage` | Unchanged |
| 2, 3 | `vm_dma_nopage` | Unchanged |
| 4, 5 | `vm_cant_nopage` | Unchanged |
| 6 | `vm_pcie_nopage` | Unchanged |

Type 0 is the only path that changes the memory attribute: `and r3=-29,r10; or r43=16,r3` sets `ma = 4`, UC. It skips that if the page is normal RAM, tested with `max_low_pfn`, `ia64_pfn_valid` and `PG_reserved`. No other place in the module edits `vm_page_prot` this way, apart from clearing the write bit for read-only maps.

So I/O is UC and RAM keeps its default WB. `vm_cant_nopage` is the `cant_use_aperture` path: `firegl_get_virt_agp_mem` looks up the page in `agp_memory`, and the fault returns its `struct page`.

### AGP path

`_firegl_agp_acquire` runs `__ke_agp_available`, `__ke_agp_copy_info`, `firegl_init_aperture`, then the MTRR stubs. `__ke_agp_*` wrappers look up the bridge through the exported `agp_find_bridge`, then call through the `drm_agp` table from `inter_module_get`.

`drm_agp_enable` calls `__ke_agp_enable`, then `_r6x_CheckAGPCommand`. That function tests bit 8 of `AGP_COMMAND` and returns 1 either way, unless the capability read fails.

The X driver's `R200DRIScreenInit` runs `firegl_AGPAcquire`, `drmAgpGetMode`, `drmAgpEnable`, `drmAgpSize`, `drmAgpBase`, then `firegl_GetAGPCommand`. `R200GetBoardNumberFromScreen` holds the string `sgi-agp`, so the X side loaded that module by name.

`fglrx_drv.o` options that may matter: `ForceAGPFastWriteON`, `DisableAGPFW`, `DisableAGP`, `DisableAGPWrite`, `DisableAGPCalibrationFix`, `AgpLevel`.

## tagp

Source paths are `offline2/diags/io/tio/tagp/`, `offline2/diags/io/libio/libFGL/` and others. The version string is `tagp version 0.5.7m`. It prints `NOTE: ATI R3xx cards are needed to test the AGP interface.`

| Function | Address (low bits) | What it does |
| --- | --- | --- |
| `caBdgInit` | `55340` | Resets CA control and error registers |
| `tagpDevInit` | `23300` | Programs BARs and COMMAND directly |
| `biosemu` | `56ed0` | POST through `xf86InitInt10`, `xf86ExecX86int10` |
| `EnableAGPFW` | `28640` | `ca_control1 |= 0x40`, `AGP_COMMAND |= 0x80006312` |
| `caSetAddrExtn` | `56230` | Writes `ca_pci_dma_addr_extn` or `ca_agp_dma_addr_extn` |
| `caAgp48DirMapAddr` | `560f0` | AGP direct address, using extension bits 35:20 |
| `caPci64DirMapAddr` | `560c0` | `(addr & 0x3fffffffff) | 1<<60` |
| `tagpGARTInit` | `2b140` | Table, pointer, aperture, TLB flush, mem param, prefetch |
| `R300DmaInit` | `c18c0` | MC setup, then `Enable_Accel_Op`, `Reset_CP`, `Init_GUIEngine` |
| `R300DmaAgp` | `c1e90` | GUI DMA over AGP |
| `R300DmaPci` | | The same over PCI |

`ca_control2 = 0x611fff0c00000000` decodes as `CRM_MAX_CREDIT = 6`, `TNUMTO_ENB`, `TNUMTO_PERIOD = 0x1fff`, and both GART prefetch enables. `tagpAGPDmaBasicSSec2` then overrides prefetch. That test also uses a 32MB aperture at `0xc0000000`, 4KB CA pages, and `CA_GART_MEM_PARAM = 2`. The kernel disables prefetch for PV930029.

`R300DmaInit` depends on the DMA mode at the start of the DMA struct:

| Mode | `AGP_BASE` | `MC_AGP_LOCATION` |
| --- | --- | --- |
| 1 | `0x0ffffffc` | `0xdfffd800` |
| 5 | `0xfffffffc` | `0xdfffd800` |
| Others, including 3 | `0x08000000` | `0xdfff0800` |

The write at `nasid<<38 | 0x48b0008800` is `TIO_ICE_FRZ_PIO_BIG_WINDOW_1`, with value `0x10001 | (ca << 12)`. After it, `0xc000000040000000 | nasid<<38` plus BAR0 is the CPU address of VRAM. So big window 1 reaches CA PIO offset `0x40000000`, `CA_PIO_PCI_MEM`.

Other CPU routes it uses: `caBase + 0x08000000 + BAR2` for registers, through `CA_PIO_PCI_MEM_OFFSET`.

Section 16 of `tagp` warns that one subsection resets the CA, `PV 909366`.

## PROM and EFI

- `ca_discover` is at raw `0xecc00` in 4.53. It ignores rev 1 parts, probes one slot with a helper at raw `0xeca50`, and calls `init_klcfg_vgagfx` at raw `0xec700`.
- `tioca_soft_s` fields are in the POD dump strings at raw `0x1a8bd0`: `ca_rev`, `ca_nasid`, `ca_base`, `ca_int_mask`, `ca_io_mca_ignored`, `ca_piomaps` and others.
- The compile line shows `-DIOBOARD=TIO -DCONFIG_TIO -DTIO_CX_CLOCK_RESET_WAR`.
- `pci_cfg_write_w` at raw `0xedb60` has one direct caller, so my audit for writes to the AGP capability found nothing either way.
- `post_vbios` is at `0xbcdf0` in the EFI ELF. Its strings are `post_bios(): Couldn't locate IO BAR for ...`, `post_vbios() ... starting emulator` and `done posting VBIOS`.

`SH_GFX_*` in Shub and `TIO_ICE_FRZ_GFX_BIG_WINDOW_*` in TIO are a dedicated graphics-write path with credits. Linux doesn't use it, and neither does anything I read in `fglrx.ko`. It's only relevant to later PIO performance work.

## Rebuilding the working files

The scripts in `tools/` are scratch tools, kept as used. They take paths as arguments, except that `rawv.py` runs from the PROM working directory, and reads `raw11.bin`, `raw.dis` and `rawnames.json` as built by [prom-format.md](../prom/prom-format.md). Run them with `python3 -I`, and keep extracted files in their own directory.

```sh
OD=~/projects/altix_cross/tools/gcc-16.2.0-nolibc/ia64-linux/bin/ia64-linux-objdump

# fglrx.ko and fglrx_drv.o
$OD -dr fglrx.ko > fglrx.rdis
python3 -I tools/fn.py fglrx.rdis fglrx.ko sn_attach_bdata __ke_vm_map

# tagp: gzip, then a nested gzip ELF at offset 550016 in the unpacked file
python3 -I -c "
import gzip,zlib
d=gzip.open('tagp.mdk').read()
open('tagp.elf','wb').write(zlib.decompressobj(31).decompress(d[550016:]))"
$OD -d tagp.elf > t.dis
python3 -I tools/tf.py tagp.elf t.dis caBdgInit R300DmaInit

# PROM SAL or EFI ELF: elf, disassembly, gp, start, end
python3 -I tools/ev.py gz_snprom-4.53-IP41_275e10.bin efi.dis 434000 bcdf0 bd230

# PROM raw stage
python3 -I tools/rawv.py ecbe0 ece50
```

To compile the patch out of tree:

```sh
export PATH=~/projects/altix_cross/tools/gcc-16.2.0-nolibc/ia64-linux/bin:$PATH
cp ~/projects/altix_cross/src/mainline/linux-sn2/.config $O/.config
make O=$O ARCH=ia64 CROSS_COMPILE=ia64-linux- olddefconfig
make O=$O ARCH=ia64 CROSS_COMPILE=ia64-linux- prepare
make O=$O ARCH=ia64 CROSS_COMPILE=ia64-linux- drivers/char/agp/sgi-agp.o drivers/gpu/drm/radeon/r300.o
```
