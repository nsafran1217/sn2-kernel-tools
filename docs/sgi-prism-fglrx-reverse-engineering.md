# Reverse Engineering the fglrx Driver: SN2 GPU Initialization and DMA Techniques

## Purpose

This document presents findings from static reverse engineering of
`fglrx.ko` (SGI-modified ATI FireGL driver for the Altix Prism).  The
goal is to identify specific techniques that made GPU operation possible
on SN2, which may explain why stock PCI video cards fail on this platform
and suggest approaches for fixing them.

**Method:** Full IA-64 disassembly (`ia64-linux-gnu-objdump -d`),
symbol table analysis, relocation-based call graph reconstruction, and
string cross-referencing.

---

## Critical Finding: Hardcoded 32-bit DMA Mask

**This is the single most important finding for anyone trying to get PCI
video cards working on SN2.**

Disassembly of `__ke_pci_alloc_consistent()` reveals that fglrx
**explicitly forces a 32-bit DMA mask** before every coherent DMA
allocation:

```asm
;; __ke_pci_alloc_consistent + 0x246
;; Load 0xFFFFFFFF into r42 (the dma_mask argument)
    b900: mov r41=r32                    ; r41 = pci_dev
    b906: movl r42=0xffffffff            ; r42 = 0xFFFFFFFF (32-bit mask!)

;; __ke_pci_alloc_consistent + 0x250
;; Call pci_set_dma_mask(pci_dev, 0xFFFFFFFF)
    b910: mov r1=r40                     ; restore gp
    b916: nop.i 0x0
    b91c: br.call.sptk.many b0=b910     ; → pci_set_dma_mask()

;; __ke_pci_alloc_consistent + 0x280
;; Then immediately call sn_dma_map_single()
    b940: mov r44=r0                     ; direction = 0 (DMA_BIDIRECTIONAL)
    b946: nop.i 0x0
    b94c: br.call.sptk.many b0=b940     ; → sn_dma_map_single()
```

The `movl r42=0xffffffff` at offset b906 is unambiguous — the driver
sets the DMA mask to exactly `0xFFFFFFFF` (32-bit) right before calling
`sn_dma_map_single()`.

### Why This Matters

Inside `tioca_dma_map()`, the DMA mask is the **only** variable that
determines which translation path is used:

```c
if (pdev->dma_mask == ~0UL)           /* 64-bit? → direct coretalk */
    mapaddr = tioca_dma_d64(paddr);
else if (pdev->dma_mask == 0xffffffffffff)  /* 48-bit? → direct */
    mapaddr = tioca_dma_d48(pdev, paddr);
else
    mapaddr = 0;                       /* anything else → no direct */

if (mapaddr == 0)
    mapaddr = tioca_dma_mapped(...);   /* → GART translation */
```

By setting the mask to 32-bit (`0xFFFFFFFF`), fglrx ensures that neither
the 64-bit nor 48-bit direct paths are taken, and **every allocation goes
through the GART**.

A stock GPU driver that calls `dma_set_mask(dev, DMA_BIT_MASK(64))`
during probe — which is standard practice — will cause `tioca_dma_d64()`
to be used instead.  This returns a NUMAlink coretalk address (with the
coherent bit at bit 60), which is a 64-bit address that an AGP-era GPU
with 32-bit internal addressing **cannot decode**.  The DMA "succeeds"
from the kernel's perspective, but the GPU sees an unusable address,
causing silent failures, bus errors, or hangs.

### Recommended Fix

For any GPU driver on SN2/TIOCA:

```c
/* Force 32-bit DMA mask to ensure GART translation is used */
dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
```

This should be done during driver probe, before any DMA allocations.

---

## Critical Finding: TIOCA Detection Functions Are Hardcoded Stubs

The two SN2 "detection" functions are not detection functions at all —
they are compile-time constants:

```asm
__ke_firegl_snia_closest_node:
    e20: mov r8=r0              ; return 0 (node 0)
    e26: nop.i 0x0
    e2c: br.ret.sptk.many b0   ; return

__ke_firegl_snia_is_tioca:
    e40: mov r8=1               ; return 1 (always true)
    e46: nop.i 0x0
    e4c: br.ret.sptk.many b0   ; return
```

`__ke_firegl_snia_is_tioca()` unconditionally returns 1.
`__ke_firegl_snia_closest_node()` unconditionally returns 0.

