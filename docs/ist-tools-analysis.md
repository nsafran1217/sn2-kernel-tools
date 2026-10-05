# SGI Internal Service Tools (IST) — Analysis for SN2 GPU/PCI Debugging

## Overview

This document analyzes the SGI Internal Service Tools CD contents for tools
useful in debugging PCI GPU issues on the SGI Altix 350 (IP41, SN2 architecture).
The specific problem: Radeon HD 7570 (Turks) behind a PLX PEX8111 PCIe-to-PCI-X
bridge triggers MCA (Machine Check Abort) under heavy 3D load (Minecraft).

**All sscope tools operate via JTAG backdoor** through the L1→L2→L3 system
controller hierarchy, meaning they can read hardware registers **even when the
system is crashed/frozen after an MCA**. This is their primary value.

---

## Package Contents

| Package | Size | Purpose | Relevance |
|---------|------|---------|-----------|
| **sscope** | 23MB | SuperScope diagnostic scripts + libraries | ★★★★★ CRITICAL |
| snxscan | 179MB | JTAG scan/interconnect testing | ★★ Low (manufacturing) |
| snxsc_firmware | 114MB | L1/L2 controller firmware + flash tools | ★ Low (support infra) |
| snxsc_l3 | 9.1MB | L3 workstation management tools | ★★ Low (L2 management) |
| sysco | 19MB | Perl/Tk runtime for sscope tools | ★ Low (runtime support) |
| sgidiag | 19KB | User account profile | ★ None |

---

## Critical Tools (sscope package)

### 1. errdmp — Error State Dump ★★★★★

**Location:** `/stand/sysco/bin/errdmp` (8946 lines, Perl)

**Purpose:** Reads and decodes the complete error state of every SHub, TIO, PIC,
and NL4R chip in the system. This is THE primary SGI diagnostic tool for
hardware error analysis.

**What it reads:**

For each SHub node:
- `SH_FIRST_ERROR` — Top-level first error indicator
- `SH_PI_FIRST_ERROR` / `SH_PI_ERROR_SUMMARY` — Processor Interface errors
- `SH_PI_ERROR_DETAIL_1` through `_4` — Error details (address, type)
- `SH_PI_UNCORRECTED_DETAIL_1` through `_4` — Uncorrected error details
- `SH_LB_FIRST_ERROR` / `SH_LB_ERROR_SUMMARY` — Local Block errors
- `SH_XN_*` — Crossbar Network errors
- PI CRB state (Command Request Buffers):
  - **WRB** (Write Request Buffers) — 20 total, checks deallocation count
  - **RRB** (Read Response Buffers)
  - **IRB** (Interrupt Request Buffers)
  - **PRB** (Packet Request Buffers)

For PIC bridges (with `-pic` flag):
- `BUS*_BRIDGE_STAT` — Bridge status (PCI-X active, LLP counters)
- `BUS*_ERR_INT_VIEW` — Error interrupt view
- `BUS*_INT_STATUS` — Full interrupt status (46 error bits)
- `BUS*_PCI_ERR_UPPER_ADDR` / `_LOWER_ADDR` — PCI error address
- `BUS*_PCI_X_ERR_ADDR` / `_ATTR` — PCI-X error details
- `BUS*_PCI_X_DMA_ERR_ADDR` / `_ATTR` — **DMA error address and attributes**
- `BUS*_DIR_MAP` — Direct mapping register
- `BUS*_DEV0_REG` through `BUS*_DEV3_REG` — Per-device register state
- `BUS*_RR_BUFF_STATUS` — Read Response Buffer status (RRB exhaustion)
- `BUS*_BUF*_TOT_PCI_RETRY_CNT` — PCI retry counters per buffer

For SHub II (I/O Interface) registers (with `-ii` flag):
- II CRB registers (II_ICRB*_A through _E) — Outstanding I/O operations
- II PRB registers (II_IPRB*) — Packet Request Buffers per widget
- II_WSTAT — Widget status
- II_IIDEM — Device enable mask
- II_IXSS / II_IXSM — Xtalk error summary/mask
- II_IIEPH1 / II_IIEPH2 — Error packet headers
- Crossbow registers on connected I/O bricks

