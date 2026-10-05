# fglrx Driver Architecture and TIOCA/AGP/GART Interaction on SGI Altix Prism

## Overview

This document provides a detailed technical analysis of the proprietary
ATI fglrx driver (`km-rtgfx-fglrx-2.6.5-7.244sgi403r1.ia64.rpm`) as
shipped for the SGI Altix Prism, and how it interacts with the TIOCA ASIC,
AGPGART subsystem, and GART address translation hardware.  The purpose is
to document the full DMA and address translation path for GPU operations
on SN2, which is relevant to diagnosing why PCI video cards may fail to
operate correctly on this platform.

**File analyzed:** `fglrx.ko` (924,387 bytes, ELF 64-bit IA-64, not stripped)

---

## TIOCA Address Space Architecture

The TIO CA (TIOCA) ASIC bridges from the SGI NUMAlink fabric to AGP/PCI
bus.  Its bus address space is divided into several regions, defined in
`include/asm-ia64/sn/tioca.h`:

```
    0xFFFF_FFFF_FFFF     +--------
                         | AGP 48-bit direct
                         | (for devices with 48-bit DMA mask)
    CA_AGP_DIRECT_BASE   +--------     0x4000_0000 (1GB)
      (0x40000000)       |
                         | AGP GART mapped (gfx aperture)
                         | Managed by /dev/agpgart (sgi-agp.ko)
                         | 2GB region
    CA_AGP_MAPPED_BASE   +--------     0x8000_0000 (2GB)
      (0x80000000)       |
                         | PCI GART mapped
                         | Managed by tioca_provider.c
                         | 1GB region
    CA_PCI32_MAPPED_BASE +--------     0xC000_0000 (3GB)
      (0xC0000000)       |
                         | PCI32 direct  *** BROKEN — SIZE = 0 ***
                         |
    0xC000_0000          +--------
    (CA_PCI32_DIRECT_BASE)
```

### Critical: PCI 32-bit Direct DMA is Broken

From the source comment in `tioca.h` (dated 11/24/03):

> CA has an addressing glitch w.r.t. PCI direct 32 bit DMA that makes
> it generally unusable.  The problem is that for PCI direct 32 DMA's,
> all 32 bits of the bus address are used to form the lower 32 bits of
> the coretalk address, and coretalk bits 38:32 come from a register.
> Since only PCI bus addresses 0xC0000000-0xFFFFFFFF (1GB) are available
> for DMA (the rest is allocated to PIO), host node addresses need to be
> such that their lower 32 bits fall in the 0xC0000000-0xffffffff range
> as well.  So there can be no PCI32 direct DMA below 3GB!!

As a result, `CA_PCI32_DIRECT_SIZE` is set to **0**.  All 32-bit PCI DMA
must go through the GART.  This is configured in `tioca_provider.c`:

```c
/* tioca_dma_map() — the main DMA routing function */

if (pdev->dma_mask == ~0UL)
    mapaddr = tioca_dma_d64(paddr);        /* 64-bit direct */
else if (pdev->dma_mask == 0xffffffffffffUL)
    mapaddr = tioca_dma_d48(pdev, paddr);  /* 48-bit direct */
else
    mapaddr = 0;                           /* 32-bit: no direct */

/* Last resort ... use PCI portion of CA GART */
if (mapaddr == 0)
    mapaddr = tioca_dma_mapped(pdev, paddr, byte_count);
```

**This means any PCI device with a 32-bit DMA mask — which includes
essentially all AGP-era and most PCIe-era GPUs — must have every DMA
operation translated through the TIOCA's GART.**

### DMA Mode Summary

| DMA Mode | DMA Mask Required | Method | Managed By |
|---|---|---|---|
| 64-bit direct | `0xFFFFFFFFFFFFFFFF` | Coretalk address with cache-coherent bit set | `tioca_dma_d64()` |
| 48-bit direct | `0xFFFFFFFFFFFF` | Node ID + chiplet ID + offset encoding | `tioca_dma_d48()` |
| PCI GART mapped | Any (fallback) | GART translation table, bitmap allocator | `tioca_dma_mapped()` |
| AGP GART mapped | N/A | AGP aperture, managed by agpgart subsystem | `sgi-agp.ko` via `/dev/agpgart` |

