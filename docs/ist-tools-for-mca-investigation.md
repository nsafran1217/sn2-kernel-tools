# IST Tools Applied to GPU MCA Investigation

Rewritten 2026-10-10 after the tools were checked against pople (Altix 350, IP41,
C-brick `001c02`, SHub 1.2, NASID 0). The earlier version assumed `mmr_dump` could
target a PIC chip. **It can't on this machine.** For tool background see
`ist-tools-analysis.md`. For day-to-day commands see `../claude_tools/README.md`.

## What IST can and can't see on the Altix 350

| Want | How | Notes |
|------|-----|-------|
| SHub error state (PI/LB/XN/MD/NI FIRST_ERROR, SUMMARY, DETAIL) | `altix errdmp` (errdmp `-ii`) or `altix mmr shub <REGS>` | The core of every dump |
| SHub PI CRBs (RRB/WRB/IRB/PRB) | in every errdmp | `altix errdmp-summary` tallies busy entries |
| SHub II registers + II CRBs (`II_ICRB*`, `II_WSTAT`, `II_IIDEM`…) | errdmp `-ii` | |
| PIC crossbow (`XB_*`) | errdmp `-ii` | |
| PIC BUS0/BUS1 error registers, DEV0-3_REG, BRIDGE_ID/STAT/CTRL | errdmp `-ii` | Read through the SHub packet generator, not JTAG |
| PIC DIR_MAP, RR_BUFF_STATUS, PCI_RD_RESP*, retry/latency counters, PCI_X_WR_BUF*, INT_ENABLE/INT_DEV/INT*_HOST_ADDR | **not via IST** | Only in errdmp's `-pic` list, which has no target on a 350. Read from the kernel (pcibr MMIO accessors / debug printk) |
| Anything with `mmr_dump -chip …PIC…` | **impossible** | IP41 JTAG chain has only `001c02:NODE:SHUB0` |

Capture procedure after an MCA, hang, or panic:

1. Don't reset. (`panic=0` on the `test` ELILO label keeps a panicked box frozen.)
2. `altix errdmp --name <label>`: about 28 s, then prints a triage summary.
3. `altix console since-mark <mark>` (or `altix console tail -n 200`) to get the SAL/MCA
   console output.
4. `altix boot` to recover.

`altix watch --errdmp --label <x>` does steps 1–2 automatically when a
panic/oops/MCA line shows up on the console.

## Open questions, revisited

### Q1: What SHub/PIC error triggers the MCA?

**IST:** errdmp's Final Error Summary decodes `SH_FIRST_ERROR`, `SH_PI_FIRST_ERROR`,
`SH_PI_ERROR_SUMMARY`, and `SH_PI_ERROR_DETAIL_1/2` (address, command, source chiplet).

**Already known from April dumps** (`sn2-ist-dumps/old/after-mca`, `minecraft-mca`):
`SH_FIRST_ERROR` = PI_HW_INT, `SH_PI_FIRST_ERROR` = FSB_PROTO_ERR,
`SH_PI_ERROR_SUMMARY` adds FSB_TBL_MISS, `DETAIL_1` command SN2NET_PFCL with source
chiplet MD, and one CPU's LED stuck at `SAL_PMI entered`. FRU summary: "PI Reported
FSB Proto Error". The PIC BUS1 error registers were clean in those dumps.

**Action:** compare `SH_PI_ERROR_DETAIL_1`'s address with the SAL record's +080 field
on the next MCA.

### Q2: Are WRBs exhausted under heavy GPU DMA?

**Answered from existing dumps: no.** errdmp's "Deallocated WRB count != 20. Actual
value: 0x0" is **not** evidence. It shows up in every dump, including an idle healthy
one, because errdmp only counts WRBs carrying a boot-PROM timeout signature
(NASID^0x400 with TO set; see `pi_tools.pm`). The real indicator is the
`WRB[n] … STATE=` field. In `after-mca`, `minecraft-mca`, `DUMP-HUNG`, and
`HUNG-wating for mca`, **all 32 WRBs are FREE**. The only busy CRBs are one or two
RRB/PRB entries in `WRESP` state.

Note that these are SHub PI CRBs (CPU side), not the PIC's PCI-X write buffers. The
PIC's `PCI_X_WR_BUF*_VALID` registers are not readable through IST here.

