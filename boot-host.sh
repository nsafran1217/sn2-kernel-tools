#!/bin/bash
# Boot a grub-booted ia64 box (rx2800, hprx) into a given grub entry by
# making it the default and rebooting over ssh, then wait for ssh.
#
#   boot-host.sh <host> <entry-title|0> [expect-in-uname]
#
# "0" restores the box's normal first entry.  The grub.cfg is backed up the
# first time this changes it on a given day.  Exits 0 when ssh is back
# (and uname -r contains expect-in-uname, if given), 1 otherwise.

set -uo pipefail
HOST=${1:?usage: boot-host.sh <host> <entry-title|0> [expect-in-uname]}
ENTRY=${2:?}
EXPECT=${3:-}
T=root@$HOST
GRUB=/boot/grub/grub.cfg
TIMEOUT=${TIMEOUT:-900}

ssh "$T" bash -s -- "$GRUB" "$ENTRY" <<'EOF' || exit 1
set -eu
GRUB=$1 ENTRY=$2
if [ "$ENTRY" = 0 ]; then VAL=0; else VAL="\"$ENTRY\""; fi
if [ "$ENTRY" != 0 ] && ! grep -q "^menuentry \"$ENTRY\"" "$GRUB"; then
	echo "no grub entry \"$ENTRY\"" >&2; exit 1
fi
b="$GRUB.before-default-$(date +%Y%m%d)"
[ -e "$b" ] || cp -p "$GRUB" "$b"
sed -i "s/^set default=.*/set default=$VAL/" "$GRUB"
grep '^set default' "$GRUB"
EOF

old=$(ssh "$T" 'cat /proc/sys/kernel/random/boot_id')
ssh "$T" 'systemctl reboot || reboot' >/dev/null 2>&1 || true
echo "rebooting $HOST into $ENTRY..."
start=$SECONDS
sleep 30
while [ $((SECONDS - start)) -lt "$TIMEOUT" ]; do
	new=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "$T" 'cat /proc/sys/kernel/random/boot_id' 2>/dev/null) &&
		[ -n "$new" ] && [ "$new" != "$old" ] && break
	sleep 10
done
rel=$(ssh -o ConnectTimeout=5 "$T" 'uname -r' 2>/dev/null) || { echo "$HOST: no ssh after ${TIMEOUT}s" >&2; exit 1; }
echo "$HOST up after $((SECONDS - start))s: $rel"
[ -z "$EXPECT" ] || [[ $rel == *"$EXPECT"* ]] || { echo "expected $EXPECT" >&2; exit 1; }
