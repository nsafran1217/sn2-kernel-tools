# IST Tools Applied to GPU MCA Investigation

## Note on Command Examples

All `mmr_dump` commands below use `$PIC_CHIP` and `$SHUB_CHIP` as
placeholders for your actual `-chip` triplets. These must be discovered
from your hardware before first use.

To discover chip names, run errdmp with -verbose while the system is
healthy:
```bash
errdmp --l2 <L2_host> -verbose -fast 2>&1 | grep "^ADD"
```
This prints lines like:
```
ADD SH1 SHUB0: brick=001c01 board=NODE0 chip=SHUB0
ADD PIC: brick=001i14 board=IO9 chip=PIC0
```
Your `$SHUB_CHIP` would be `001c01:NODE0:SHUB0` and `$PIC_CHIP` would
be `001i14:IO9:PIC0` (these are examples — your values will differ).
The board names (`IO9`, `NODE0`, etc.) vary by system and cannot be
guessed — they must come from hardware discovery.

Also replace `<L2_host>` with your L2 controller hostname or IP.

---

## Mapping Tools to Open Questions

This document connects the SGI IST tools to the specific open questions
from the SN2 Radeon GPU MCA investigation (`sn2-turks-mca-investigation-summary.md`).

---

## Open Question 1: What SHub/PIC Error Triggers the MCA?

**Current state:** The SAL platform error section (GUID `e429faf1-3cb7-11d4-bca7-0080c73c8881`)
is in a proprietary SGI format we cannot decode from the kernel side. Field at offset +060
consistently shows `0x09` (error type 9?), and offset +080 shows a physical memory address.

**IST Tool:** `errdmp --l2 <L2_host>`

After MCA, errdmp reads `SH_PI_FIRST_ERROR` (0x20060780) and `SH_PI_ERROR_SUMMARY`
(0x20060680) which contain the decoded error type that SAL reported. These are the
same registers SAL reads to build the platform error section. errdmp includes
full decode logic for these bits, providing human-readable error descriptions.

The `SH_PI_ERROR_DETAIL_1` and `_DETAIL_2` registers provide the failing
address and transaction type, which should match the address we see at
offset +080 in the SAL record.

**Action:** Run errdmp immediately after next MCA. Compare SH_PI_ERROR_DETAIL
values with the SAL record offset +080 address to confirm correlation.

---

## Open Question 2: Are WRBs Exhausted Under Heavy GPU DMA?

**Current state:** Theory that GPU DMA write buffers accumulate in the PIC's
Write Request Buffers because `sn_dma_flush()` is a no-op for the GPU device
(BARs not in flush_nasid_list). The fallback flush uses dev=0 which is on a
different PCI slot than the PLX bridge (dev=2), and PIC WRBs are per-slot.

**IST Tool:** `errdmp --l2 <L2_host>` (default mode includes WRB state)

errdmp reads all PI CRBs and specifically checks WRB deallocation:
```
if WRB_DEALLOC < 18:
    ERROR: "Deallocated WRB count != 20. Actual value: 0x%x"
```
A healthy system should have all 20 WRBs deallocated (free). If the count is
low after MCA, WRBs were stuck/exhausted.

**IST Tool:** `mmr_dump` to read PCI-X Write Buffer state:
```bash
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n \
  "BUS1_PCI_X_WR_BUF0_VALID BUS1_PCI_X_WR_BUF1_VALID \
   BUS1_PCI_X_WR_BUF2_VALID BUS1_PCI_X_WR_BUF3_VALID \
   BUS1_PCI_X_WR_BUF4_VALID BUS1_PCI_X_WR_BUF5_VALID \
   BUS1_PCI_X_WR_BUF6_VALID BUS1_PCI_X_WR_BUF7_VALID"
```
If all 8 VALID bits are set → Write buffers are full → GPU DMA writes
backed up → PIC eventually errors.

**Action:** After next MCA, check WRB count and PCI-X write buffer VALID bits.

---

## Open Question 3: RRB (Read Response Buffer) Exhaustion?

**Current state:** Not yet investigated. Under heavy 3D rendering, the GPU
generates many DMA reads (texture fetches, vertex data). If the PIC's 16 RRBs
for bus 1 are all consumed, all PIO reads and DMA reads would stall.

**IST Tool:** `mmr_dump` or `errdmp -pic`:
```bash
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n "BUS1_RR_BUFF_STATUS"
```

