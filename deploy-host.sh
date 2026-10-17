#!/bin/bash
# Install a built kernel on a grub-booted ia64 box over ssh (HP Integrity:
# rx2800, hprx), the local-disk counterpart of the NFS-root deploy in
# ia64-build.sh.
#
#   deploy-host.sh <host> <staging-dir> <name>
#
# <staging-dir> is laid out like ia64-build.sh's tar-install/:
#   boot/vmlinuz-<release>  boot/System.map-<release>  boot/config-<release>
#   lib/modules/<release>/
# On root@<host> this installs:
#   /boot/vmlinuz-<name>, /boot/System.map-<release>, /boot/kconfig-<release>,
#   /lib/modules/<release>/, and /boot/initrd-<name> (T2 mkinitrd on the box)
# and, the first time, a grub menuentry titled "<name>" that reuses the
# root=/console= arguments the box is running with (grub.cfg is backed up
# first).  Select it with boot-host.sh <host> <name>.

set -euo pipefail
HOST=${1:?usage: deploy-host.sh <host> <staging-dir> <name>}
STAGE=$(cd "${2:?}" && pwd)
NAME=${3:?}
T=root@$HOST
GRUB=/boot/grub/grub.cfg

shopt -s nullglob
k=("$STAGE"/boot/vmlinuz-*)
[ ${#k[@]} = 1 ] || { echo "expected one boot/vmlinuz-* in $STAGE" >&2; exit 1; }
REL=${k[0]##*/vmlinuz-}
[ -d "$STAGE/lib/modules/$REL" ] || { echo "no lib/modules/$REL in $STAGE" >&2; exit 1; }

echo "deploy $REL to $HOST as $NAME"
rsync -a --delete "$STAGE/lib/modules/$REL/" "$T:/lib/modules/$REL/"
scp -q "${k[0]}" "$T:/boot/vmlinuz-$NAME"
scp -q "$STAGE/boot/System.map-$REL" "$T:/boot/System.map-$REL"
[ -f "$STAGE/boot/config-$REL" ] && scp -q "$STAGE/boot/config-$REL" "$T:/boot/kconfig-$REL"

ssh "$T" bash -s -- "$REL" "$NAME" "$GRUB" <<'EOF'
set -euo pipefail
REL=$1 NAME=$2 GRUB=$3
depmod -a "$REL"
mkinitrd -o "/boot/initrd-$NAME" "$REL" >/dev/null
if ! grep -q "^menuentry \"$NAME\"" "$GRUB"; then
	cp -p "$GRUB" "$GRUB.before-$NAME-$(date +%Y%m%d-%H%M%S)"
	args=$(sed 's/^BOOT_IMAGE=[^ ]* //; s/ *$//' /proc/cmdline)
	printf '\nmenuentry "%s" {\n        linux /boot/vmlinuz-%s %s\n        initrd /boot/initrd-%s\n}\n' \
		"$NAME" "$NAME" "$args" "$NAME" >> "$GRUB"
	echo "added grub entry \"$NAME\""
fi
ls -la "/boot/vmlinuz-$NAME" "/boot/initrd-$NAME"
EOF
