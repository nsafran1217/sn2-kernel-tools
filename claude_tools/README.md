# claude_tools — driving the Altix test box end to end

Tooling for building, booting, and debugging kernels on the SGI Altix 350 without
anyone at the keyboard. Everything goes through one CLI, `altix` (Python 3, stdlib
only), plus the existing `../ia64-build.sh`.

```bash
export PATH=$PATH:~/projects/altix_cross/sn2-kernel-tools/claude_tools
ia64-build.sh                      # build + deploy to the boot server (vmlinuz-test)
altix boot                         # reboot (or power up / reset) and wait for login+ssh
altix ssh 'dmesg | grep -i sn2'    # run things on the box
altix watch --errdmp               # block until panic/MCA, then grab IST error state
```

## Topology

| Role | Host | Access | Notes |
|------|------|--------|-------|
| Target | `pople` (10.40.0.161) | `ssh root@pople` (key auth; pw `computer`) | Altix 350, one C-brick `001c02`, 2 CPUs, NASID 0, SHub 1.2, NFS root. **Hard disks removed** (2026-10-10) so it can only netboot |
| L3 | `l3.ad.nsafran.com` (10.40.0.162) | `ssh nathan@l3…` (RSA key installed; pw `computer`) | Fedora Core 1-era i686, kernel 2.4.22, OpenSSH 3.6 (**needs `ssh-rsa`**; no ed25519). IST in `/stand/sysco/bin`. L1 attached over USB (`sgil1` module, `/dev/sgil1_0`) |
| Hardware L2 | `nl4r` (10.40.0.163) | `telnet nl4r`, no password | Not currently in use: the L3 runs the L2 software instead |
| Boot server | `netboot` (10.40.0.121) | `ssh 10.40.0.121` | TFTP `/t2/tftproot` (ELILO + `elilo.conf`), NFS root `/t2/altixroot` |
| NFS | `nfs` / truenas | `/mnt/nfs` on both the workstation and the L3 | errdmp output: `/mnt/nfs/altix/sn2-ist/dumps/errdmp/` (= `~/projects/altix_cross/sn2-ist-dumps/dumps/errdmp`) |

How the pieces connect:

```
workstation ──tcp 8001 (plain text SMP)──► L2 software on l3 ──USB──► L1 in 001c02 ──► system console / power / JTAG
workstation ──ssh──► l3: errdmp / mmr_dump ──tcp 8000──► same L2 ──► JTAG scan
workstation ──ssh──► pople (once Linux is up)
```

## The L2 interface

The software L2 (`/stand/sysco/bin/l2`) listens on:

- **8000**: binary protocol used by `l2cmd`, `l2term`, and the IST scan tools.
- **8001, 8003**: plain-text "SMP" terminals. This is the same interface you get by
  telnetting to a hardware L2. `altix` talks to 8001 directly, so neither `l2term`
  nor anything on the L3 is needed for console or power control.

Session behavior (verified):

- A new session starts at the `?-127.0.0.1-L2>` prompt.
- **CTRL-D** enters system-console mode; **CTRL-T** escapes back to L2.
- After CTRL-T, a **blank line drops you back into console mode**. Send `l2` first
  ("L2 command processor engaged") and the session stays in L2 mode. `altix` always
  does this.
- Several sessions can sit in console mode at once, and all of them see the output.
- The L2 writes its own `INFO: SMP accepted network connection…` and
  `INFO: Connection - nathan … running 'scan'` notices into console sessions, so they
  show up interleaved in the console log (sometimes mid-line, e.g. after `Password:`).
- `sel` / `select` work only from an SMP session, not from `l2cmd`.

Useful L2 commands: `pwr` (status), `pwr u`, `pwr d`, `rst`, `sel`, `config`, `log`,
`hlp <cmd>`. Through `altix`: `altix power [up|down]`, `altix reset`,
`altix l2 '<anything>'`.

### Starting the software L2 on the L3

