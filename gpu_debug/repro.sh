#!/bin/bash
# repro.sh <run-name> [modprobe args...]: load amdgpu, start X, loop glmark2 until gfx timeout, snapshot state.
export PATH=/usr/X11/bin:/usr/X11R7/bin:$PATH:/usr/sbin:/sbin
RUN=$1; shift
OUT=/root/gfxhang/$RUN; mkdir -p $OUT
lsmod | grep -q '^amdgpu' || modprobe amdgpu "$@" || exit 1
dmesg -C
setsid nohup startx -- -keeptty > $OUT/startx.log 2>&1 < /dev/null &
for i in $(seq 1 60); do DISPLAY=:0 xdpyinfo >/dev/null 2>&1 && break; sleep 1; done
export DISPLAY=:0
( while true; do glmark2 2>&1; sleep 1; pgrep -x X >/dev/null || pgrep -x Xorg > /dev/null || break; done ) > $OUT/glmark2.log 2>&1 &
GPID=$!
START=$(date +%s)
while true; do
  if dmesg | grep -qE 'ring [a-z_0-9.]+ timeout'; then break; fi
  if ! pgrep -x X >/dev/null && ! pgrep -x Xorg >/dev/null; then echo "X died" > $OUT/result; break; fi
  sleep 1
done
echo "elapsed $(( $(date +%s)-START )) s" >> $OUT/result
python3 /root/gfxhang/regdump.py 5 > $OUT/regs.txt 2>&1
cp /sys/kernel/debug/dri/0/amdgpu_fence_info $OUT/ 2>/dev/null
cat /sys/kernel/debug/dri/0/amdgpu_fence_info > $OUT/fence_info.txt 2>&1
dd if=/sys/kernel/debug/dri/0/amdgpu_ring_gfx of=$OUT/ring_gfx.bin bs=4k 2>/dev/null
cat /sys/class/drm/card0/device/devcoredump/data > $OUT/devcoredump.txt 2>/dev/null
lspci -vv -s 0002:01:00.0 > $OUT/lspci-gpu.txt 2>&1
lspci -vv -s 0002:00:02.0 > $OUT/lspci-plx.txt 2>&1
lspci -xxx -s 0002:00:02.0 > $OUT/cfg-plx.txt 2>&1
dmesg > $OUT/dmesg.txt
echo done >> $OUT/result