The PCI GART region is 1GB (`CA_PCI32_MAPPED_SIZE = 0x40000000`).
The AGP GART region is 2GB (`CA_AGP_MAPPED_SIZE = 0x40000000`).
Together they form the 4GB TIOCA aperture.

---

## GART Translation Mechanics

### GART Entry Format

Defined in `include/asm-ia64/sn/tioca_provider.h`:

```c
static inline u64 tioca_paddr_to_gart(unsigned long paddr)
{
    /* paddr is a coretalk address with NODE_ID, CHIPLET_ID,
       and SYS_ADDR in the correct bit positions */
    return ((paddr) >> 12) | (1UL << 63);
}
```

Each GART entry is a 64-bit value:
- Bits 25:0 — `REMAP_SYS_ADDRESS[37:12]`
- Bits 27:26 — SHUB MD chiplet ID
- Bits 41:28 — `REMAP_NODE_ID`
- Bit 63 — Valid bit

This maps a single page (4KB or 16KB, depending on `ca_ap_pagesize`)
from PCI/AGP bus address space to a physical address anywhere in the
NUMAlink fabric.

### GART TLB Flush

The TIOCA caches GART entries in a hardware TLB.  After modifying GART
entries, the TLB must be flushed.  RevA silicon has a bug (PV910244)
where flush doesn't work in cached/coherent mode, requiring a workaround
that temporarily switches to uncached mode:

```c
/* From tioca_provider.h — tioca_tlbflush() */

if (tioca_kernel->ca_gart_iscoherent) {
    if (TIOCA_WAR_ENABLED(PV910244, tioca_common)) {
        /* RevA: switch to uncached, flush, switch back */
        __sn_clrq_relaxed(&ca_base->ca_control2, CA_GART_MEM_PARAM);
        __sn_setq_relaxed(&ca_base->ca_control2, CA_GART_FLUSH_TLB);
        __sn_setq_relaxed(&ca_base->ca_control2,
            (0x2ull << CA_GART_MEM_PARAM_SHFT));
    }
    return;
}

/* Uncached mode: explicit flush */
__sn_setq_relaxed(&ca_base->ca_control2, CA_GART_FLUSH_TLB);
```

### GART Prefetch Bug

GART prefetching is **disabled** due to hardware bug PV930029:

```c
/* From tioca_provider.c — tioca_gart_init() */

/* DISABLE GART PREFETCHING due to hw bug tracked in SGI PV930029 */
__sn_clrq_relaxed(&ca_base->ca_control2,
    (CA_GART_WR_PREFETCH_ENB | CA_GART_RD_PREFETCH_ENB));
```

---

## Two Separate GARTs: PCI vs AGP

The TIOCA maintains a single physical GART table in memory, but it is
logically split into two regions:

### PCI GART (managed by `tioca_provider.c`)

- Base: `CA_PCI32_MAPPED_BASE` (0xC0000000)
- Size: 1GB
- Used for: all standard PCI DMA from any device behind the TIOCA
- Allocation: bitmap allocator (`ca_pcigart_pagemap`)
- Managed by: `tioca_dma_mapped()` / `tioca_dma_unmap()`
- Transparent to drivers — they call `dma_map_single()` etc. and the
  SN2 platform layer routes through this GART automatically

### AGP GART (managed by `sgi-agp.ko`)

- Base: `CA_AGP_MAPPED_BASE` (0x80000000)
- Size: 2GB
- Used for: AGP graphics operations (textures, command buffers, etc.)
- Allocation: managed by the Linux AGPGART subsystem
- Interface: `/dev/agpgart` character device
- Client: GPU driver (fglrx or DRM radeon) requests AGP memory via
  `agp_allocate_memory()`, `agp_bind_memory()`, etc.

The two GARTs share the same physical GART table (`ca_gart`) but operate
on different index ranges (`ca_pcigart_start` vs `ca_gfxgart_start`).

---

## fglrx Internal Architecture