This means the driver was **compiled specifically for the Prism** with
TIOCA assumed present.  There is no runtime detection.  The driver
always takes the TIOCA code path, always allocates from NUMA node 0,
and never considers that it might be on a different SN2 I/O bridge type.

### fglrxFindMasterNodeId — Actually Reads NUMA Topology

In contrast, this function does real work:

```asm
fglrxFindMasterNodeId:
    e60: adds r10=416,r32       ; offset 416 into device struct
    e66: addl r11=0,r1          ; load physical_node_map address
    e70: ld8 r9=[r10]           ; r9 = device_struct->field_416
    e76: ld8 r8=[r11]           ; r8 = physical_node_map base
    e86: extr.u r2=r9,38,10     ; extract bits 47:38 (node ID from address)
    e8c: shladd r3=r2,1,r8      ; r3 = physical_node_map + node_id * 2
    e90: ld2 r2=[r3]            ; r2 = physical_node_map[node_id]
    e9c: sxt2 r8=r2             ; sign-extend to return value
    eac: br.ret.sptk.many b0
```

This extracts bits 47:38 from a coretalk address (the NUMAlink node ID),
uses it as an index into `physical_node_map[]`, and returns the compact
node ID.  This is used during `sn_attach_bdata()` to determine which
NUMA node owns the TIOCA the GPU is attached to.

---

## Module Initialization Sequence

Reconstructed from `.init.text` relocations, the full initialization
order is:

```
init_module()
  └→ firegl_init_module()            [.text, 64 bytes — thin wrapper]
      └→ [.init.text real init]:
          1. usb_register()           — USB subsystem (ImageSync USB hw)
          2. isx_init()               — ImageSync subsystem init
          3. pci_register_driver()    — Register fglrx PCI driver
                                        (for ATI GPU PCI ID matching)
          4. pci_find_device()        — Find ATI GPU on PCI bus
          5. firegl_supported()       — Validate GPU is a supported model
          6. firegl_init()            — Main GPU initialization
               ├→ __ke_malloc()       — Allocate device structure
               ├→ drm_mem_init()      — DRM memory manager init
               ├→ __ke_pci_bus_number()
               ├→ __ke_pci_domain_nr()
               ├→ __ke_pci_slot_number()
               ├→ __ke_pci_func_number()
               ├→ drm_parse_options()
               ├→ _r6x_IsDeviceSupported()  — R4xx/R5xx device check
               ├→ sn_attach_bdata()  ★ — Attach SN2 bridge data
               └→ fglrx_kdb_init()   — KDB debugger hooks
          7. register_chrdev()        — Create /dev/fglrx
          8. inter_module_get()       — Get DRM inter-module interface
          9. inter_module_register()  — Register fglrx with DRM
         10. pci_find_device()        — (2nd scan, possibly for ISX hw)
         11. fglrx_isx_init()         — ImageSync PCI driver init
         12. cbob_init()              — CBOB crossbar output buffer init
```

### ★ sn_attach_bdata() — The SN2 Platform Hook

This 1648-byte function is the critical SN2 adaptation point.  Its call
sequence:

```
sn_attach_bdata():
    __ke_fglrx_spin_lock()
    __ke_malloc()                      — Allocate bdata structure
    __ke_fglrx_spin_unlock()
    __ke_printk()                      — Log messages
    __ke_pci_bus_number()              — Get PCI bus number
    __ke_pci_slot_number()             — Get PCI slot
    __ke_pci_func_number()             — Get PCI function
    __ke_printk()                      — Multiple diagnostic prints
    __ke_firegl_snia_is_tioca()     ★  — Detect TIOCA platform
    __ke_firegl_snia_closest_node() ★  — Find nearest NUMA node
    fglrxFindMasterNodeId()            — Locate master node
      └→ physical_node_map             — Read NUMA topology
```

`sn_attach_bdata()` is called from `firegl_init()` and is the point
where fglrx discovers it is running on SN2/TIOCA hardware.  The results
(is-TIOCA flag, closest NUMA node) are stored in the bdata structure
and used throughout the driver's lifetime for DMA and memory allocation
decisions.

The corresponding teardown `sn_destroy_bdata()` is called twice from
`firegl_cleanup()`.

---

## DMA Mapping Techniques

### __ke_pci_alloc_consistent() — Coherent DMA Allocation

