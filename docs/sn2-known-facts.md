# SN2 GPU Known Facts Reference

## Hardware Topology
- **System**: SGI Altix 350, 1 C-brick (001c02), NASID 0x0, 1 SHub
- **PIC Widget**: 15 (0xF), base 0xc00000080f800000
- **PIC BUS1**: GPU's bus, register offset 0x00800000 from BUS0
- **PLX bridge**: PCI BDF 0002:00:02.0, PIC device slot 2, internal_device=1
- **GPU (Turks)**: PCI BDF 0002:01:00.0, behind PLX on BUS1
- **PIC hub_xid**: 0xb
- **PIC valid_dev**: 0x3, enabled_dev: 0x2

## GPU BAR Addresses (from lspci -vvv)
| BAR | CPU Address | Size | Content |
|-----|------------|------|---------|
| Region 0 | 0x80000008b0000000 | 256 MB | VRAM (prefetchable) |
| Region 2 | 0x800000080fd00000 | 128 KB | MMIO registers (non-prefetchable) |
| Region 4 | 0x800000080fe01000 | 256 B | I/O ports |

## Key VRAM Layout
| Offset | Content | Source |
|--------|---------|--------|
| 0x000000 | TTM buffer objects (vertex/texture uploads) | TTM managed |
| 0x160400 | **MCA PIO flood target** — within TTM BO region | errdmp PRB addr |
| 0x170000 | PCIE GART table | dmesg |
| 0x380000 | Framebuffer (1280x1024x32, 5MB) | dmesg fb mappable |

## Address Spaces
- **DMA mask**: 0xFFFFFFFF_FF (40-bit), Direct32 path
- **DMA range**: PCI 0x80000000-0xFFFFFFFF -> physical, dir_xbase=0x0
- **ATE range**: PCI 0x40000000-0x7FFFFFFF, 1024 ATEs x 16KB = 16MB
- **Coretalk prefix for node 0 cacheable memory**: 0x30xxxxxxxx

## PIC Register State (nominal)
- **p_dir_map**: 0x0000000000b00000
- **p_rrb_map**: even=0xaa999988 odd=0x889999aa (dev0=4, dev1=8, dev2=4)
- **p_int_enable**: 0x00003eff7ffefe22
- **device[1]**: 0x0000000012041002 (PLX bridge slot)
- **BUS1_INT_STATUS**: 0x0000000000000000 (CLEAN through all tests)

## MCA Error (from errdmp after-mca)
```
SH_FIRST_ERROR:          PI_HW_INT          (bit 0)
SH_PI_FIRST_ERROR:       FSB_PROTO_ERR      (bit 0)
SH_PI_ERROR_SUMMARY:     FSB_TBL_MISS (bit 33) + FSB_PROTO_ERR (bit 0)
SH_PI_ERROR_DETAIL_1:    0x051000301B160401
SH_PI_ERROR_DETAIL_2:    0x04000118C00205F3
SAL record +080:         0x000000301B160400
```
Error address = coretalk 0x301B160400 = VRAM offset 0x160400 (~1.38 MB)

## The PIO Write Flood (minecraft-starting-2 errdmp)
During heavy Minecraft, ALL SHub PRBs and WRBs show:
```
ADDR=0x400301B160400  STATE=FREE  T(GOOFY)  R(WRITE)  DID(0x004)
errdmp: "PIO Address: 0x01B160400"
```
All 25 WRBs + 15 PRBs: IDENTICAL. Flood of CPU PIO writes to VRAM.
Normal snapshots show diverse addresses and normal types (BWL, BIWE).

## Error Chain
```
Mesa userspace writes vertex/texture data to mmap'd VRAM (UC pages)
  -> Each UC store = PIO write: CPU -> SHub -> PIC -> PLX -> GPU VRAM
  -> Under heavy 3D, write rate exceeds SHub PIO buffer capacity
  -> SHub PRBs/WRBs saturated with identical VRAM writes
  -> FSB_PROTO_ERR -> MCA (fatal)
```