### Kernel Abstraction Layer (KAL)

fglrx implements a massive kernel abstraction layer of 203 `__ke_*`
functions that wrap every kernel API call.  This makes the proprietary
core portable across kernel versions and architectures.  Examples:

| KAL Function | Wraps |
|---|---|
| `__ke_pci_map_single()` | `sn_dma_map_single()` on SN2 |
| `__ke_pci_unmap_single()` | `sn_dma_unmap_single()` on SN2 |
| `__ke_ioremap()` | `ioremap()` |
| `__ke_virt_to_phys()` | `virt_to_phys()` |
| `__ke_get_free_pages()` | `__get_free_pages()` |
| `__ke_agp_acquire()` | `agp_backend_acquire()` |
| `__ke_agp_allocate_memory()` | `agp_allocate_memory()` |
| `__ke_agp_bind_memory()` | `agp_bind_memory()` |
| `__ke_firegl_snia_is_tioca()` | SGI-specific TIOCA detection |
| `__ke_firegl_snia_closest_node()` | NUMA node lookup for GPU |

### Dual AGP Stack

fglrx contains **two complete AGP implementations**:

**1. Built-in AGP stack (`__fgl_agp_*` functions, `firegl_agpgart.c`)**

A complete copy of the Linux AGPGART subsystem compiled into fglrx.
Includes chipset-specific backends (visible as `ali_cleanup`,
`amd_irongate_cleanup`, `amd_8151_cleanup` symbols).  Can operate
independently of the kernel's agpgart module.

**2. Kernel AGP path (`__ke_agp_*` functions)**

Calls through to the kernel's agpgart subsystem, which on SN2 routes
to `sgi-agp.ko` → TIOCA hardware.

The selection logic works as follows (reconstructed from strings):

```
1. Check if kernel AGP is loaded (agpgart.ko present)
2. If yes:
   → "Internal AGP support requested, but kernel AGP support active."
   → "Have to use kernel AGP support to avoid conflicts."
   → Use kernel AGP path
3. If no:
   → Try built-in AGP
   → If built-in fails (e.g., unknown chipset like TIOCA):
     → "Initialization of built-in AGP-support failed (ret=%d)."
     → "Have to use kernel AGP support, but module parameters forbid that"
     → FATAL: driver cannot initialize
```

**On SN2/TIOCA, the kernel AGP path is mandatory** because the built-in
AGP stack has no TIOCA backend.  This is why `agpgart.ko` and `sgi-agp.ko`
must be loaded before fglrx.

### SN2-Specific DMA Path

fglrx on SN2 bypasses the standard Linux DMA API and calls SN2 platform
functions directly.  External symbols imported:

```
U  sn_dma_map_single      ← maps host physical → PCI bus address
U  sn_dma_unmap_single     ← releases DMA mapping
U  sn_dma_flush            ← flushes DMA write buffers
U  sn_io_addr              ← translates PIO addresses
U  __sn_mmiowb             ← memory-mapped I/O write barrier
U  physical_node_map       ← NUMA topology
U  numnodes                ← NUMA node count
```

A stock ATI fglrx would use `pci_map_single()` / `dma_map_single()`,
which on a standard platform goes directly to the IOMMU or bounce
buffers.  On SN2, those standard APIs are routed through the platform's
`sn_pcibus_provider` → `tioca_dma_map()` anyway — but fglrx skips
that abstraction and calls the SN2 functions directly.

The `firegl_snia.c` adaptation layer provides:

| Function | Purpose |
|---|---|
| `__ke_firegl_snia_is_tioca()` | Returns true if the PCI bus provider for this device is TIOCA |
| `__ke_firegl_snia_closest_node()` | Returns the NUMA node closest to the TIOCA, for memory allocation affinity |
| `sn_attach_bdata()` | Attaches SGI bridge data to fglrx's device structure |
| `sn_destroy_bdata()` | Cleans up SGI bridge data |
| `sn_get_reg_address()` | Looks up register addresses through SN2's PIO mapping |

### ATI PCI GART (Internal)

In addition to the TIOCA's hardware GART, fglrx has its own software
GART implementation (`ati_pcigart`):

