# PIC ASIC Register Quick Reference — GPU Debugging on SN2

## Context

The GPU (Radeon HD 7570 / Turks) is behind a PLX PEX8111 PCIe-to-PCI-X bridge
on PIC widget 15, bus 1, device 2 (slot 2). All registers below are BUS1_*
(offset base 0x00800000 from BUS0 equivalents).

Source: `pic_01_mmrs.pm` from SGI Internal Service Tools (IST), generated from
`hwreg_pic.hwreg` — SGI's internal PIC ASIC hardware register database.

---

## Reading These Registers

### Via JTAG (sscope tools, works post-crash):

**First, discover your PIC chip name** (run once while system is healthy):
```bash
errdmp --l2 <L2_host> -verbose -fast 2>&1 | grep "^ADD PIC"
```
Output example: `ADD PIC: brick=001i14 board=IO9 chip=PIC0`
Your `-chip` value is `001i14:IO9:PIC0`. Substitute below.

```bash
# Read a single register
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n "BUS1_INT_STATUS"

# Read multiple registers (space-delimited in quotes)
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n "BUS1_INT_STATUS BUS1_DIR_MAP BUS1_DEV2_REG"

# Dump ALL PIC registers (omit -n flag)
mmr_dump --l2 <L2_host> -chip $PIC_CHIP

# Read from a file of register names (one per line)
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -i pic_regs.txt -o pic_dump.out
```

The `-chip` triplet format is `<brick>:<board>:<chip>`. Brick names
encode physical location (e.g., `001i14` = rack 0, I-brick, slot 14).
Board and chip names (e.g., `IO9`, `PIC0`) vary by system and must
come from hardware discovery — they cannot be guessed.

### Via Linux kernel MMIO (works while running):
PIC registers are accessible through the SHub's Global MMR space.
The kernel code in `arch/ia64/sn/pci/pcibr/` accesses these via
`pcireg_*` accessor functions. Physical address formula:

```
PIC_MMR_ADDR = SHUB_MMR_BASE + WIDGET_OFFSET + REGISTER_OFFSET
```

