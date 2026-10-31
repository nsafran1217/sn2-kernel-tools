#!/bin/bash
# Run as root on the Prism: fetch the newest kernel tarball prism-build.sh left
# on the NFS server, install it and make it the grub default.  Does not reboot.
#
#   prism-install.sh
#
# Keeps the tarball in /root/prismkerns and installs
#   /boot/{vmlinuz,vmlinux,System.map,config}-<release>, /lib/modules/<release>/
# then adds a grub menuentry titled <release> that reuses the arguments the box
# is running with.  grub.cfg is hand-written on T2, so it is edited directly
# (and backed up first) rather than regenerated.  The /boot/vmlinuz symlinks
# and the stock entry they boot are left alone as the way back.
#
# There is no initrd: the kernel needs the root filesystem and disk driver
# built in, and with nothing to resolve root=/dev/disk/by-uuid/... the entry
# names the device directly.
#
# prism-build.sh fills in the REMOTE default when it copies this script to the
# share, from the gitignored prism/remote.  Run from the repo it needs REMOTE set.

set -euo pipefail
REMOTE=${REMOTE:-@PRISM_REMOTE@}
REMOTE_DIR=/nfs/altix/prismkerns
DIR=/root/prismkerns
GRUB=/boot/grub/grub.cfg
ROOTDEV=/dev/sda2

die() { echo "$*" >&2; exit 1; }

case $REMOTE in
	@*) die "REMOTE is not set, use the copy prism-build.sh put on the share" ;;
esac

[ "$(stat -c %d /boot)" = "$(stat -c %d /)" ] ||
	die "/boot is a separate filesystem, grub entry paths would be wrong"

mkdir -p "$DIR"
newest=$(ssh "$REMOTE" "ls -t $REMOTE_DIR/linux-*.tar.gz | head -1")
[ -n "$newest" ] || die "no kernel tarball in $REMOTE:$REMOTE_DIR"
tarball=$DIR/${newest##*/}
REL=${tarball##*/linux-}
REL=${REL%.tar.gz}

# always fetched: a dirty tree rebuilds under the same release name
echo "fetching $newest"
scp -p "nathan@$REMOTE:$newest" "$tarball"

# not -C /: the tarball's ./ and ./boot entries would change those directories
tmp=$(mktemp -d "$DIR/.extract.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
tar xzf "$tarball" --no-same-owner -C "$tmp"
[ -f "$tmp/boot/vmlinuz-$REL" ] && [ -d "$tmp/lib/modules/$REL" ] ||
	die "$tarball does not contain kernel $REL"

echo "installing $REL"
rm -rf "/lib/modules/$REL"
mv "$tmp/lib/modules/$REL" /lib/modules/
install -m 644 "$tmp"/boot/*-"$REL" /boot/
depmod -a "$REL"

cp -p "$GRUB" "$GRUB.before-$REL-$(date +%Y%m%d-%H%M%S)"
if ! grep -Fq "menuentry \"$REL\"" "$GRUB"; then
	args=$(sed -E 's/^BOOT_IMAGE=[^ ]* *//; s/(^| )root=[^ ]*//; s/^ +//; s/ *$//' /proc/cmdline)
	case " $args " in
		*" rootwait "*) ;;
		*) args="$args rootwait" ;;
	esac
	printf '\nmenuentry "%s" {\n\tlinux /boot/vmlinuz-%s root=%s %s\n}\n' "$REL" "$REL" "$ROOTDEV" "$args" >> "$GRUB"
	echo "added grub entry \"$REL\""
fi
sed -i "s/^set default=.*/set default=\"$REL\"/" "$GRUB"
grep -Fxq "set default=\"$REL\"" "$GRUB" || die "could not set the default in $GRUB"
sync

echo "installed $REL as the grub default, reboot to use it"