```
"Failed to allocate page for ATI GART"
"atigart is not mapped"
"Invalid gart location"
"no space in GART aperture!"
```

This is used on platforms where hardware AGP GART isn't available.  On
the Prism, fglrx would use the TIOCA's hardware GART (via the kernel AGP
path) for AGP operations, but may use the ATI PCI GART for additional
software-managed address translation.

### PCIe GART Path

fglrx also includes a complete PCI Express GART implementation:

| Function | Purpose |
|---|---|
| `firegl_init_pcie()` | Initialize PCIe GART |
| `firegl_bind_pcie()` | Bind pages to PCIe GART |
| `firegl_unbind_pcie()` | Remove PCIe GART bindings |
| `firegl_pcie_alloc()` | Allocate PCIe GART entries |
| `firegl_update_pcie_gart_table()` | Write GART entries |
| `drm_alloc_pcie()` | DRM-level PCIe allocation |

This path is not used on the Prism (which is AGP, not PCIe) but
indicates fglrx was designed for multiple bus types.

---

## Module Loading and Initialization Sequence

### Required Load Order

```
Boot:
  1. tioca_provider.c (built-in, obj-y)
     └─ Discovers TIOCA ASICs on NUMAlink fabric
     └─ Initializes GART hardware (programs ca_gart_aperature MMR)
     └─ Sets up PCI GART bitmap allocator
     └─ Exports: tioca_gart_found, tioca_list, tioca_fastwrite_enable
     └─ Registers as sn_pci_provider[PCIIO_ASIC_TYPE_TIOCA]

Must load before fglrx:
  2. agpgart.ko
     └─ AGP core subsystem
     └─ Provides: agp_alloc_bridge, agp_add_bridge, agp_find_bridge
     └─ Creates /dev/agpgart (char-major-10-175)

  3. sgi-agp.ko (depends on agpgart.ko)
     └─ Reads tioca_gart_found and tioca_list from tioca_provider
     └─ For each TIOCA with VGA devices:
        └─ Allocates AGP bridge structure
        └─ Configures AGP 3.0 mode (8x, FW, SBA, 64-bit)
        └─ Registers bridge with agpgart core via agp_add_bridge()
     └─ Sets agp_find_bridge = sgi_tioca_find_bridge
     └─ AGP bridge is now available for GPU drivers

GPU driver:
  4. fglrx.ko (depends on agpgart.ko)
     └─ Detects kernel AGP is active
     └─ Calls __ke_firegl_snia_is_tioca() to identify platform
     └─ Uses kernel AGP path (not built-in AGP)
     └─ Acquires AGP bridge via agp_find_bridge → sgi_tioca_find_bridge
     └─ Allocates/binds AGP memory through agpgart → sgi-agp → TIOCA GART
     └─ DMA operations via sn_dma_map_single → tioca_dma_map → GART
```

### Why sgi-agp Cannot Auto-Load

`sgi-agp.ko` contains:

```c
module_init(agp_sgi_init);
module_exit(agp_sgi_cleanup);
MODULE_LICENSE("GPL and additional rights");
```