**Direct relevance to GPU MCA:**
- WRB deallocation check: errdmp verifies all 20 WRBs are freed. If fewer than
  18 are deallocated, it flags an error. This directly tests the theory that
  heavy GPU DMA exhausts WRBs → MCA.
- PIC DMA error registers capture the exact failing DMA address and attributes.
- SHub PI error registers tell us exactly what class of error triggered the MCA.
- II CRB state shows what I/O operations were in flight at crash time.

**Usage:**
```bash
# Basic error dump (all SHub nodes)
errdmp --l2 <L2_IP_or_hostname>

# With PIC bridge register dump (WARNING: may crash running system)
errdmp --l2 <L2_IP> -pic

# With II register dump
errdmp --l2 <L2_IP> -ii

# Full dump with PIC and II (use AFTER crash, not during operation)
errdmp --l2 <L2_IP> -pic -ii

# Specific partition
errdmp --l2 <L2_IP> -part 0

# With output to named machine directory
errdmp -m <machine_name>

# Disable CRB state capture (faster)
errdmp --l2 <L2_IP> -nocrb
```

**Key command-line flags:**
- `-pic` — Dump PIC registers on I/P bricks (CAUTION: crashes running system)
- `-ii` — Dump II registers on C-bricks connected to I/P bricks
- `-II` — Dump II registers on ALL nodes
- `-nocrb` — Skip CRB state (faster)
- `-nowrb` — Skip WRB state
- `-norrb` — Skip RRB state
- `-noparse` — Raw MMR values without decode
- `-flush` — System flush mode (0=none, 1=single, 2=all)

**CAUTION:** The `-pic` flag warning from SGI: "Dumping the PIC MMR's on a system
running Linux will likely cause the system to crash. PIC MMR dumping usually causes
bogus Unexpected Response errors on PIC2." **Use only after MCA, not during operation.**

---

### 2. mmr_dump — Generic MMR Reader ★★★★★

**Location:** `/stand/sysco/bin/mmr_dump` (491 lines, Perl)

**Purpose:** Read any named MMR from any ASIC (SHub, PIC, TIO, NL4R, SHub2)
via JTAG. Unlike errdmp which reads a predefined set, mmr_dump can target
specific registers by name.

**Usage (from built-in help):**
```
USAGE: mmr_dump -chip <full_name> [--l2 <host>] [-n <MMRs>] [-i <in_file>] [-o <out_file>]

-chip <n>     Full name of chip to target: <brick>:<board>:<chip>
                 Example: 001c01:NODE0:SHUB0
-n <MMRs>     List of MMR names to read and display/save.
                Names should be space-delimited in a quoted string.
                Example: -n "BUS0_BRIDGE_STAT BUS0_BRIDGE_CTRL"
                Default: all MMRs for specified target chip
-i <in_file>  Name of input file with MMR names to read (one per line)
-o <out_file> Name of output file to create with MMR values.
--l2 <host>   Name or IP address of L2 system controller
-f <file>     Name of JTAG configuration file (.cfg) defining hardware
-M <mode>     yes = use L1 MMR commands (default), no = old L1 firmware
```

**Examples (from built-in help):**
```bash
$ mmr_dump -chip 001c01:NODE1:SHUB1 --l2 l2-coot
$ mmr_dump -chip 001c01:NODE1:SHUB1 --l2 l2-coot -i pi_mmrs.lst
$ mmr_dump -chip 101t01:MOATB:TIO0  --l2 l2-torpedo -n "TIO_NODE_ID TIO_CA_IDENTIFICATION"
```

**CRITICAL — Discovering the correct -chip name:**

The `-chip` value must be an exact `<brick>:<board>:<chip>` triplet as
discovered from the hardware JTAG scan chain. These names are NOT
standardized — they depend on your specific system configuration.

**Brick name** is derived from physical location: `<rack><type><slot>`,
e.g., `001c01` = rack 0, C-brick, slot 01; `001i14` = rack 0, I-brick,
slot 14. The exact slot number depends on your physical cabling.