This 864-byte function implements coherent DMA buffer allocation with
SN2-specific optimizations.  Full call sequence from disassembly:

```
__ke_pci_alloc_consistent(pci_dev=r32, size=r33, dma_handle=r34):
  +0x20:  __ke_firegl_snia_closest_node()  → returns 0 (hardcoded)
  +0xb0:  __alloc_pages()                  → allocate pages
  +0x150: [compute physical address]
          shl r35=r25,14                   → page frame << 14
          dep r35=-1,r35,61,3              → set bits 63:61 = 111
                                             (IA-64 uncached offset)
  +0x200: __ke_printk()                    → log allocation
  +0x230: __ke_printk()                    → log DMA mapping
  +0x246: movl r42=0xffffffff           ★  → DMA mask = 32-bit
  +0x250: pci_set_dma_mask(dev, 0xFFFFFFFF) ★
  +0x280: sn_dma_map_single(dev+112, phys_addr, size, 0) ★
  +0x2b0: __ke_printk()                    → log result
  +0x2d0: [return bus address in r8]
```

The `dep r35=-1,r35,61,3` instruction sets bits 63:61 to all 1s, which
is the `__IA64_UNCACHED_OFFSET` (0xE000000000000000).  This converts a
physical page address to an IA-64 uncached kernel virtual address before
passing it to `sn_dma_map_single()`.

**The 32-bit DMA mask at +0x246/+0x250 is the critical step.** Without
it, `tioca_dma_map()` would use 64-bit direct mode and return a coretalk
address the GPU cannot decode.

### Fallback Path

If the initial `__alloc_pages()` fails (checked at +0x170), the function
falls through to:

```
  +0x2f0: alloc_pages_current()            → fallback allocation
  +0x320: [retry with different order]
  +0x340: [loop back to +0x180 if successful]
```

### __ke_pci_map_single() / __ke_pci_map_page() — Streaming DMA

These are thin wrappers:

```
__ke_pci_map_single():
    sn_dma_map_single()                — Direct SN2 DMA mapping

__ke_pci_map_page():
    sn_dma_map_single()                — Same path for page mapping
```

### __ke_pci_unmap_single() / __ke_pci_unmap_page()

```
__ke_pci_unmap_single():
    sn_dma_unmap_single()              — Release GART entry

__ke_pci_unmap_page():
    sn_dma_unmap_single()              — Same for page unmapping
```

### __ke_pci_free_consistent() — Coherent DMA Teardown

```
__ke_pci_free_consistent():
    sn_dma_unmap_single()              — Release DMA mapping first
                                         (then presumably frees pages)
```

---

## I/O Port and MMIO Techniques

### I/O Port Reads Require DMA Flush

Every I/O port read function follows this pattern:

```
__ke_inb() / __ke_inw() / __ke_inl():
    sn_io_addr()                    ★  — Translate I/O port to MMIO addr
    [read from translated address]
    sn_dma_flush()                  ★  — Flush DMA write buffers
```

### I/O Port Writes Require MMIO Write Barrier

```
__ke_outb() / __ke_outw() / __ke_outl():
    sn_io_addr()                    ★  — Translate I/O port to MMIO addr
    [write to translated address]
    __sn_mmiowb()                   ★  — Memory-mapped I/O write barrier
```

### All Spinlock Releases Require I/O Flush

```
__ke_spin_unlock():          → __ke_flush_io() → __sn_mmiowb()
__ke_fglrx_spin_unlock():   → __ke_flush_io() → __sn_mmiowb()
__ke_isx_spin_unlock():     → __ke_flush_io() → __sn_mmiowb()
__ke_isx_dbg_spin_unlock(): → __ke_flush_io() → __sn_mmiowb()
__ke_isx_resync_unlock():   → __ke_flush_io() → __sn_mmiowb()
__ke_unlock_kernel():       → __ke_flush_io() → __sn_mmiowb()
```

**Insight:** On SN2, writes to MMIO space are not guaranteed to be
visible to the device until an `mmiowb()` barrier is issued.  fglrx
ensures this happens at every lock release boundary.  A stock driver
that doesn't call `mmiowb()` after MMIO writes may have writes arrive
at the GPU in wrong order or not at all, causing silent corruption or
hangs.

The kernel's standard `spin_unlock()` on IA-64/SN2 should include
`mmiowb()` automatically (it was added to the kernel spinlock path
later), but if a driver does bare MMIO writes without proper locking,
the writes may never reach the device.

