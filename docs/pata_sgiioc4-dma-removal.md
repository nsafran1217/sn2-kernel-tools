# pata_sgiioc4: Why DMA Was Removed

## Background

The SGI IOC4 chipset provides a single ATA channel on IO9 and IO10
I/O cards in SGI Altix (SN2) systems. The channel is exclusively
used for optical drives (CD/DVD-ROM) — no hard drives are attached
to the IOC4 IDE port.

The original driver (`drivers/ide/sgiioc4.c`) was removed from the
kernel when the entire IDE subsystem was deleted in Linux v5.14
(commit `afee7f30da5c`). A new libata-based driver (`pata_sgiioc4.c`)
was written as a replacement. During testing, all DMA transfers to
ATAPI devices failed. The driver was modified to force PIO-only
operation via a `mode_filter` callback.

This document explains why.


## The Problem: ATAPI DMA Causes HSM Violations

When the new libata driver was tested with DMA enabled, every ATAPI
Read(10) command failed with:

```
ata5.00: ST_FIRST: !(DRQ|ERR|DF)
ata5.00: cmd a0/01:00:00:00:fc/00:00:00:00:00/a0 tag 0 dma 65536 in
         Read(10) 28 00 00 00 00 00 00 00 20 00
         res 50/00:00:00:00:fc/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata5.00: status: { DRDY }
```

The `Emask 0x2` (HSM violation) and `ST_FIRST: !(DRQ|ERR|DF)` mean
that libata's Host State Machine expected to see DRQ (Data Request)
asserted after sending the ATAPI PACKET command, but instead found
only DRDY (Device Ready) — the device had already completed its
part of the protocol and was waiting for the DMA engine, which never
ran.


## Root Cause: IDE Polled, libata Waits for Interrupts

The fundamental issue is a protocol mismatch between how the old IDE
subsystem and the new libata framework handle ATAPI DMA transfers.

### ATAPI DMA Protocol

An ATAPI DMA transfer follows these steps:

1. Host writes PACKET command (0xA0) to the command register
2. Device asserts DRQ to request the Command Descriptor Block (CDB)
3. Host writes the 12-byte CDB (e.g. Read(10)) to the data register
4. Device processes the CDB and prepares data
5. Device asserts DRQ to signal it is ready for DMA
6. Host starts the DMA engine
7. DMA engine transfers data
8. Device de-asserts DRQ and asserts IRQ to signal completion

The critical step is **step 5 → 6**: how the host knows DRQ is
asserted and that it should start the DMA engine.

### How the Old IDE Driver Handled It

The IDE subsystem used `ide_transfer_pc()` which **polled** the
device status register in a busy-wait loop after writing the CDB.
It would spin reading the status register until DRQ appeared, then
start the DMA engine immediately. The relevant flow was:

```
ide_transfer_pc()
  → writes CDB to data port
  → polls status register waiting for DRQ
  → calls dma_start() when DRQ seen
```

This polling approach works because:
- It doesn't depend on the IOC4 generating a DRQ interrupt
- The transition from "CDB written" to "DRQ asserted" is detected
  by the CPU actively checking, not by waiting for hardware events
- The DMA engine is started immediately after DRQ, before the
  device can time out

### How libata Handles It

libata's ATAPI DMA path is interrupt-driven. The sequence is:

```
ata_bmdma_qc_issue()
  → calls bmdma_setup() — programs DMA engine
  → writes PACKET command to command register
  → writes CDB to data port
  → RETURNS — waits for interrupt
  
[interrupt fires]
ata_bmdma_interrupt()
  → calls bmdma_status() — checks for DMA interrupt
  → reads device status
  → if DRQ set and in correct HSM state, calls bmdma_start()
```

This interrupt-driven approach fails on the IOC4 because:

1. **The IOC4 may not generate a reliable interrupt for ATAPI DRQ
   assertion.** The IOC4's interrupt register (at offset 0x00 from
   BAR0) has two bits: bit 0 for IDE command completion and bit 1
   for PCI DMA errors. There is no documented interrupt source for
   "DRQ is now asserted after PACKET/CDB."

2. **Reading the IOC4 status register clears the interrupt.** The
   IOC4 has a side effect where reading the ATA status register
   (offset 0x11C from BAR0) clears pending interrupts. This was
   noted in the original driver's `sgiioc4_read_status()`:

   ```c
   if (!(reg & ATA_BUSY)) {
       /* Not busy... check for interrupt */
       unsigned long other_ir = port - 0x110;
       unsigned int intr_reg = readl(other_ir);
       /* Clear the Interrupt, Error bits on the IOC4 */
       if (intr_reg & 0x03)
           writel(0x03, other_ir);
   }
   ```

   This means that if libata's interrupt handler reads the status
   register at the wrong moment, the interrupt evidence disappears
   before the HSM can act on it.

3. **libata expects DRQ at a specific HSM state.** When the
   interrupt handler fires and finds the HSM in `ST_FIRST` state
   (waiting for the first data phase after PACKET), it checks for
   DRQ. If DRQ is not set — because the interrupt was for something
   else, or the timing is wrong — it logs `ST_FIRST: !(DRQ|ERR|DF)`
   and reports an HSM violation.


## Why PIO Works

In PIO mode, libata's ATAPI path sends the PACKET command, writes
the CDB, and then polls for DRQ using `ata_sff_hsm_move()` in a
polled fashion (or via a workqueue that checks status). The status
register read that checks for DRQ doesn't depend on an interrupt
having fired first. The IOC4's status-clears-interrupt side effect
is harmless in PIO mode because no DMA engine needs to be coordinated.


## The Fix: mode_filter Forces PIO

The driver implements a `mode_filter` callback that strips all DMA
modes:

```c
static unsigned int sgiioc4_mode_filter(struct ata_device *adev,
                                        unsigned int xfer_mask)
{
    xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
    return xfer_mask;
}
```

This causes libata to negotiate PIO4 instead of MWDMA2 during device
configuration. The DMA engine infrastructure (PRD table allocation,
bmdma_setup/start/stop, ending DMA area) is retained in the driver
for potential future use but is never exercised in normal operation.


## Performance Impact

The IOC4 IDE port is connected to optical drives only. Maximum
sustained read speed for a DVD-ROM is approximately 22 MB/s (16x),
well within PIO4's theoretical 16.7 MB/s maximum — and in practice,
optical drives rarely sustain maximum speed due to seek times and
media quality. The CPU overhead of PIO is negligible on SN2 Altix
systems which have Itanium 2 processors running at 1.5–1.6 GHz.

A typical use case is booting from a CD/DVD or reading installation
media, neither of which is performance-sensitive.


## Alternatives Considered

### Custom ATAPI interrupt handler

A custom interrupt handler could be written that implements the
IDE-style polling loop for ATAPI transfers while using interrupts
for ATA transfers. This would require reimplementing significant
portions of libata's HSM, defeating the purpose of using libata.

### Hooking qc_issue for ATAPI

The driver could override `qc_issue` to detect ATAPI DMA commands
and convert them to PIO on the fly. This adds complexity for no
real benefit given the optical-only use case.

### Using ata_sff_port_ops with polling

Using `ata_sff_port_ops` instead of `ata_bmdma_port_ops` changes
the interrupt handler but does not fix the fundamental issue of
IOC4's interrupt behavior with ATAPI DMA. Testing confirmed that
`ata_sff_interrupt` had even worse behavior (the original `Emask 0x40`
internal errors) because it reads status before checking DMA state.

### PIO-only (chosen)

The simplest, most reliable, and fully adequate solution. Zero risk
of DMA-related failures, no performance concern for optical media,
and minimal code complexity.