**Board and chip names** (e.g., `NODE0`, `SHUB0`, `IO9`, `PIC0`) are
defined in JTAG chain description files and vary by brick type. On an
IX-brick, the board name could be `IO9`, `IO10`, `PCI12`, or others
depending on which baseIO/PCI carrier card is installed. On a C-brick,
boards are `NODE0`/`NODE1` with chips `SHUB0`/`SHUB1`.

To discover available chips, use one of these methods:

1. **Run errdmp with -verbose** — it prints discovery lines like:
   `ADD PIC: brick=001i14 board=IO9 chip=PIC0`
   `ADD SH1 SHUB0: brick=001c01 board=NODE0 chip=SHUB0`
   ```bash
   errdmp --l2 <L2_host> -verbose -fast 2>&1 | grep "^ADD"
   ```

2. **Run superscope** — the GUI shows all discovered chips interactively:
   ```bash
   superscope --l2 <L2_host>
   ```

3. **Run mmr_dump with -debug** — prints scan chain details before failing:
   ```bash
   mmr_dump --l2 <L2_host> -chip DUMMY:DUMMY:DUMMY -debug 1
   ```

4. **Use a scan config file** — if auto-discovery doesn't work, provide
   a .cfg file that defines your system's JTAG chain layout:
   ```bash
   mmr_dump --l2 <L2_host> -f /stand/sysco/cfg/scan/<your_config>.cfg -chip <brick>:<board>:<chip>
   ```

If no `-n` or `-i` is given, ALL MMRs for that chip type are dumped.

**Key for GPU debugging:** Can read specific PIC registers before and after
triggering the MCA to compare state. Useful for monitoring DIR_MAP, DEV registers,
and RRB status during controlled testing.

---

### 3. superscope — Interactive Register Browser ★★★★

**Location:** `/stand/sysco/bin/superscope` (966 lines, Perl/Tk GUI)

**Purpose:** Interactive GUI for browsing and reading/writing MMRs across
the entire system. The graphical frontend to the same JTAG infrastructure.

**Key for GPU debugging:** Allows real-time interactive exploration of PIC
and SHub registers. Can be used to:
- Browse all available registers for any chip
- Read individual registers on demand
- Potentially write registers (e.g., to test changing DEV register settings)

---

### 4. sn2mon — System Monitor ★★★★

**Location:** `/stand/sysco/bin/sn2mon` (792 lines, Perl)

**Purpose:** Periodically reads and displays SN2 system health metrics.

**Key for GPU debugging:** Could be configured to monitor PIC error
registers and SHub error counters during GPU stress testing, watching
for error accumulation before an MCA fires.

---

### 5. elog_decode — Error Log Decoder ★★★

**Location:** `/stand/sysco/bin/elog_decode` (406 lines, Perl)

**Purpose:** Decodes SHub error log entries, primarily focused on memory
(ECC) errors and TIO errors. Reads error state from the L2's SMDK
error logger.

**Key for GPU debugging:** May help decode the SAL platform error section
format we've been unable to interpret. The SHub error types it decodes
(PI errors, XN errors, NI errors) are relevant to I/O-triggered MCAs.

---

### 6. mem_read — Cache Line Reader ★★★

**Location:** `/stand/sysco/bin/mem_read` (258 lines, Perl)

**Purpose:** Reads cache lines from physical memory using the SHub packet
generator via JTAG. Can read any physical address.

**Key for GPU debugging:** Could be used after an MCA to read memory
locations that were targets of GPU DMA, verifying whether data arrived
correctly or was corrupted.

---

### 7. Other sscope Tools

| Tool | Lines | Purpose | GPU Relevance |
|------|-------|---------|---------------|
| shubmb | 3638 | SHub Memory BIST | ★★ Memory path testing |
| shubbt | 848 | SHub BIST | ★★ General SHub testing |
| beru | 1404 | Bit Error Rate utility | ★★ NUMAlink testing |
| rtrdmp | 287 | Router register dump | ★ NUMAlink routing |
| link_err | 264 | NUMAlink error check | ★ Link errors |
| par_dmp | 1565 | Partition dump | ★ System config |
| wirestat.pl | 927 | Wire status | ★ Physical layer |
| eeprom_chk | 276 | EEPROM verification | ★ Board ID |
| prom_read | 597 | PROM reader | ★ Firmware check |

