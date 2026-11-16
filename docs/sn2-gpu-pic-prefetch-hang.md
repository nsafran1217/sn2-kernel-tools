# GPU "ring gfx timeout" under glmark2: PIC DMA read prefetch

Investigated 2026-11-01 on pople: 1 C-brick (001c02), 2 Madison CPUs, 3.8 GB, Oland behind the
PLX 8112 on PIC bus 0002, Mesa 26.2.3, kernel base `eb5ca12536d3`.

## Summary

PIC's DMA read prefetch can hand the GPU's command processor (CP) stale ring contents. The CP
then runs a job left over from the previous pass of the ring and waits forever on a fence value
that has already gone by.

The fix is a boot option, `sn2_gpu_no_prefetch`, that turns prefetch off for GPUs on PIC. **It is
not merged.** It is commit `179936a536d9` on the linux-sn2 branch `sn2-gpu-pic-prefetch`, checked
out in the worktree `src/mainline/linux-sn2-gpu-prefetch` and based on `eb5ca12536d3`
(`master-epic-sn2-gpu`). See [The kernel change](#the-kernel-change).

**The option is off by default**, so the PROM's setting stays in effect, because turning prefetch off costs
14-19% in glmark2 and the hang has only been seen in glmark2. Minecraft on all bricks, with and
without the option, is still to be tested.

## Symptom

Random, usually within a few minutes of glmark2 in X:

```
amdgpu 0002:01:00.0: ring gfx timeout, signaled seq=968237, emitted seq=968241
amdgpu 0002:01:00.0:  Process X pid 421 thread X:cs0 pid 422
amdgpu 0002:01:00.0: Starting gfx_v6_0 IP block soft reset
amdgpu 0002:01:00.0: Successful gfx_v6_0 IP block soft reset
amdgpu 0002:01:00.0: [drm] device wedged, but no recovery needed
amdgpu: The CS has cancelled because the context is lost. This context is guilty of a hard recovery.
```

- There is no VM fault, no MCA, and errdmp is clean. Nothing failed on the bus.
- X is only the job that happened to be next. It dies because its context is marked guilty.
- The default timeout is 2 s, not 10 s, so the hang starts 2 s before the message.

## Mechanism

1. The PROM sets PREFETCH (bit 18) in PIC's Device(1) register for the PLX slot, `0x12041002`.
   The bus runs in PCI mode, not PCI-X, so DMA reads go through the RRBs.
2. For each DMA read, PIC fetches up to three more 128-byte lines into RRBs and can serve later
   reads from them without going back to memory.
3. The CP reads the end of a job. PIC also captures the first 96 dwords of the next ring slot,
   which still hold the job from the previous pass. amdgpu pads gfx jobs to 256 dwords, and most
   slots start with the same `COND_EXEC`.
4. The CPU writes the new job and moves WPTR.
5. If no other DMA read has flushed those RRBs, the CP reads the old data.
6. An old `WAIT_REG_MEM` compares for *equal* against an old sequence number. The fence has passed
   it, so the PFP polls forever.

Step 5 is why this is rare. Almost any other GPU read gets there first. It needs a fast
CPU-to-GPU turnaround on a ring with nothing else reading, which is what glmark2's 2500 frames per
second provides.

## Evidence

Run 1: frozen hang with `modprobe amdgpu gpu_recovery=0`. Fence 0xac49 signaled, 0xac4c emitted.

**What is in ring memory:**

```
0200 COND_EXEC 0x40c0 0x0 0x2d
0204 WRITE_DATA 0x1520 ...
0209 CONTEXT_CONTROL
020c IB 0xfaa00
```

**What the CP executed:** `CP_PFP_HEADER_DUMP` reads, newest first:

```
c0053c00  WAIT_REG_MEM   <- not at 0x204 in memory, but slots with a pipeline sync have it at +4
c0022200  COND_EXEC      <- 0x200
c0008b00  SWITCH_BUFFER
c0044700  EVENT_WRITE_EOP
c0034300  SURFACE_SYNC
```

Other registers:
- `CP_IB1_BASE` was still `0xfa300`, the previous job's IB. The IB at `0x20c` never started.
- `CP_RB0_RPTR` = 0x250, inside the 0x200-0x25f range the three prefetched lines cover.
- `CP_STALLED_STAT2` = `PFP_MIU_READ_PENDING`, `CP_STAT` = PFP busy, ME finished. MC busy bits in
  `SRBM_STATUS` toggle: the PFP is polling.

**PIC RRBs at that moment** (`picreg dump`):

```
rrb15  820f0000  FILLED|PREFETCH  BE=0x0f  0x84040080   the fence the PFP is polling (GART 0x4080)
rrb9   82ff0000  FILLED|PREFETCH  BE=0xff  0x84040100
rrb11  82ff0000  FILLED|PREFETCH  BE=0xff  0x84040180
rrb13  82ff0000  FILLED|PREFETCH  BE=0xff  0x84040200
```

**Not the PLX:** the PEX 8111 data book says that for PCI Express to PCI reads, "the number of
bytes to read is determined by the Memory Read Request TLP". It does not read ahead in this
direction.

**One step is inferred.** The sequence number the PFP is stuck on lives inside the CP and can't be
read back. Everything around it is observed, and turning prefetch off stops the hang.

## Results

| Run | Kernel | Prefetch | Fences | Result |
|---|---|---|---|---|
| 0 | #383 | on | 968k | hang, in `bump` |
| 1 | #383 | on | 44k | hang, in `build` |
| 2 | #383 | off, by hand | 11.2M | no hang, 30 min, 5 passes, 176 scenes |
| 3 | #385 | off | 5.4M | no hang, stopped early at 15 min |
| A | #386 | off | 2.1M | no hang, 1 pass |
| B/C | #386 | on | 2.56M | per-scene pass clean, then hang 17 s into continuous glmark2 |
| D | #387 | off, `sn2_gpu_no_prefetch` | 2.1M | no hang, 1 pass, score 1661 |

Prefetch on: 3 hangs in 3.6M fences. Prefetch off: 0 in 20.8M, where that rate predicts about 17.
All runs with prefetch off had `BUS1_INT_STATUS` at 0.

Run B shows how uneven the hang is: one whole pass, about 2M fences, came through clean. Don't
read one clean run as a pass.

### Cost

glmark2 score: **about 1951 on, 1582-1681 off**.

No full pass has been measured with prefetch on, because it hangs first. 1951 is the mean of 33
scenes run one at a time. On run A the same mean gives 1583.9 against glmark2's 1582, so it's a fair
stand-in, but it is not a measured score. Scores with prefetch off ranged 1577-1681 across
passes and the first pass was sometimes higher, which is unexplained. The cost is 14-19%
depending on which is used.

| Scene group | On | Off | Change |
|---|---|---|---|
| build | 1432 | 1144 | -20% |
| texture | 2646 | 2106 | -20% |
| shading | 2475 | 2001 | -19% |
| bump | 2508 | 1999 | -20% |
| effect2d | 2027 | 1680 | -17% |
| pulsar | 2517 | 2067 | -18% |
| desktop | 1320 | 1128 | -15% |
| buffer | 81 | 64 | -21% |
| ideas | 1085 | 1035 | -5% |
| jellyfish | 1759 | 1513 | -14% |
| terrain | 280 | 271 | -3% |
| shadow | 1064 | 974 | -8% |
| refract | 266 | 259 | -3% |
| conditionals | 2812 | 2216 | -21% |
| function | 2762 | 2220 | -20% |
| loop | 2760 | 2214 | -20% |

Scenes limited by per-frame submission or DMA reads lose about 20%. `buffer` subdata alone loses
31%, and `build use-vbo=false` 25%. GPU-bound scenes barely change, which is why Minecraft
needs its own measurement.

## The kernel change

Work in progress: branch `sn2-gpu-pic-prefetch` (commit `179936a536d9`) in the worktree
`src/mainline/linux-sn2-gpu-prefetch`. It is not in `master-epic-sn2-gpu`, and it belongs in the
`-sn2-gpu` layer if it's merged. `ia64-build.sh` always builds the main `src/mainline/linux-sn2`
tree, so to build the fix, cherry-pick the commit there:

```bash
cd ~/projects/altix_cross/src/mainline/linux-sn2
git cherry-pick 179936a536d9
ia64-build.sh
```

Build #387 (run D) is this commit. Builds #385 and #386 had earlier versions, where the option
was inverted and named `sn2_gpu_prefetch`.

In `arch/ia64/sn/pci/pcibr/`:

- `pcibr_provider.c`: `pcibr_gpu_no_prefetch()`, a display-class `DECLARE_PCI_FIXUP_CLASS_FINAL`.
  With the option set it clears PREFETCH on that device's PIC slot. Either way it logs the mode:

  ```
  pci 0002:01:00.0: PIC DMA read prefetch left on for slot 2
  pci 0002:01:00.0: PIC DMA read prefetch disabled for slot 2
  ```

- `pcibr_reg.c`: `pcireg_device_bit_clr()`, which also keeps `pbi_devreg[]` in step. On pople
  `pbi_devreg[]` matched the hardware on all four slots of this bus.
- `pcibr_dma.c`: with the option set, display devices get no `PCI32_ATE_PREF`. TTM pages can't
  get here: amdgpu's 40-bit mask makes `dma_addressing_limited()` true, so TTM uses `GFP_DMA32`,
  which stays in the direct32 window. `dma_alloc_coherent` uses `PCI32_ATE_BAR`. Only userptr
  pages can reach this path. **It has never run in a test.**

The bit is per PIC slot, so the PLX's other function (HDMI audio, `0002:01:00.1`) loses prefetch
too. Other PIC slots keep theirs. The fixup only acts on `PCIIO_ASIC_TYPE_PIC`, so TIOCP and
TIOCA (Prism) are unaffected.

To use it, add `sn2_gpu_no_prefetch` to the `append=` line of the ELILO entry, or the kernel
line in grub. Then check `dmesg | grep "DMA read prefetch"`.

## Alternatives rejected

- **Protect only the ring.** IBs have the same hazard. Mesa's suballocator puts the next IB about
  96 bytes after the previous one (`0xfa300` + 0x1a8 dwords, then `0xfaa00`), inside prefetch range.
  The CPU writes the next IB while the CP reads the current one.
- **Flush RRBs before each WPTR write** through PIC's `RR_BUFF_CLR`. Not tried. It leaves IBs
  uncovered and needs a PIO write in generic amdgpu ring code. It may still be worth a look if the
  cost in Minecraft turns out to matter, since it would keep prefetch.

## Not tested

- Minecraft, or anything other than glmark2, for either the hang or the cost.
- More than one brick. The fixup is per device, but all of this ran on one brick.
- Whether the hang predates GTT write-combining (`5ea02bb95b7f`). It has been seen for longer than
  that by report, but no all-UC kernel was run here. Turning prefetch off stops it with WC on.
- radeon. The fixup covers it, but only amdgpu was run.

## Separate: X's unaligned access messages

```
X(421): unaligned access to 0x200000080116b99c, ip=0x20000008002897c0
```

These are not related to the hang. `proc_present_pixmap` in Xorg reads the 64-bit
`target_msc`/`divisor`/`remainder` fields of a PresentPixmap request with `ld8`, and those fields
are only 4-byte aligned in X's input buffer. The kernel emulates each one correctly, and the
messages are rate-limited, so the real count is higher than the log shows.

## Tools

In `gpu_debug/`. They run on pople unless noted.

| File | Use |
|---|---|
| `picreg.c` | `picreg dump`, `r <off>`, `w <off> <val>`: 64-bit PIO to PIC BUS1 through `/dev/mem`. Reads RRBs and other registers IST can't. Base address is hardcoded for this box. PIC registers must not be touched by memcpy |
| `regdump.py` | Snapshots CP/GRBM/VM registers through `amdgpu_regs`. Safe on a wedged GPU. Each read pops the `CP_*_HEADER_DUMP` FIFOs, which is why it takes several snapshots: read those columns newest first |
| `repro.sh <run> [modprobe args]` | Loads amdgpu, starts X, loops glmark2 until a gfx timeout, then saves state. Use `gpu_recovery=0` to freeze the hang for `regdump.py` and `picreg` |
| `cont.sh <run>` | Same loop on an X that's already running |
| `scene-run.sh <run>` | One scene per process, resumes after a reboot. Needs a list of scene names in `/root/gfxhang/scenes.txt` |
| `ringdec.py <devcoredump>` | Runs on the workstation. Decodes the ring from a devcoredump |

The scripts expect to live in `/root/gfxhang` on the box.

To check any "impossible" GPU behavior on PIC, compare what the CP parsed (`CP_PFP_HEADER_DUMP`)
with what ring memory holds before assuming a driver bug.