There is **no `MODULE_DEVICE_TABLE`**.  The TIOCA is not a PCI device
(it's a NUMAlink ASIC), so there is no PCI ID for udev to match.  The
module must be loaded explicitly via initrd configuration, modprobe
softdep, or manual `modprobe sgi-agp`.

---

## AGP Bridge Configuration

When `sgi-agp.ko` initializes, it configures each AGP bridge with
specific capabilities (from `sgi-agp.c`):

```c
sgi_tioca_agp_bridges[j]->mode =
    (0x7D << 24) |    /* 126 outstanding requests */
    (0x1 << 9)  |     /* SBA (Sideband Addressing) supported */
    (0x1 << 5)  |     /* 64-bit addresses supported */
    (0x1 << 4)  |     /* FastWrite supported */
    (0x1 << 3)  |     /* AGP 3.0 mode */
    0x2;              /* 8x transfer rate only */
```

FastWrite enablement (`tioca_fastwrite_enable`) scans all VGA-class
functions on the bus, verifies they all support FW via `PCI_AGP_STATUS`,
then enables FW on each function and the CA itself:

```c
__sn_setq_relaxed(&tioca_base->ca_control1, CA_AGP_FW_ENABLE);
```

### NUMA-Aware Page Allocation

The AGP bridge allocates pages from the closest NUMA node to the TIOCA:

```c
static struct page *sgi_tioca_alloc_page(struct agp_bridge_data *bridge)
{
    struct tioca_kernel *info =
        (struct tioca_kernel *)bridge->dev_private_data;
    nid = info->ca_closest_node;
    page = alloc_pages_node(nid, GFP_KERNEL, 0);
    ...
}
```

This is important for performance — GPU operations generate heavy memory
traffic, and allocating from a remote NUMA node would add latency
through extra NUMAlink hops.

---

## ImageSync and Multi-Pipe Architecture

The Prism supports multi-GPU rendering with hardware synchronization via
SGI's ImageSync system.

### ImageSync Hardware

Two PCI devices registered by fglrx:

| Vendor | Device | Description |
|---|---|---|
| `0x10A9` (SGI) | `0x100C` | ImageSync device |
| `0x10A9` (SGI) | `0x100F` | ImageSync device |

fglrx registers a PCI driver (`fglrx_isx_pci_driver`) for these devices.

### CBOB (Crossbar Output Buffer)

The CBOB hardware manages cross-pipe rendering synchronization:

| Function | Purpose |
|---|---|
| `cbob_init()` / `cbob_exit()` | CBOB lifecycle |
| `cbob_ioctl()` | Userspace control interface |
| `cbob_program_tiling()` | Configure tile-based multi-pipe rendering |
| `fglrx_cbob_send_fini()` | Finalize CBOB operations |

### Hardware Pipe Management

| Function | Purpose |
|---|---|
| `fglrx_hpipe_discover()` | Detect available hardware pipes |
| `fglrx_hpipe_bind()` | Bind a pipe to a rendering context |
| `fglrx_hpipe_config()` | Configure pipe parameters |
| `fglrx_hpipe_query_attrib()` | Query pipe capabilities |
| `fglrx_hpipe_set_attrib()` | Set pipe attributes |

### Swap Synchronization

| Function | Purpose |
|---|---|
| `fglrx_swap_ready()` | Signal swap-ready state |
| `is1_fire_swapready()` | ImageSync v1 swap trigger |
| `is1_release_swapready()` | Release swap-ready lock |
| `is1_genlock_interrupt()` | Genlock interrupt handler |
| `is2_update_swap_sample()` | ImageSync v2 swap sampling |
| `_r6x_vs_stereo_swap()` | R6x (R400) stereo swap |
| `_r6x_enable_framelock_irq()` | Enable framelock interrupt |
| `_r6x_service_irq_vsync_handler()` | VSync interrupt handler |

### ImageSync Versions

fglrx supports ImageSync v1 and v2.  The v2 upgrade message:

```
"ImageSync Version 1 is unsupported on this platform,
 contact SGI for ImageSync Version 2 upgrade information"
```

---

## Implications for Getting PCI Video Cards Working on SN2

### The Core Challenge

Every 32-bit DMA operation on TIOCA must go through the GART.  A modern
GPU driver that uses `dma_map_single()` / `dma_map_page()` will have
these calls routed through `tioca_dma_map()` → `tioca_dma_mapped()`,
which allocates GART entries from the PCI GART bitmap.

This should work transparently IF:

1. The GPU driver uses the standard Linux DMA API (not direct physical
   addresses)
2. The GART has sufficient free entries for all concurrent DMA mappings
3. The driver correctly handles DMA mapping failures
4. The DMA mask is set appropriately

### Potential Failure Points

**1. DMA Mask Issues**

If a GPU driver sets a 64-bit DMA mask (`dma_set_mask(dev, DMA_BIT_MASK(64))`),
`tioca_dma_map()` will use the `tioca_dma_d64()` direct path, which
constructs a coretalk address with the cache-coherent bit set.  This
bypasses the GART entirely.  Whether the GPU can actually use 64-bit
addresses depends on the GPU's internal address space — many older GPUs
have 32-bit or 40-bit internal address spaces regardless of what
`dma_set_mask` reports.

If the GPU's BARs are configured for 32-bit prefetchable (as in the
FireGL X3 lspci output), the GPU likely expects 32-bit DMA addresses
for framebuffer and command buffer access, even if it claims 64-bit
capability.