---

## Critical Library Files

### pic_01_mmrs.pm — PIC ASIC Register Map (13,582 lines)

This is **proprietary SGI documentation** for every register in the PIC ASIC,
with full bit-field definitions. This is the most valuable piece of documentation
in the entire IST package for understanding PIC bridge behavior.

The file was auto-generated from SGI's hardware register database
(`hwreg_pic.hwreg`) using the `hwr2pl` utility.

Each register definition includes:
- Register name and address offset
- Bit field names, positions, lengths, and masks
- Field descriptions
- Reset values

### ii_regs.pm — SHub I/O Interface Register Decode (1200+ lines)

Contains register definitions and decode logic for the SHub's II chiplet,
which manages the interface between the SHub crossbar and the PIC bridge.
Includes CRB decode, PRB decode, WSTAT decode, and IIDEM (device enable mask)
parsing.

### error_regs.pm — Error Register Framework

Framework for reading and decoding SHub error registers (FIRST_ERROR,
ERROR_DETAIL, ERROR_SUMMARY, etc.).

### shub_01_mmrs.pm — SHub Register Map

Complete SHub ASIC register definitions, analogous to pic_01_mmrs.pm.

---

## PIC Register Map for GPU Debugging

### Critical Registers (BUS1 — GPU's bus on widget 15)

#### Error State
| Register | Address | Description |
|----------|---------|-------------|
| BUS1_INT_STATUS | 0x00800100 | 46-bit interrupt/error status (see bit fields below) |
| BUS1_ERR_INT_VIEW | 0x00800170 | Error interrupt view |
| BUS1_PCI_ERR_UPPER_ADDR | 0x008000D0 | PCI error address [47:32] |
| BUS1_PCI_ERR_LOWER_ADDR | 0x008000D8 | PCI error address [31:0] |
| BUS1_PCI_X_ERR_ADDR | 0x00800600 | PCI-X error address |
| BUS1_PCI_X_ERR_ATTR | 0x00800608 | PCI-X error attributes |
| BUS1_PCI_X_DMA_ERR_ADDR | 0x00800630 | **DMA error address** |
| BUS1_PCI_X_DMA_ERR_ATTR | 0x00800628 | **DMA error attributes** |
| BUS1_PCI_X_PIO_SPLIT_ERR_ADDR | 0x00800618 | PIO split error address |
| BUS1_PCI_X_PIO_SPLIT_ERR_ATTR | 0x00800620 | PIO split error attributes |
| BUS1_PCI_X_READ_REQ_TOUT | 0x00800638 | Read request timeout |
| BUS1_HOST_ERR_FIELD | 0x00800128 | Host error field |

#### Bridge Config/Status
| Register | Address | Description |
|----------|---------|-------------|
| BUS1_BRIDGE_ID | 0x00800000 | Bridge identification (rev, part) |
| BUS1_BRIDGE_STAT | 0x00800008 | Status (PCI-X active, LLP counters) |
| BUS1_BRIDGE_CTRL | 0x00800020 | Bridge control |
| BUS1_BRIDGE_REQ_TO | 0x00800028 | Request timeout (0xFFFFF = ~1 sec) |
| BUS1_DIR_MAP | 0x00800080 | **Direct map register** (DMA translation) |
| BUS1_MAP_FAULT_ADDR_ | 0x00800090 | Page map fault address |

#### Per-Device Registers (GPU = dev 2 for PLX at slot 2)
| Register | Address | Description |
|----------|---------|-------------|
| BUS1_DEV0_REG | 0x00800200 | Device 0 config |
| BUS1_DEV1_REG | 0x00800208 | Device 1 config |
| BUS1_DEV2_REG | 0x00800210 | **Device 2 config (PLX bridge)** |
| BUS1_DEV3_REG | 0x00800218 | Device 3 config |
| BUS1_DEV0_WR_FLUSH | 0x00800240 | Device 0 write flush |
| BUS1_DEV1_WR_FLUSH | 0x00800248 | Device 1 write flush |
| BUS1_DEV2_WR_FLUSH | 0x00800250 | **Device 2 write flush** |
| BUS1_DEV3_WR_FLUSH | 0x00800258 | Device 3 write flush |