Where WIDGET_OFFSET for widget 15 = 0x0F000000 (in the SHub's I/O space).

### Via printk instrumentation in pcibr code:
The `struct pcibus_info` contains `pbi_buscommon.bs_base` which is the
MMIO base for the PIC widget. Register reads:
```c
u64 val = __raw_readq((void __iomem *)(pbi->pbi_buscommon.bs_base + REG_OFFSET));
```

---

## Error Registers

### BUS1_INT_STATUS (0x00800100) — Master Error/Interrupt Status
```
Bit 45: PCI_X_SPLIT_MES_PE    Split completion message parity error
Bit 44: PCI_X_SPLIT_EMESS     Split completion error message
Bit 43: PCI_X_SPLIT_TO        Split completion timeout
Bit 42: PCI_X_UNEX_COMP       Unexpected completion cycle to master
Bit 41: INT_RAM_PERR           Internal RAM parity error
Bit 40: PCI_X_ARB_ERR          Device requesting arb error
Bit 39: PCI_X_REQ_TOUT     ★  Read request timeout — GPU not responding
Bit 38: PCI_X_TABORT           Target abort
Bit 37: PCI_X_PERR             PERR
Bit 36: PCI_X_SERR             SERR
Bit 35: PCI_X_MRETRY           PIO retry counter exhausted
Bit 34: PCI_X_MTOUT        ★  Master timeout — PIO operation stuck
Bit 33: PCI_X_DA_PARITY        Data cycle parity error (detected by PIC)
Bit 32: PCI_X_AD_PARITY        Address/attribute cycle parity error
Bit 30: PMU_PAGE_FAULT     ★  Invalid PCI page access (ATE miss)
Bit 29: UNEXPECTED_RESP    ★  Unexpected response arrived
Bit 28: BAD_XRESP_PACKET       Response packet size mismatch
Bit 27: BAD_XREQ_PACKET        Request packet size mismatch
Bit 26: RESP_XTALK_ERROR   ★  Response had error bit or invalid sideband
Bit 25: REQ_XTALK_ERROR        Request had error bit or invalid sideband
Bit 24: INVALID_ACCESS         Invalid address/access type
Bit 23: UNSUPPORTED_XOP        Unsupported request operation
Bit 22: XREQ_FIFO_OFLOW        Request packet overflow
Bit 21: LLP_REC_SNERROR        LLP sequence number error
Bit 20: LLP_REC_CBERROR        LLP check bit error
Bit 15: PCI_ABORT               PCI slave abort condition
Bit 14: PCI_PARITY              PIC detected parity error
Bits 7:0: INTx                  Device interrupt lines (normal, not errors)
```

★ = Most likely bits to be set during GPU MCA

### BUS1_PCI_X_DMA_ERR_ADDR (0x00800630) — DMA Error Address
Captures the DMA address that caused an error. Compare with known
GPU DMA mapping ranges (0x80000000–0x9FFFFFFF for direct32).

### BUS1_PCI_X_DMA_ERR_ATTR (0x00800628) — DMA Error Attributes
Captures transaction type, direction, byte count for the failing DMA.

### BUS1_PCI_ERR_UPPER_ADDR (0x008000D0) / LOWER (0x008000D8)
PCI error address capture (48-bit physical address of error).

### BUS1_PCI_X_READ_REQ_TOUT (0x00800638) — Read Request Timeout
Captures information about read requests that timed out.

### BUS1_ERR_INT_VIEW (0x00800170) — Error Interrupt View
Alternative view of which error interrupts are active.

### BUS1_HOST_ERR_FIELD (0x00800128) — Host Error Field
Error information sent to the host (SHub) side.

---

## Bridge Status/Config

### BUS1_BRIDGE_STAT (0x00800008) — Bridge Status
```
Bits 35:34: PCI_X_SPEED        PCI-X bus speed (if not using external clock)
Bit  33:    PCI_X_ACTIVE       1=PCI-X mode, 0=PCI mode
Bits 31:24: LLP_REC_CNT        LLP receive counter (check bit errors)
Bits 23:16: LLP_TX_CNT         LLP transmit retry counter
Bits 15:12: RX_CREDIT_CNT      Receive credit count
Bits 11:8:  TX_CREDIT_CNT      Transmit credit count
```

### BUS1_BRIDGE_CTRL (0x00800020) — Bridge Control

### BUS1_BRIDGE_REQ_TO (0x00800028) — Request Timeout
20-bit counter; 0xFFFFF = ~1.006632 seconds. Controls how long PIC
waits for a PCI device to respond before flagging a timeout error.

### BUS1_DIR_MAP (0x00800080) — Direct Map Register
```
Bits 23:20: DIR_W_ID           Target widget ID for direct-mapped DMA
Bit  17:    DIR_ADD512          Add 512MB offset when DIR_OFF=0
Bits 16:0:  DIR_OFF            Direct map offset [47:31] of physical addr

Physical_addr = {DIR_OFF[16:0], DMA_addr[30:0]}
                 bits 47:31      bits 30:0
```

### BUS1_MAP_FAULT_ADDR_ (0x00800090) — Page Map Fault Address
Captures the address and device number for ATE page faults.

---

## Per-Device Registers

### BUS1_DEV2_REG (0x00800210) — PLX Bridge Device Register
```
Bit 28: EN_ERROR_LOCK          Enable error lock
Bit 27: EN_PAGE_CHK            Enable prefetcher page cross checking
Bit 26: FORCE_PCI_PAR          Force PCI parity error (test only!)
Bit 25: EN_VIRTUAL             Enable virtual device
Bit 23: DIR_WRT_GEN        ★  Direct mapped WRITE GATHER enable
Bit 22: DEV_SIZE               Device size (0=32-bit, 1=64-bit)
Bit 21: REAL_TIME              Real-time device enable (priority arb)
Bit 19: SWAP_DIRECT            Enable swapping in direct map mode
Bit 18: PREFETCH           ★  Prefetcher enable (for DMA reads)
Bit 17: PRECISE                Precise transaction (vs relaxed)
Bit 16: COHERENT           ★  Coherent transaction (cache coherent DMA)
Bit 15: BARRIER            ★  Barrier transaction (ordering guarantee)
Bit 14: GBR                    GBR enable
Bit 13: DEV_SWAP               Device byte swapping enable
Bit 12: DEV_IO_MEM             0=I/O space, 1=Memory space (for PIO)
Bits 11:0: DEV_OFF             PIO address offset [31:20]
```

★ = Bits that affect DMA behavior — check these!

**Important:** The COHERENT and BARRIER bits control how DMA from this
device is handled by the ccNUMA fabric. If COHERENT is not set, DMA
writes may not be snooped, potentially causing cache coherency violations.
If BARRIER is set, all DMAs from this device act as barriers.

The Linux kernel sets these in `pcibr_bus_fixup()` via `pcireg_device_set()`.
Check what values the kernel actually programs.

### BUS1_DEV2_WR_FLUSH (0x00800250) — Write Flush
Writing to this register flushes pending writes for device 2 (the PLX bridge).
This is a **per-device** write flush, separate from the per-widget flush used
by `sn_dma_flush()`.

---

## Read Response Buffer (RRB) Status

### BUS1_RR_BUFF_STATUS (0x00800290) — RRB Status
```
Bits 31:16: RRB_VALID          Read Response Buffer VALID bits (16 RRBs)
Bits 15:0:  RRB_INUSE          Read Response Buffer INUSE bits (16 RRBs)
```

If INUSE is set but VALID is not, the RRB is allocated (waiting for response).
If all 16 INUSE bits are set → **RRB exhaustion** — no more read slots available.
This would stall all PIO reads and DMA reads to this bus.

### BUS1_PCI_RD_RESP*_UPP (0x00800300 + N*0x10) — Per-RRB Status
Each of the 16 RRBs has upper and lower registers with:
```
Bit 31: FILLED                 Buffer has valid data
Bit 30: ARMED                  Request sent, data not yet arrived
Bit 29: FLUSH                  Buffer marked for flush
Bit 28: XERR                   Xtalk command word error or invalid sideband
Bit 27: PKTERR                 Incoming packet wrong size
Bit 26: TIMEOUT            ★  Response not arrived within time limits
Bit 25: PREFETCH               Request type was prefetch
Bit 24: PRECISE                Request type was precise
Bits 23:16: DW_BE              Byte enables for precise transactions
Bits 15:0: UPP_ADDR            Address bits [47:32]
```

★ TIMEOUT bits indicate the PCI device did not respond in time.

---

## Performance Counters (Per-Buffer)

These are invaluable for understanding DMA behavior before crash:

### BUS1_BUF*_TOT_PCI_RETRY_CNT (base + buffer*0x40 + 0x20)
Total PCI retry count for this buffer. High values indicate the PCI device
is frequently retrying transactions (normal for GPUs but extreme values
may indicate a problem).

### BUS1_BUF*_MAX_PCI_RETRY_CNT (base + buffer*0x40 + 0x28)
Maximum PCI retry count seen for this buffer. A very high value here
with a TIMEOUT bit set would indicate the device stopped responding.

### BUS1_BUF*_MAX_LAT_CNT (base + buffer*0x40 + 0x38)
Maximum latency count for this buffer. High latency under heavy load
could explain why the PIC times out.

### BUS1_BUF*_REQ_FLIGHT_CNT (base + buffer*0x40 + 0x10)
Number of requests in flight. Check if this is near the maximum,
indicating buffer saturation.

### BUS1_BUF*_FLUSH_CNT_DATA_TOUCH (base + buffer*0x40 + 0x00)
### BUS1_BUF*_FLUSH_CNT_NO_DATA_TOUCH (base + buffer*0x40 + 0x08)
Flush counts — tells us how many DMA write buffer flushes occurred
with and without data. Relevant to the `sn_dma_flush()` path.

---

## PCI-X Write Buffers (8 buffers)

### BUS1_PCI_X_WR_BUF*_VALID (0x00800B10 + N*0x20)
```
Bit 0: VALID                   Write buffer contains valid data
```
If all 8 VALID bits are set → **Write buffer exhaustion** — DMA writes
from the GPU are backing up and can't be accepted.

### BUS1_PCI_X_WR_BUF*_ADDR (0x00800B00 + N*0x20)
Address of pending write in this buffer.

### BUS1_PCI_X_WR_BUF*_ATTR (0x00800B08 + N*0x20)
Attributes of pending write in this buffer.

---

## Interrupt Configuration

### BUS1_INT_ENABLE (0x00800108) — Interrupt Enable
Which of the 46 INT_STATUS bits are enabled to generate interrupts.

### BUS1_INT_DEV (0x00800120) — Interrupt Device Assignment
Maps device interrupt pins to PIC interrupt lines.

### BUS1_INT*_HOST_ADDR (0x00800130 + N*8) — Interrupt Target Address
Physical address where each interrupt line sends its interrupt.
These are SHub interrupt target addresses on the NUMAlink fabric.

### BUS1_INT*_FORCE_ALWAYS (0x00800180 + N*8) — Force Interrupt
Writing to these forces an interrupt on the specified line.
This is what `sn_dma_flush()` uses to flush DMA write buffers
(it writes to the FORCE_INT register for the appropriate device slot).

---

## SHub II Registers (I/O Interface to PIC)

These are read by `errdmp -ii` and are in the SHub, not the PIC.
Addresses are relative to the SHub MMR base.

### II_WSTAT (0x1400008) — Widget Status
Widget connection status, error indicators.

### II_IIDEM (0x1400120) — Device Enable Mask
Which devices on the I/O widget are enabled. If the GPU's device
is not in this mask, it has been disabled (possibly by an error).

### II_IPRB* (0x1400198 + offset) — Packet Request Buffer per Widget
PRB state for each widget. Shows outstanding request count
and error status for the widget.

### II_ICRB*_A through _E (0x1400400 + CRB*0x30 + sub*8)
Command Request Buffers. 15 CRBs track outstanding I/O operations.
Sub-registers:
- _A: Command and address
- _B: Supplementary address
- _C: Control and routing
- _D: Data
- _E: Status (VALID, ERROR, TIMEOUT bits)

### II_IXSS (0x1400210) — Xtalk Error Summary
Summary of Xtalk bus errors between SHub and PIC.

### II_IXTT (0x14001F0) — Xtalk Timeout
Timeout configuration and status for Xtalk transactions.