**2. PCI GART Exhaustion**

The PCI GART has 1GB of address space.  A GPU driver that maps large
buffers (framebuffer, textures, command rings) through `dma_map_*()` can
exhaust the GART.  When `tioca_dma_mapped()` runs out of bitmap entries:

```c
if (entry > mapsize)
    goto map_return;   /* returns bus_addr = 0 → DMA mapping failure */
```

A 128MB framebuffer alone consumes 32,768 GART entries (at 4KB pages).

**3. AGP GART vs PCI GART Confusion**

There are two separate GARTs on the TIOCA.  The standard DMA API uses
the PCI GART (managed by `tioca_provider.c`).  The AGP subsystem
(`/dev/agpgart`) uses the AGP GART (managed by `sgi-agp.ko`).  A DRM
driver like `radeon` that uses both AGP memory (for textures/command
buffers) AND standard DMA (for ring buffers, IBs) will be using both
GARTs simultaneously.

If `sgi-agp.ko` is not loaded, the AGP GART is never initialized, and
any AGP memory allocation will fail.  The DRM radeon driver will fall
back to PCI GART mode (`__MUST_HAVE_AGP = 0`), but this puts all DMA
pressure on the PCI GART's 1GB space.

**4. Write-Combine and Memory Mapping**

GPU drivers typically map the framebuffer BAR with write-combining
enabled for performance.  On IA-64, this uses `pgprot_writecombine()`.
The TIOCA should handle this correctly, but if the BAR addresses are
mapped through PIO (programmed I/O) rather than through the GART, the
address translation path is different.

The PIO path on SN2 goes through `sn_io_addr()` → TIOCA PIO registers,
which have their own address mapping separate from the GART.

**5. Interrupt Routing**

GPU drivers require MSI or legacy interrupts.  On the TIOCA, interrupts
are routed through `ca_inta_dest_addr` / `ca_intb_dest_addr` registers
to NUMAlink interrupt targets.  The TIOCA error interrupt handler
(`tioca_error_intr_handler`) uses SAL calls to defer to the PROM.  If
interrupt routing is not set up correctly during bus fixup, the GPU
driver will never receive interrupts.

**6. GPU Firmware (VBIOS) Parsing**

The radeon DRM driver reads the GPU's VBIOS from the Expansion ROM BAR
to configure outputs, clocks, and memory.  On the Prism, the Expansion
ROM is at:

```
Expansion ROM at c0000041c0120000 [disabled] [size=128K]
```

This address is in the TIOCA's PIO space.  The driver must be able to
enable and read this ROM through the SN2 PIO path.  If the VBIOS was
customized by SGI (which is reported as tribal knowledge), the ATOMBIOS
parser in the radeon driver may encounter non-standard command tables.

### Recommended Debugging Approach

1. **Check dmesg for TIOCA/GART initialization:**
   ```
   SGI TIO CA GART driver initialized.
   bridge 0 = 0x...
   ```
   If these messages are absent, `sgi-agp.ko` didn't load or
   `tioca_gart_found` was 0.

2. **Verify AGP bridge registration:**
   ```
   cat /proc/driver/agpgart
   ```
   Should show the TIOCA AGP bridge with the graphics aperture size.

3. **Check DMA mask:**
   After GPU driver loads, verify what DMA mask was set:
   ```
   cat /sys/bus/pci/devices/0000:17:00.0/dma_mask_bits
   ```

4. **Monitor GART usage:**
   Watch for `tioca_dma_mapped` failures in dmesg.  If the PCI GART
   is exhausted, DMA mappings will return 0.

