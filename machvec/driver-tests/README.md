# SN2 driver tests (pople)

Run on pople as root. `/tmp` there is noexec, so build in `/root`.

## mspec

    gcc -O2 -Wall -o mspectest mspectest.c && modprobe mspec && ./mspectest 1000

Covers `/dev/mspec_cached`, `/dev/mspec_uncached` and `/dev/sgi_fetchop`. It checks that
fresh pages read as zero, that data round-trips, and that MAP_SHARED is visible across
fork. Pages must be zeroed (BTE, `mspec_zero_block()`) after the last unmap. The fetchop
AMOs tested are store, load, inc, dec, clear, and, or, plus 4 processes x 1M atomic increments.

## snsc

Uses `l2cmd` from the reconstructed SGI tools (`~/projects/claudeProjects/sgi_l2/src/rewrite-decomp`).
It builds natively on pople:

    tar czf - Makefile compat sys_ctrl | altix ssh 'mkdir -p /tmp/sgil2 && tar xzf - -C /tmp/sgil2 && cd /tmp/sgil2 && make ARCH= B=bia64 WERROR= bia64/bin/l2cmd'
    altix ssh 'mkdir -p /root/sgil2 && cp /tmp/sgil2/bia64/bin/l2cmd /root/sgil2/'

The kernel names the node `/dev/001c02^0#0`. SGI's tools look for `/dev/snsc/*c*`, so pass it explicitly:

    D=$(ls /dev/*c02^*)
    ./l2cmd --scdev "$D" version           # answered by the L2 (L1 forwards)
    ./l2cmd --scdev "$D" l1 version        # both L1s
    ./l2cmd --scdev "$D" 001c02 env        # multi-chunk response
    ./l2cmd --scdev "$D" 001c02 env test warning   # event path: kernel logs "|$(0x166)001c02 ATTN: Environmental warning test"
    ./l2cmd --scdev "$D" 001c02 env reset

Don't send `env test fault` / `env test tmpcrit` (power-down risk), or `test exc ...`, `pwr`, `reset`.

## mbcs / tiocx

Needs a TIO with an FPGA (Altix 450/4700 RASC). On pople (SHub1, no TIO) all you can check is that
`/sys/bus/tiocx/drivers/mbcs` exists and that `mbcs` has a char major in `/proc/devices`.