#### RRB (Read Response Buffer) Status
| Register | Address | Description |
|----------|---------|-------------|
| BUS1_RR_BUFF_STATUS | 0x00800290 | RRB VALID[31:16] and INUSE[15:0] bits |
| BUS1_RR_BUFF_CLR | 0x00800298 | Clear RRB entries |
| BUS1_E_DEV_RSP_BUF | 0x00800280 | Even device response buffer |
| BUS1_O_DEV_RSP_BUF | 0x00800288 | Odd device response buffer |

#### PCI Read Response Buffers (16 buffers × upper+lower)
| Register | Address | Key Fields |
|----------|---------|------------|
| BUS1_PCI_RD_RESP0_UPP | 0x00800300 | FILLED, ARMED, FLUSH, XERR, PKTERR, TIMEOUT |
| through BUS1_PCI_RD_RESP15_UPP | 0x008003F0 | (16 buffers total) |
| BUS1_PCI_RD_RESP0_LOW | 0x00800308 | Lower address bits |
| through BUS1_PCI_RD_RESP15_LOW | 0x008003F8 | |

#### Performance Counters (per buffer, 8 buffers)
| Register Pattern | Description |
|-----------------|-------------|
| BUS1_BUF*_FLUSH_CNT_DATA_TOUCH | Flush count with data |
| BUS1_BUF*_FLUSH_CNT_NO_DATA_TOUCH | Flush count without data |
| BUS1_BUF*_REQ_FLIGHT_CNT | Requests in flight |
| BUS1_BUF*_PREFETCH_REQ_CNT | Prefetch requests |
| BUS1_BUF*_TOT_PCI_RETRY_CNT | **Total PCI retries** |
| BUS1_BUF*_MAX_PCI_RETRY_CNT | Max PCI retries |
| BUS1_BUF*_MAX_LAT_CNT | Max latency count |

#### PCI-X Write Buffers (8 buffers)
| Register Pattern | Description |
|-----------------|-------------|
| BUS1_PCI_X_WR_BUF*_ADDR | Write buffer address |
| BUS1_PCI_X_WR_BUF*_ATTR | Write buffer attributes |
| BUS1_PCI_X_WR_BUF*_VALID | Write buffer valid bit |

---

## DEV Register Bit Fields (BUS*_DEV*_REG)

These are the per-device registers that control PIO and DMA attributes for
each PCI device slot. For the GPU (behind PLX at dev 2), `BUS1_DEV2_REG` is
the critical register.

| Bit | Name | Description |
|-----|------|-------------|
| 28 | EN_ERROR_LOCK | Enable error lock |
| 27 | EN_PAGE_CHK | Enable prefetcher page cross checking |
| 26 | FORCE_PCI_PAR | Force PCI parity error (test) |
| 25 | EN_VIRTUAL | Enable virtual device |
| 23 | DIR_WRT_GEN | **Direct mapped write gather enable** |
| 22 | DEV_SIZE | Device size |
| 21 | REAL_TIME | Real time device enable |
| 19 | SWAP_DIRECT | Enable swapping in direct map mode |
| 18 | PREFETCH | **Prefetcher enable** |
| 17 | PRECISE | Precise transaction |
| 16 | COHERENT | **Coherent transaction** |
| 15 | BARRIER | **Barrier transaction** |
| 14 | GBR | GBR enable |
| 13 | DEV_SWAP | Device enable swapping |
| 12 | DEV_IO_MEM | Device memory or I/O space |
| 11:0 | DEV_OFF | **Device offset address bits [31:20]** |

**Key questions for GPU debugging:**
- Is COHERENT set? (bit 16) — controls cache coherency for DMA
- Is BARRIER set? (bit 15) — controls barrier behavior
- Is PREFETCH set? (bit 18) — prefetcher for DMA reads
- Is DIR_WRT_GEN set? (bit 23) — write gathering for DMA writes

---

## INT_STATUS Bit Fields (Error Flags)

