#!/bin/sh
# Read-only qla1280 test: O_DIRECT sequential reads per disk and both at once,
# small-block reads, and repeat-read checksum comparison. Never writes.
set -u
DISKS="${DISKS:-sda sdb}"
echo "kernel $(uname -r)"
for d in $DISKS; do
  printf '%s seq 1M x1024: ' $d; dd if=/dev/$d of=/dev/null bs=1M count=1024 iflag=direct 2>&1 | tail -1
  printf '%s 4k x 20000: ' $d;   dd if=/dev/$d of=/dev/null bs=4k count=20000 skip=100000 iflag=direct 2>&1 | tail -1
done
echo "both at once (1M x 2048 each):"
for d in $DISKS; do dd if=/dev/$d of=/dev/null bs=1M count=2048 skip=4096 iflag=direct 2>&1 | tail -1 | sed "s/^/  $d: /" & done; wait
echo "4 readers per disk, scattered 64k reads:"
t0=$(date +%s)
for d in $DISKS; do for k in 1 2 3 4; do dd if=/dev/$d of=/dev/null bs=64k count=4000 skip=$((k*50000)) iflag=direct 2>/dev/null & done; done; wait
echo "  done in $(( $(date +%s) - t0 )) s"
echo "checksum stability (512 MB, read 3x, both disks concurrently):"
for d in $DISKS; do (
  s1=$(dd if=/dev/$d bs=1M count=512 skip=1024 iflag=direct 2>/dev/null | md5sum | cut -c1-32)
  s2=$(dd if=/dev/$d bs=1M count=512 skip=1024 iflag=direct 2>/dev/null | md5sum | cut -c1-32)
  s3=$(dd if=/dev/$d bs=1M count=512 skip=1024 iflag=direct 2>/dev/null | md5sum | cut -c1-32)
  [ "$s1" = "$s2" ] && [ "$s2" = "$s3" ] && echo "  $d: stable $s1" || echo "  $d: MISMATCH $s1 $s2 $s3"
) & done; wait
grep qla1280 /proc/interrupts
echo "new kernel warnings since start:"; dmesg --level=err,warn | grep -iE 'qla|scsi|sd |sd[ab]|I/O error|abort|reset|timeout' | tail -10