### VSync IRQ Handler Also Flushes I/O

```
_r6x_service_irq_vsync_handler():
    __ke_flush_io()                    — 2 calls
```

This ensures that any MMIO writes done during interrupt handling are
flushed before the interrupt returns.

---

## AGP Acquisition Flow

### _firegl_agp_acquire() — Full AGP Setup

This 1920-byte function handles the complete AGP initialization:

```
_firegl_agp_acquire():
    __ke_printk()                      — "Acquiring AGP..."
    __ke_down_struct_sem()             — Take semaphore
    __ke_agp_available()               — Check if kernel AGP is usable
    __ke_printk()                      — Log AGP status
    __ke_error_code()                  — Set error if not available
    firegl_term_aperture()             — Clean up any prior aperture
    __ke_up_struct_sem()               — Release semaphore
    __ke_agp_copy_info()               — Get AGP bridge info
                                         (aperture base, size, etc.)
    firegl_init_aperture()             — Initialize aperture manager
    __ke_config_mtrr()                 — Configure MTRR for aperture
    __ke_mtrr_add_wc()                 — Add write-combining MTRR entry
    __ke_printk()                      — Log MTRR setup
    firegl_aperture_free()             — Release unused aperture slots
```

**Key detail:** `__ke_agp_copy_info()` calls `agp_find_bridge` (via
relocation), which on SN2 is `sgi_tioca_find_bridge()`.  This returns
the AGP bridge info including the TIOCA's graphics aperture base address
(`ca_gfxap_base = 0x80000000`) and size (`ca_gfxap_size = 2GB`).

The `__ke_config_mtrr()` and `__ke_mtrr_add_wc()` calls set up
write-combining for the AGP aperture, which is critical for performance.

### Built-in AGP Initialization

The built-in AGP stack (`__fgl_agp_init`) also calls `sn_dma_flush()`
4 times during initialization.  However, the built-in stack lacks a
TIOCA backend, so on SN2 it will fail and fall back to the kernel AGP
path.

---

## Patterns That May Explain PCI GPU Failures on SN2

### 1. DMA Mask — CONFIRMED as 32-bit via Disassembly

**This is now proven, not speculative.** Disassembly at offset b906
shows:

```asm
    b906: movl r42=0xffffffff        ; DMA mask = 0x00000000FFFFFFFF
    b910: br.call ... pci_set_dma_mask
    b940: br.call ... sn_dma_map_single
```

fglrx sets the DMA mask to exactly `0xFFFFFFFF` (32-bit) before every
`sn_dma_map_single()` call in the coherent allocation path.  This forces
`tioca_dma_map()` into the GART translation path.

A stock GPU driver that sets a 64-bit DMA mask will get coretalk
addresses from `tioca_dma_d64()` that look like:

```
0x1000_00XX_XXXX_XXXX   (64-bit, coherent bit at bit 60)
```

An AGP-era GPU with 32-bit BAR registers cannot decode this address.
The GPU will ignore or misinterpret it, causing DMA to go to the wrong
location (or nowhere), resulting in:

- GPU hangs during command processor initialization
- Blank display (framebuffer DMA goes nowhere)
- Machine check exceptions (if the GPU generates bad bus transactions)

**Fix:**
```c
/* In GPU driver probe function, BEFORE any DMA allocation: */
dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
```

### 2. Missing mmiowb() Barriers

fglrx wraps every MMIO write sequence with `__sn_mmiowb()`.  On SN2,
the NUMAlink fabric can reorder MMIO writes unless an explicit barrier
is issued.  A stock GPU driver that does:

```c
writel(value, reg1);
writel(value, reg2);  /* may arrive before reg1 write on SN2! */
```

may need:

```c
writel(value, reg1);
mmiowb();
writel(value, reg2);
```

Modern kernels include `mmiowb()` in `spin_unlock()`, but bare MMIO
writes outside spinlock-protected regions (common in GPU command
submission paths) will not be ordered.

**Recommendation:** Check if the GPU driver has MMIO write sequences
without proper barriers, especially in interrupt handlers and command
ring management.

### 3. Missing DMA Flushes

fglrx calls `sn_dma_flush()` after every I/O port read and in multiple
places during AGP initialization.  The DMA flush ensures pending
outbound DMA writes from the device are visible to the CPU.  Without
it, the CPU may read stale data from buffers the GPU has written to.