The `BUS*_INT_STATUS` register has 46 error/interrupt bits:

| Bit | Name | Description |
|-----|------|-------------|
| 45 | PCI_X_SPLIT_MES_PE | Split completion message parity error |
| 44 | PCI_X_SPLIT_EMESS | Split completion error message |
| 43 | PCI_X_SPLIT_TO | Split completion timeout |
| 42 | PCI_X_UNEX_COMP | Unexpected completion cycle |
| 41 | INT_RAM_PERR | Internal RAM parity error |
| 40 | PCI_X_ARB_ERR | Device requesting arb error |
| 39 | PCI_X_REQ_TOUT | **Read request timeout** |
| 38 | PCI_X_TABORT | Target abort |
| 37 | PCI_X_PERR | PERR |
| 36 | PCI_X_SERR | SERR |
| 35 | PCI_X_MRETRY | PIO retry counter exhausted |
| 34 | PCI_X_MTOUT | **Master timeout** |
| 33 | PCI_X_DA_PARITY | Data cycle parity error |
| 32 | PCI_X_AD_PARITY | Address/attribute parity error |
| 30 | PMU_PAGE_FAULT | Invalid PCI page access |
| 29 | UNEXPECTED_RESP | **Unexpected response arrived** |
| 28 | BAD_XRESP_PACKET | Response packet size mismatch |
| 27 | BAD_XREQ_PACKET | Request packet size mismatch |
| 26 | RESP_XTALK_ERROR | Response had error bit or invalid sideband |
| 25 | REQ_XTALK_ERROR | Request had error bit or invalid sideband |
| 24 | INVALID_ACCESS | Invalid address/access type |
| 23 | UNSUPPORTED_XOP | Unsupported request operation |
| 22 | XREQ_FIFO_OFLOW | Request packet overflow |
| 21 | LLP_REC_SNERROR | LLP sequence number error |
| 20 | LLP_REC_CBERROR | LLP check bit error |
| 19 | LLP_RCTY | LLP receiver retry count interrupt |
| 18 | LLP_TX_RETRY | LLP transmitter retry |
| 17 | LLP_TCTY | LLP transmitter retry count interrupt |
| 15 | PCI_ABORT | PCI slave abort |
| 14 | PCI_PARITY | PIC detected parity error |

---

## DIR_MAP Register Fields

The `BUS*_DIR_MAP` register controls how 32-bit DMA addresses in the
0x80000000-0xFFFFFFFF range are translated to 50-bit physical addresses.

| Bits | Name | Description |
|------|------|-------------|
| 20:17 | DIR_W_ID | Direct space target widget ID |
| 17 | DIR_ADD512 | Add 512MB offset (when DIR_OFF=0) |
| 16:0 | DIR_OFF | **Direct map offset — forms bits [47:31] of physical address** |

The 32-bit DMA address [30:0] becomes the lower 31 bits of the physical address.
DIR_OFF provides bits [47:31]. Together they form the full 48-bit physical target.

---

## Recommended Post-MCA Debugging Procedure

### Prerequisites
1. L3 workstation (x86 Linux PC) with sscope tools installed
2. Ethernet connectivity to L2 system controller
3. L1 firmware version ≥ 1.19.10 for auto-configuration
4. **Know your L2 hostname or IP** (e.g., `l2-myaltix`)

### Before First Use: Discover Chip Names

You must discover the exact `-chip` triplets for your system. Run
errdmp once while the system is healthy to capture them:
```bash
errdmp --l2 <L2_host> -verbose -fast 2>&1 | grep "^ADD"
```
This will print lines like:
```
ADD SH1 SHUB0: brick=001c01 board=NODE0 chip=SHUB0
ADD SH1 SHUB1: brick=001c01 board=NODE1 chip=SHUB1
ADD PIC: brick=001i14 board=IO9 chip=PIC0
```

Record the triplets. For the examples below, substitute your actual values:
- `$PIC_CHIP` → your PIC triplet, e.g., `001i14:IO9:PIC0`
- `$SHUB_CHIP` → your SHub triplet, e.g., `001c01:NODE0:SHUB0`