### Q3: PIC RRB (read response buffer) exhaustion?

**Not visible to IST on the 350.** `BUSn_RR_BUFF_STATUS` and `PCI_RD_RESP*` exist
only in errdmp's `-pic` list. To check this, read them from the kernel (pcibr MMIO)
before and during load. The kernel's view at boot (`p_rrb_map`) is in
`sn2-known-facts.md`.

### Q4: What DEV register settings does the kernel program?

**IST:** errdmp `-ii` dumps and decodes `BUS1_DEV0_REG`…`BUS1_DEV3_REG`. Grab a baseline
on a booted system and diff it after the driver loads:
```bash
altix errdmp --name devregs-before-amdgpu
altix ssh 'modprobe amdgpu'
altix errdmp --name devregs-after-amdgpu
diff <(grep -A12 'BUS1_DEV2_REG ' <before>) <(grep -A12 'BUS1_DEV2_REG ' <after>)
```
Bits that matter: COHERENT (16), BARRIER (15), PREFETCH (18), DIR_WRT_GEN (23),
DEV_OFF (11:0). A kernel-side printk of `pcireg_device_get()` also works.

### Q5: What does DIR_MAP look like?

**Not visible to IST on the 350.** Read it from the kernel. The value the kernel
programs (`p_dir_map` = `0x0000000000b00000`) is recorded in `sn2-known-facts.md`.

### Q6: PIC interrupt configuration

`BUS1_INT_STATUS` / `ERR_INT_VIEW` / `MULT_INT` are in errdmp `-ii`. `INT_ENABLE`,
`INT_DEV`, and `INT*_HOST_ADDR` are not. Use the kernel's `p_int_enable` (also in
`sn2-known-facts.md`) or a printk.

### Q7: PCI retry counts and latency

**Not visible to IST on the 350** (`BUFn_TOT_PCI_RETRY_CNT`, `MAX_LAT_CNT`, and
`BRIDGE_REQ_TO` are `-pic` only). Kernel instrumentation is the only way to get them.

### Q8: Decode the SAL platform error record

The SAL record's SGI platform section (GUID `e429faf1-3cb7-11d4-bca7-0080c73c8881`)
is a snapshot of the same SHub registers. Plan: after the next MCA, run
`altix errdmp -noparse` (raw values only) **and** capture the SAL record from the
console log, then match offsets to register values. The `error_regs.pm` constants
(`$EREG_FIRST_ERROR=0`, `$EREG_DETAIL_1..3=1..3`, `$EREG_SUMMARY=6`,
`$EREG_OVERFLOW=7`) show the register grouping errdmp uses.

## Reading a dump

`altix errdmp-summary <file>` prints:
- registers flagged `<<<<<<<`, with this box's known-normal ones hidden:
  NI0/NI1 LLP (no NUMAlink cable), `SH_XNLB_INTRA_FLOW`,
  `SH_XNPI_FR_IILB_PORT_FLOW_FIFO`, `SH_PIO_WRITE_STATUS_0/1` (live system), and
  `BUS0_ERR_INT_VIEW`/`BUS0_MULT_INT` = PCI_X_ARB_ERR (always latched on base-IO)
- alerts (deduplicated)
- SHub PI CRB busy/total counts, plus the busy entries
- CPU LED state
- errdmp's Final Error Summary (decoded error registers, timestamps, FRU summary,
  pending PIO addresses, config summary)

Reference dumps (`/mnt/nfs/altix/sn2-ist/dumps/errdmp/`):

| File | State | Signature |
|------|-------|-----------|
| `errdmp_26_Sat_Oct_10_19_09-claude-healthy-baseline` | idle, healthy | 0 real flags; LEDs toggle busy/idle |
| `errdmp_26_Sat_Oct_10_19_30-panic-sysrq-panic0` | frozen after sysrq-c panic | no HW error registers; both LEDs `Kernel: CPU busy` "Not toggling!" |
| `errdmp_26_Sat_Oct_10_19_18-panic-sysrq-test` | panic with a 30 s reboot mid-dump | adds "ALERT: Aborted II register read…", a reset artifact |
| `../../old/after-mca` (Apr 14) | GPU MCA | PI_HW_INT / FSB_PROTO_ERR, DETAIL_1/2 set, CPU in `SAL_PMI entered` |