On modern kernels, `dma_rmb()` or explicit `dma_sync_single_for_cpu()`
should handle this, but only if the GPU driver actually calls them.

### 4. NUMA-Aware Allocation

fglrx allocates all GPU-related memory from the NUMA node closest to
the TIOCA (`__ke_firegl_snia_closest_node()`).  A stock driver using
`dma_alloc_coherent()` or `alloc_pages()` without NUMA affinity may
allocate memory from a remote node, adding significant latency for
every GPU DMA operation.

This probably won't cause a hard failure, but could cause timeouts in
timing-sensitive GPU operations (command processor initialization,
ring buffer management).

**Recommendation:** Use `dma_alloc_coherent()` which should respect
the device's NUMA node, or explicitly use `alloc_pages_node()`.

### 5. PIO Address Translation

I/O port accesses (`inb`/`outb` etc.) must go through `sn_io_addr()`
on SN2.  The standard kernel handles this transparently for `ioread*`/
`iowrite*` and `readl`/`writel`, but legacy I/O port access (`inb`/
`outb`) requires the address translation.  If a GPU driver uses raw I/O
port instructions for VGA register access (common for mode setting),
those accesses will go to the wrong address on SN2.

**Recommendation:** Verify the GPU driver uses MMIO (`readl`/`writel`
or `ioread32`/`iowrite32`) rather than legacy I/O port access for all
register operations.

### 6. Expansion ROM Access

The init sequence calls `pci_find_device()` twice and accesses the GPU's
PCI config space.  The GPU's VBIOS (Expansion ROM) is at a PIO-mapped
address that must be accessed through the SN2 I/O path.  If the radeon
driver's VBIOS reading code fails silently, the driver will not be able
to configure outputs, clocks, or memory timing.

**Recommendation:** Add debug logging to the radeon driver's VBIOS
reading path and verify the ROM can be read from the TIOCA PIO space.

### 7. AGP Bridge Must Exist Before GPU Probe

The init sequence shows fglrx checking `__ke_agp_available()` early and
aborting if AGP is not present.  The DRM radeon driver similarly checks
for an AGP bridge during probe.  If `sgi-agp.ko` is not loaded, the
probe will either fail or fall back to a PCI-only mode that may not
work correctly on TIOCA (since PCI32 direct DMA is broken).

**Recommendation:** Always load `agpgart` and `sgi-agp` before any GPU
driver.  Build them as `=y` if possible.

---

## Summary of Reverse-Engineered Techniques

| Technique | fglrx Implementation | Stock Driver Equivalent | Risk If Missing |
|---|---|---|---|
| **32-bit DMA mask** | **`movl r42=0xffffffff` before every DMA map** | **Single `dma_set_mask(64)` at probe** | **GART bypass → GPU can't decode addresses → HANG** |
| TIOCA detection | `mov r8=1` (hardcoded stub) | Not needed (platform layer) | Low |
| NUMA affinity | `mov r8=r0` (hardcoded node 0) | `dma_alloc_coherent()` | Perf, timeouts |
| MMIO write barriers | `__sn_mmiowb()` after every write | `mmiowb()` in `spin_unlock()` only | Write reordering, hangs |
| DMA flush after reads | `sn_dma_flush()` after I/O reads | `dma_rmb()` / `dma_sync_*` | Stale data reads |
| PIO translation | `sn_io_addr()` for I/O ports | Kernel handles transparently | Wrong addresses |
| AGP before GPU | `__ke_agp_available()` check | DRM AGP detect at probe | No GART, DMA fails |
| MTRR/WC for aperture | `__ke_mtrr_add_wc()` | `arch_phys_wc_add()` | Slow framebuffer |

The most likely causes of GPU failure on SN2 are, in order of
probability:

1. **Wrong DMA mask (CONFIRMED)** — 64-bit mask causes GART bypass,
   GPU receives 64-bit coretalk addresses it cannot decode.  fglrx
   explicitly sets 32-bit mask (`0xFFFFFFFF`) before every DMA mapping.
2. **Missing AGP bridge** — sgi-agp not loaded, no GART for GPU
3. **Missing MMIO barriers** — write reordering causing GPU register
   corruption
4. **VBIOS read failure** — can't read Expansion ROM through PIO,
   driver can't configure display outputs