### After MCA occurs:

**Step 1: Do NOT reboot.** System controllers remain powered.

**Step 2: Full error dump (errdmp auto-discovers, no -chip needed)**
```bash
errdmp --l2 <L2_host> -pic -ii > post_mca_$(date +%Y%m%d_%H%M%S).txt
```

This captures ~30 seconds per node. The dump includes:
- All SHub error registers (tells us WHAT error)
- PIC bridge registers (tells us WHERE on PCI bus)
- II CRB/WRB state (tells us what I/O operations were in flight)
- PIC DMA error address registers (tells us the exact failing address)

**Step 3: Check specific PIC registers for the GPU's bus**
```bash
# Substitute your actual PIC chip triplet discovered above
mmr_dump --l2 <L2_host> -chip $PIC_CHIP \
  -n "BUS1_INT_STATUS BUS1_PCI_X_DMA_ERR_ADDR BUS1_PCI_X_DMA_ERR_ATTR BUS1_DIR_MAP BUS1_DEV2_REG BUS1_RR_BUFF_STATUS BUS1_BRIDGE_STAT BUS1_PCI_X_READ_REQ_TOUT"
```

**Step 4: Check SHub error state**
```bash
# Substitute your actual SHub chip triplet discovered above
mmr_dump --l2 <L2_host> -chip $SHUB_CHIP \
  -n "SH_PI_FIRST_ERROR SH_PI_ERROR_SUMMARY SH_PI_ERROR_DETAIL_1 SH_PI_ERROR_DETAIL_2 SH_FIRST_ERROR"
```

**Step 5: Read WRB state (if errdmp didn't capture it)**
```bash
mmr_dump --l2 <L2_host> -chip $SHUB_CHIP \
  -n "II_ICRB0_A II_ICRB0_B II_ICRB0_C II_ICRB0_D II_ICRB0_E II_ICRB1_A II_ICRB1_B II_ICRB1_C II_ICRB1_D II_ICRB1_E"
```

### Interpreting Results

1. **Check SH_PI_FIRST_ERROR** — This tells us the class of error:
   - Bits indicating FSB/memory errors → memory corruption
   - Bits indicating II errors → I/O interface problem → PIC/PCI
   - Bits indicating XN errors → crossbar/NUMAlink

2. **Check BUS1_INT_STATUS** — Look for:
   - `PCI_X_REQ_TOUT` (bit 39) → Read request timed out (device not responding)
   - `PCI_X_MTOUT` (bit 34) → Master timeout (PIO stuck)
   - `UNEXPECTED_RESP` (bit 29) → Spurious response from device
   - `PMU_PAGE_FAULT` (bit 30) → Invalid DMA address through GART

3. **Check BUS1_PCI_X_DMA_ERR_ADDR** — The exact DMA address that caused error

4. **Check BUS1_RR_BUFF_STATUS** — If all INUSE bits are set and no VALID bits,
   RRBs are exhausted (device consuming all read response buffers)

5. **Check WRB deallocation** — errdmp reports count; should be 20 (all free).
   If fewer are free, WRBs are stuck/exhausted.

---

## Accessing Registers from Linux (Alternative to JTAG)

While sscope tools use JTAG via L1/L2, some PIC registers can also be read
from within a running Linux kernel via MMIO. The SHub's Global MMR space
provides access to PIC registers at:

```
Base: 0xC0000000_<NASID>_<widget>_<offset>
```

For widget 15, bus 1, the PIC registers are at the offsets shown in the
register tables above, offset by the widget and bus base. The Linux kernel's
`pcibr_provider.c` accesses these registers internally. Adding printk
instrumentation at strategic points in the kernel PIC driver code can
provide similar information to the JTAG tools, but only while the system
is running (not after crash).

---

## Files Extracted for Reference

The following library files from the IST package contain the most valuable
documentation:

- `pic_01_mmrs.pm` — Complete PIC ASIC register map (13,582 lines)
- `shub_01_mmrs.pm` — Complete SHub register map
- `ii_regs.pm` — SHub I/O Interface decode logic
- `error_regs.pm` — Error register framework
- `errdmp` — Full error analysis with decode logic