Check `RRB_INUSE` (bits 15:0) — if all 16 bits set, RRBs exhausted.
Also check individual RRB status:
```bash
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n \
  "BUS1_PCI_RD_RESP0_UPP BUS1_PCI_RD_RESP1_UPP ... BUS1_PCI_RD_RESP15_UPP"
```
TIMEOUT bit (26) on any RRB means the GPU didn't respond to a read.

**Action:** Check RRB status after MCA.

---

## Open Question 4: What DEV Register Settings Does the Kernel Program?

**Current state:** We know the kernel's `pcibr_bus_fixup()` programs per-device
registers but haven't verified the actual values for the PLX bridge slot.
Key questions: Is COHERENT set? Is BARRIER set? Is PREFETCH enabled?

**IST Tool:** `mmr_dump`:
```bash
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n "BUS1_DEV2_REG"
```

Decode the 32-bit value:
- Bit 16 (COHERENT): Should be set for cache-coherent DMA
- Bit 15 (BARRIER): Controls DMA ordering guarantees  
- Bit 18 (PREFETCH): GPU DMA read prefetching
- Bit 23 (DIR_WRT_GEN): Write gathering (batching DMA writes)

**Can also read while system is running** via Linux instrumentation:
```c
// In pcibr_bus_fixup() or pcibr_provider.c, add:
u64 dev_reg = pcireg_device_get(pcibus_info, slot);
printk(KERN_INFO "[SN2-PIC] DEV%d_REG = 0x%016llx "
       "COHERENT=%d BARRIER=%d PREFETCH=%d DIR_WRT_GEN=%d\n",
       slot, dev_reg,
       !!(dev_reg & (1 << 16)),  // COHERENT
       !!(dev_reg & (1 << 15)),  // BARRIER
       !!(dev_reg & (1 << 18)),  // PREFETCH
       !!(dev_reg & (1 << 23))); // DIR_WRT_GEN
```

**Action:** Read DEV2_REG both from Linux (instrumentation) and after MCA (JTAG).

---

## Open Question 5: What Does DIR_MAP Look Like?

**Current state:** We know DMA uses 32-bit direct mapped path with
dir_xbase=0x0. But we haven't verified the PIC's DIR_MAP register directly.

**IST Tool:** `mmr_dump`:
```bash
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n "BUS1_DIR_MAP"
```