The L2 must be running before anything else works (`l2cmd` reports "could not find an
L2 controller"). The L3 has no screen/tmux, so `altix l3 start-l2` runs it detached
under `setsid`, with stdin held open by a FIFO (`~/.l2.fifo`) and output going to
`~/l2.log`:

```bash
altix l3 status      # is it running? tail of ~/l2.log
altix l3 start-l2
altix l3 stop-l2
```

If the L3 reboots, run `altix l3 start-l2` and then `altix console start`. (The console
logger reconnects on its own every 10 s, but it needs an L2 to connect to.)

### Using the hardware L2 (nl4r) instead

Stop the software L2 first: both cannot own the L1. Then:

```bash
export ALTIX_L2_HOST=nl4r ALTIX_L2_PORT=23 ALTIX_IST_L2=nl4r
```

`altix` handles telnet IAC negotiation. Verified 2026-10-10 with the 8-node pople:
`altix l2 pwr`, `altix console start` and `altix mmr shub …` all work through nl4r
(9 bricks in the scan chain). The IST
tools still run on the L3, pointed at `--l2 nl4r` (your history has `errdmp --l2 l2 -ii`
from when that was the setup).

## Console logging

`altix console start` forks a daemon on the workstation. It holds one L2 session in
console mode and appends everything to `~/projects/altix_cross/logs/altix/console.log`,
with a `[YYYY-MM-DD HH:MM:SS]` prefix on each line. ANSI/OSC escapes (including systemd's
OSC 3008 markers) and CRs are stripped. It reconnects if the L2 goes away, and goes back
into console mode if its session ends up at the L2 prompt.

```bash
altix console status | start | stop
altix console tail [-n 100] [-f]
altix console mark "before modprobe amdgpu"     # in-order marker line: ### MARK …
altix console since-mark "before modprobe"      # everything after the latest matching mark
altix console wait 'regex' --timeout 300        # block until new output matches
altix console send 'text'                       # type a line on the console (adds CR)
altix console send --raw '\x03'                 # raw bytes, no CR (here CTRL-C)
```

Each `altix boot` saves its own slice of the log to `logs/altix/boots/<timestamp>.log`.

Notes:
- You don't need to log in on the serial console. Use ssh. The console is for
  watching.
- `console wait` only matches output that arrives *after* it starts.
- Avoid a bare `MCA` regex: every boot prints "Increasing MCA rendezvous timeout…" and
  "MCA related initialization done". The boot/watch patterns are stricter.

## Boot cycle

```bash
altix boot                     # auto: power up if off, else `reboot` over ssh, else L2 reset
altix boot reset               # hard reset via L2
altix boot power-cycle         # pwr d, 10 s, pwr u
altix boot --panic 0           # after boot, sysctl kernel.panic=0 (see below)
altix boot --label "amdgpu uvd fix"   # text for the console marker
```

`boot` marks the console log, triggers the boot, then watches the console for login,
panic, oops, or MCA/INIT patterns, and polls ssh. The exit code is 0 when the box is up
and answering ssh, 1 on a crash or timeout (the last 60 console lines are printed),
and 2 if login showed up but ssh never did.

Measured timings:

| Phase | Power-on | Soft reboot |
|-------|----------|-------------|
| SAL banner | +18 s | +16 s (after shutdown) |
| Memory probe/test/init | ~35 s | (skipped) |
| EFI → ELILO prompt | ~3 min after power-on | ~1.5 min |
| ELILO → kernel → login | ~35 s | ~35 s |
| **Total to ssh** | **~4 min** | **~2 min** |

ELILO (`/t2/tftproot/elilo.conf` on the boot server) has `prompt`, `timeout=50` (5 s),
`default=test`. The `test` label boots `/t2/kernel/vmlinuz-test`, which `ia64-build.sh`
overwrites, with radeon/amdgpu blacklisted. To boot something else or change the
command line, edit `elilo.conf` on the boot server (back it up first). **Typing at the
ELILO prompt over the console does not work**: it was tried, and the L2 answered
"no response from 001c02 console, system not responding". The `*sda` labels are dead
now that the disks are out.

### Panic behavior

The kernel config has `CONFIG_PANIC_TIMEOUT=30`, so a panic reboots after 30 s, and that
reset would hit any errdmp run in progress. The `test` ELILO label now passes
**`panic=0`** (added 2026-10-10; backup at `elilo.conf.bak-20261010-192252` on the boot
server), so a panic now leaves the box frozen for IST. Recover with `altix boot` (no ssh,
so it falls through to an L2 reset). For other labels, add `panic=0` to their `append=`,
or use `altix boot --panic 0`, which sets the sysctl once ssh is up and so doesn't
cover panics during boot.

## IST tools (on the L3)

```bash
altix errdmp                         # errdmp --l2 localhost -ii, then a triage summary
altix errdmp --name after-uvd-mca    # append a suffix to the dump file name
altix errdmp -fast                   # any errdmp flags pass through (default is -ii)
altix errdmp-summary [FILE…]         # triage an existing dump (default: newest)
altix mmr shub SH_PI_FIRST_ERROR SH_PI_ERROR_SUMMARY SH_PI_ERROR_DETAIL_1
altix l3 run '<cmd>'                 # anything else, with /stand/sysco/bin on PATH
```

- errdmp takes about 28 s with `-ii`. It writes to `/usr/people/sgidiag/sn2/dumps/errdmp/`
  on the L3, which is a symlink to the NFS share, so the dump appears locally right away.
  The file name is `errdmp_26_<Day>_<Mon>_<DD>_<HH>_<MM>` (L3 local time).
- **`-ii` is the flag to use on the 350.** It reads the SHub II registers *and* the PIC
  crossbow plus BUS0/BUS1 registers ("PIC Widget F Registers on connected IO brick"),
  going through the SHub packet generator.
- **`-pic` does nothing here.** It targets PIC chips in separate Ix/Px bricks over JTAG,
  and a 350 has none (it ran on a live system with no effect and no crash).
- **mmr_dump only works on the SHub here:** `001c02:NODE:SHUB0` (alias `shub`). The IP41
  JTAG description files (`/stand/sysco/data/scan/cmp/ip41_*.cmp`) contain no PIC.
  For PIC registers, use `errdmp -ii`.
- `errdmp -verbose -fast | grep ^ADD` (suggested in `../docs/ist-tools-analysis.md`)
  prints nothing in errdmp V4.14. Chip names come from the brick (`001c02`), board
  (`NODE`), and chip (`SHUB0`).
- Running errdmp `-ii` and SHub mmr_dump on a live system is fine. You get CPU LEDs
  showing `Kernel: CPU busy/idle`.

### Reading a dump: what's normal on this box

errdmp flags suspicious values with `<<<<<<<`. On a healthy, idle pople these are always
flagged, and `errdmp-summary` hides them:

- `SH_NI0_LLP_ERR` / `SH_NI0_LLP_STAT` / `SH_NI1_LLP_STAT`: no NUMAlink cable
- `SH_XNLB_INTRA_FLOW`, `SH_XNPI_FR_IILB_PORT_FLOW_FIFO`: credit/FIFO test values
- `SH_PIO_WRITE_STATUS_0/1` pending counts: PIO writes in flight on a live system
- `BUS0_ERR_INT_VIEW` / `BUS0_MULT_INT` = `PCI_X_ARB_ERR` (bit 40): always latched on
  the base-IO bus
- `power down (PANEL)` entries in the L1 log

What a real failure looks like (from `sn2-ist-dumps/old/after-mca`): `SH_FIRST_ERROR`
PI_HW_INT, `SH_PI_FIRST_ERROR` FSB_PROTO_ERR, `SH_PI_ERROR_DETAIL_1/2` (address +
source), `SH_PI_HW_TIME_STAMP` valid, CPU LEDs "Not toggling!" with one CPU in
`SAL_PMI entered`, and a FRU Summary line.

Also always present, even on the idle baseline and in nearly every dump since April:
**"Deallocated WRB count != 20. Actual value: 0x0"** under CONFIGURATION ERROR SUMMARY.
It is not evidence of WRB exhaustion on this box (the IST docs suggest it is), so it
can't be used to test the WRB theory.
errdmp only counts WRBs with a boot-PROM timeout signature. The real indicator is the
`WRB[n]`/`RRB[n]` `STATE=` field in the PI CRB tables, and `errdmp-summary` prints
"SHub PI CRBs busy/total" along with the busy entries. Every April MCA/hang dump had
WRB 0/32 busy, and at most 2 RRBs in `WRESP`.

Reset artifact: if the box resets *during* errdmp (as happened with the old 30 s panic
timeout), you get "ALERT: Aborted II register read due to excessive superscope access
errors". With `panic=0` it doesn't happen.

Baselines captured 2026-10-10 in the errdmp directory:
- `errdmp_26_Sat_Oct_10_19_09-claude-healthy-baseline`: idle, clean
- `errdmp_26_Sat_Oct_10_19_30-panic-sysrq-panic0`: frozen after a sysrq-c software
  panic. No hardware error registers set; both CPU LEDs stuck at "Kernel: CPU busy" /
  "Not toggling!". This is the signature of a pure software panic.
- `errdmp_26_Sat_Oct_10_19_18-panic-sysrq-test`: the same panic while the 30 s reboot
  hit mid-dump (shows the reset artifact)

## Standard workflows

### Build and boot-test a change
```bash
ia64-build.sh                                   # builds src/mainline/linux-sn2, deploys vmlinuz-test
altix boot --label "$(git -C ~/projects/altix_cross/src/mainline/linux-sn2 log -1 --format=%h\ %s)"
altix ssh 'uname -r; dmesg --level=err,warn'
```
Check that `uname -r` contains the short sha you just built (`LOCALVERSION=-<sha>-ia64`).
If it doesn't, the box booted something else.

### Reproduce and capture a crash
```bash
altix console mark "start repro"
altix watch --errdmp --label repro1 &           # waits for panic/oops/MCA, then errdmp -ii
altix ssh 'modprobe amdgpu'                     # or whatever triggers it
wait
altix console since-mark "start repro" > repro1-console.log
altix boot                                      # recover (resets if ssh is dead)
```
With `panic=0` the box stays frozen after a panic, so errdmp sees the real state. For
an MCA the console shows the SAL/OS_MCA output. Run errdmp before resetting: the
SHub error registers survive until reset.

### Box is wedged / unknown state
```bash
altix power                  # "power appears off"?
altix console tail -n 80     # what did it last say?
altix errdmp                 # capture before touching anything
altix boot reset             # or: altix boot power-cycle
```

## Configuration (environment variables)

| Variable | Default |
|----------|---------|
| `ALTIX_L2_HOST` / `ALTIX_L2_PORT` | `l3.ad.nsafran.com` / `8001` |
| `ALTIX_IST_L2` | `localhost` (the `--l2` argument passed to IST tools on the L3) |
| `ALTIX_L3` | `nathan@l3.ad.nsafran.com` |
| `ALTIX_TARGET` | `root@pople` |
| `ALTIX_BRICK` | `001c02` |
| `ALTIX_LOG_DIR` | `~/projects/altix_cross/logs/altix` |
| `ALTIX_ERRDMP_DIR` | `/mnt/nfs/altix/sn2-ist/dumps/errdmp` |

## Other L3 tools (not wrapped)

`l2term` (interactive; quit with CTRL-] q), `l2cmd --l2 localhost '<cmd>'`,
`l2find`, `superscope --l2 localhost` (Tk GUI, needs `DISPLAY`), `sn2mon -l2 localhost`,
`elog_decode`, `mem_read`, `scan_ip41`. Man pages for l2cmd/l2term/l2find are in
`~/projects/altix_cross/ist/ist-software-extracted/IST/snxsc_l3/usr/man/man1/`, and
the Perl sources for all sscope tools (errdmp, mmr_dump, register maps
`pic_01_mmrs.pm`, `shub_01_mmrs.pm`, `ii_regs.pm`) are under
`…/IST/sscope/stand/sysco/{bin,lib/sscope}`.
