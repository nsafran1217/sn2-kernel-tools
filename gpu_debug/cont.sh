#!/bin/bash
# cont.sh <run>: loop full glmark2 on the running X until a gfx timeout or X dies.
export PATH=/usr/X11/bin:/usr/X11R7/bin:$PATH DISPLAY=:0
OUT=/root/gfxhang/$1; mkdir -p $OUT
( while pgrep -x X >/dev/null || pgrep -x Xorg >/dev/null; do glmark2 2>&1; sleep 1; done ) > $OUT/glmark2.log 2>&1 &
S=$(date +%s)
while true; do
  dmesg | grep -qE 'ring [a-z_0-9.]+ timeout' && { echo hang >> $OUT/result; break; }
  pgrep -x X >/dev/null || pgrep -x Xorg >/dev/null || { echo xdied >> $OUT/result; break; }
  sleep 1
done
echo "elapsed $(( $(date +%s)-S )) s" >> $OUT/result
dmesg | grep -E 'ring [a-z_0-9.]+ timeout|soft reset|wedged|Process X' > $OUT/hang-dmesg.txt
sed -n 1,3p /sys/kernel/debug/dri/0/amdgpu_fence_info > $OUT/fence.txt
echo done >> $OUT/result