Decode: DIR_OFF (bits 16:0) provides physical address bits [47:31].
For dir_xbase=0x0, DIR_OFF should be 0x0, meaning all 32-bit DMA in range
0x80000000-0xFFFFFFFF maps to physical 0x00000000_00000000-0x00000000_7FFFFFFF
(lower 2GB of node 0's memory).

**Action:** Verify DIR_MAP value matches expected configuration.

---

## Open Question 6: PIC Interrupt Configuration for GPU

**Current state:** Only 9 GPU interrupts delivered during entire Minecraft test.
`salruntime_sn_intr_handler: Invalid provider_call 3` during MSI setup suggests
incomplete interrupt configuration.

**IST Tool:** `mmr_dump`:
```bash
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n \
  "BUS1_INT_ENABLE BUS1_INT_DEV BUS1_INT_STATUS \
   BUS1_INT0_HOST_ADDR BUS1_INT1_HOST_ADDR BUS1_INT2_HOST_ADDR"
```

Check:
- INT_ENABLE: Which interrupts are enabled
- INT_DEV: How device interrupts map to PIC interrupt lines
- INT*_HOST_ADDR: Where interrupts are targeted (SHub interrupt address)

**Action:** Verify interrupt configuration is correct for MSI delivery.

---

## Open Question 7: PCI Retry Counts and Latency

**Current state:** The 20-25 second freeze before MCA suggests something is
timing out repeatedly. PCI retries could be accumulating.

**IST Tool:** `mmr_dump` or `errdmp -pic`:
```bash
mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n \
  "BUS1_BUF0_TOT_PCI_RETRY_CNT BUS1_BUF1_TOT_PCI_RETRY_CNT \
   BUS1_BUF2_TOT_PCI_RETRY_CNT BUS1_BUF3_TOT_PCI_RETRY_CNT \
   BUS1_BUF0_MAX_PCI_RETRY_CNT BUS1_BUF1_MAX_PCI_RETRY_CNT \
   BUS1_BUF0_MAX_LAT_CNT BUS1_BUF1_MAX_LAT_CNT \
   BUS1_BRIDGE_REQ_TO BUS1_PCI_X_READ_REQ_TOUT"
```

High retry counts → PCI device is busy-retrying (normal for GPU but
extreme values indicate problem). BRIDGE_REQ_TO shows the configured
timeout value. PCI_X_READ_REQ_TOUT captures timed-out read info.

**Action:** Read retry/latency counters after MCA to understand what happened.

---

## Open Question 8: Decode the SAL Platform Error Record

**Current state:** The 9352-byte SAL record has a platform-specific error section
with GUID `e429faf1-3cb7-11d4-bca7-0080c73c8881`. This is SGI's proprietary
format. Consistent fields: +060 has `0x09`, +080 has a physical address.

**IST Tool:** `elog_decode` + `errdmp`

The `elog_decode.pm` library and `errdmp` script contain the decode logic for
SHub error registers. The SAL record's platform error section is essentially
a snapshot of these same registers. By reading the same registers via JTAG
after MCA and comparing with the SAL record hex dump, we can build a mapping:

1. Run `errdmp --l2 <L2_host> -noparse` to get raw register values
2. Compare hex values with our SAL record dump
3. Match offsets in the SAL record to specific SHub register names

The `error_regs.pm` module defines the register decode structure:
```
$EREG_FIRST_ERROR    = 0;
$EREG_DETAIL_1       = 1;
$EREG_DETAIL_2       = 2;
$EREG_DETAIL_3       = 3;
$EREG_SUMMARY        = 6;
$EREG_OVERFLOW       = 7;
```

The value `0x09` at offset +060 likely corresponds to a specific bit pattern
in `SH_PI_FIRST_ERROR` or `SH_FIRST_ERROR`.

**Action:** After next MCA, run errdmp AND capture SAL record. Cross-reference
to build the format mapping.

---

## Suggested Post-MCA Protocol

1. **MCA occurs.** System freezes, then MCA fires.
2. **Do NOT power cycle.** L1/L2 controllers remain alive.
3. **From L3 workstation, run full dump:**
   ```bash
   errdmp --l2 <L2_host> -pic -ii > post_mca_full_$(date +%s).txt
   ```
4. **Save the kernel dmesg** (from serial console if available):
   ```bash
   # On the L1 console, the last dmesg lines should be visible
   # Or save from the L3 if a serial log is running
   ```
5. **Read specific GPU-related registers:**
   ```bash
   mmr_dump --l2 <L2_host> -chip $PIC_CHIP -n \
     "BUS1_INT_STATUS BUS1_PCI_X_DMA_ERR_ADDR BUS1_PCI_X_DMA_ERR_ATTR \
      BUS1_DIR_MAP BUS1_DEV2_REG BUS1_RR_BUFF_STATUS \
      BUS1_PCI_X_WR_BUF0_VALID BUS1_PCI_X_WR_BUF1_VALID \
      BUS1_PCI_X_WR_BUF2_VALID BUS1_PCI_X_WR_BUF3_VALID \
      BUS1_PCI_X_WR_BUF4_VALID BUS1_PCI_X_WR_BUF5_VALID \
      BUS1_PCI_X_WR_BUF6_VALID BUS1_PCI_X_WR_BUF7_VALID \
      BUS1_BUF0_TOT_PCI_RETRY_CNT BUS1_BUF1_TOT_PCI_RETRY_CNT \
      BUS1_BUF0_MAX_LAT_CNT BUS1_BUF1_MAX_LAT_CNT" \
     > post_mca_pic_$(date +%s).txt
   ```
6. **Compare SAL record with errdmp output** to build format mapping.
7. **Power cycle** and capture dmesg from fresh boot for comparison.

---

## Setup Requirements

### Hardware
- L3 workstation: Any x86 Linux PC (32-bit compat libraries needed)
- Ethernet connection to L2 controller
- L2 must be powered and accessible

### Software
- Copy sscope package to L3: `cp -r /stand/sysco /path/on/l3/`
- Set environment:
  ```bash
  export PATH=/path/to/stand/sysco/bin:/path/to/stand/sysco/tools/bin:$PATH
  export LD_LIBRARY_PATH=/path/to/stand/sysco/lib:$LD_LIBRARY_PATH
  export TCL_LIBRARY=/path/to/stand/sysco/lib/tcl8.2
  ```
- Tools are Perl scripts using bundled Perl at `/stand/sysco/tools/bin/perl`
- May need to adjust shebang lines if paths differ

### L2 Controller Access
- The L2 is typically at a hostname like `l2-<machine_name>`
- Default port varies; typically accessible without authentication
- Test with: `errdmp --l2 <L2_host> -sim` (simulation mode, no hardware access)
