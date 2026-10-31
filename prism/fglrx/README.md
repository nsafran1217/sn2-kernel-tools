# FireGL AGP on SN2

These notes cover getting FireGL AGP cards working on SN2 through the TIO CA (TIOCA) bridge, using `radeon`.

| File | Contents |
| --- | --- |
| [TIOCA-AGP-HANDOFF.md](TIOCA-AGP-HANDOFF.md) | Start here. The kernel problems, fixes, hardware facts, bring-up order and instrumentation |
| [fglrx-re-notes.md](fglrx-re-notes.md) | Evidence, corrections to the older analysis, and how to rebuild the working files |
| `patches/` | Proposed fixes. They compile against `a107c0ed2d38`, and they have not been run |
| `tools/` | The disassembly viewers used |
| `linux-sn2/` | Clean clone of `master-epic-sn2-gpu` at `a107c0ed2d38`, for reading |

The older analysis stays in `~/projects/altix_cross/sn2-kernel-tools/radeon/fglrx/`, and I did not edit it. Several of its main conclusions are wrong, as the notes list.

Nothing here has been run on hardware.