5. **Verify PIO mapping:**
   Check that GPU BARs are accessible:
   ```
   lspci -vvv -s 17:00.0
   ```
   All three regions (framebuffer, I/O, MMIO) should show valid
   addresses in the TIOCA's PIO space.

6. **Test without AGP:**
   If AGP GART setup fails, try forcing the radeon driver to PCI GART
   mode by not loading `sgi-agp.ko`.  The radeon DRM driver should fall
   back to its internal PCI GART (`radeon_gart_init()`).

### Why fglrx Worked and Stock Drivers Might Not

fglrx had several advantages on SN2 that a stock open-source driver
does not:

1. **Direct SN2 DMA calls:** fglrx bypassed the standard DMA API and
   called `sn_dma_map_single()` directly, giving it full control over
   GART allocation.

2. **TIOCA awareness:** `__ke_firegl_snia_is_tioca()` let fglrx adjust
   its behavior for the TIOCA platform.

3. **NUMA-aware allocation:** Both fglrx (via `__ke_firegl_snia_closest_node()`)
   and sgi-agp (via `alloc_pages_node`) allocated memory from the closest
   NUMA node to the GPU, minimizing NUMAlink latency.

4. **Custom AGP mode:** sgi-agp configured AGP 3.0 8x with FastWrite
   and 64-bit addressing specifically for the TIOCA.

5. **Matched firmware:** The card's VBIOS was customized by SGI to match
   the Prism's connector layout and TIOCA address configuration.

A stock open-source radeon driver uses the standard DMA API, which should
be routed through `tioca_provider.c` transparently.  However, if the
driver makes assumptions about DMA address ranges, GART availability, or
BAR layout that don't hold on SN2, it will fail in ways that may not
produce obvious error messages.

---

## Complete External Dependency Map of fglrx.ko

### SN2 Platform Dependencies

| Symbol | Source | Purpose |
|---|---|---|
| `__sn_mmiowb` | Built-in (SN2 kernel) | Memory-mapped I/O write barrier |
| `sn_dma_map_single` | Built-in (SN2 PCI DMA) | Map physical → PCI bus address via GART |
| `sn_dma_unmap_single` | Built-in (SN2 PCI DMA) | Release GART mapping |
| `sn_dma_flush` | Built-in (SN2 PCI DMA) | Flush DMA write buffers |
| `sn_io_addr` | Built-in (SN2 I/O) | Translate PIO addresses |
| `physical_node_map` | Built-in (SN2 NUMA) | NUMA physical node topology |
| `numnodes` | Built-in (SN2 NUMA) | Number of NUMA nodes |
| `vmem_map` | Built-in (IA-64) | Virtual memory map |
| `ia64_pfn_valid` | Built-in (IA-64) | Page frame validation |

### AGP/DRM Dependencies

| Symbol | Source | Purpose |
|---|---|---|
| `agp_find_bridge` | `agpgart.ko` / `sgi-agp.ko` | Locate AGP bridge for a PCI device |
| `drm_agp` | `km_drm` (DRM core) | DRM AGP interface structure |

### Module Metadata

```
license    = Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY
depends    = agpgart, usbcore
vermagic   = 2.6.5-7.244-rtgfx SMP ia64 gcc-3.3
description = ATI Fire GL
author     = Fire GL - ATI Research GmbH, Germany
```

---

## Summary

The fglrx driver on the Prism is a significantly modified version of
ATI's proprietary FireGL driver with an entire SGI adaptation layer
(`firegl_snia.c`), direct SN2 DMA API usage, TIOCA platform detection,
NUMA-aware memory allocation, and ImageSync/CBOB multi-pipe
synchronization support.

For modern open-source drivers, the key insight is that the **TIOCA's
broken PCI32 direct DMA** forces all 32-bit DMA through the GART, and
**the GART has finite capacity** (1GB PCI + 2GB AGP).  Any GPU driver
must correctly use the standard Linux DMA API so that `tioca_provider.c`
can perform the GART translation, and must handle DMA mapping failures
gracefully.  Loading `sgi-agp.ko` before the GPU driver is essential to
make the AGP GART available, which doubles the available GART address
space and enables the AGP-specific acceleration path.
