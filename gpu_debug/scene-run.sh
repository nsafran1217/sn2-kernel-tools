#!/bin/bash
# scene-run.sh <run>: run glmark2 scenes one at a time, resuming after the last
# recorded scene. Exits 3 on a gfx hang (caller reboots), 0 when all are done.
export PATH=/usr/X11/bin:/usr/X11R7/bin:$PATH:/usr/sbin:/sbin DISPLAY=:0
OUT=/root/gfxhang/$1; mkdir -p $OUT; touch $OUT/fps.txt
SCENES=/root/gfxhang/scenes.txt
modprobe amdgpu || exit 1
dmesg -C
setsid nohup startx -- -keeptty > $OUT/startx.log 2>&1 < /dev/null &
for i in $(seq 1 60); do xdpyinfo >/dev/null 2>&1 && break; sleep 1; done
n=$(wc -l < $OUT/fps.txt)
tail -n +$((n+1)) $SCENES | while IFS= read -r s; do
  r=$(timeout 45 glmark2 -b "$s" 2>&1 | grep -oE 'FPS: [0-9]+' | head -1 | awk '{print $2}')
  if dmesg | grep -qE 'ring [a-z_0-9.]+ timeout'; then
    { date +%T; echo "HANG in scene: $s"; dmesg | grep -E 'ring [a-z_0-9.]+ timeout' | head -1
      sed -n 2,3p /sys/kernel/debug/dri/0/amdgpu_fence_info; } >> $OUT/hangs.txt
    exit 3
  fi
  [ -n "$r" ] || { echo "no FPS for $s" >> $OUT/hangs.txt; exit 4; }
  printf '%s\t%s\n' "$r" "$s" >> $OUT/fps.txt
done
exit $?
