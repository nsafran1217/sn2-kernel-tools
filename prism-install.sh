#!/bin/bash
# Run as root on the Prism: fetch the newest kernel tarball prism-build.sh left
# on the NFS server, install it and make it the grub default.  Does not reboot.
#
#   prism-install.sh
#
# Keeps the tarball in /root/prismkerns and installs
#   /boot/{vmlinuz,vmlinux,System.map,config}-<release>, /lib/modules/<release>/
# then adds a grub menuentry titled <release> that reuses the arguments the box
# is running with, and selects it by --id: grub parses a default of 7.3.0-... as
# index 7, so it can't be selected by title.  grub.cfg is hand-written on T2, so it is edited directly
# (and backed up first) rather than regenerated.  The /boot/vmlinuz symlinks
# and the stock entry they boot are left alone as the way back.
#
# There is no initrd: the kernel needs the root filesystem and disk driver
# built in, and with nothing to resolve root=/dev/disk/by-uuid/... the entry
# names the device directly.
#
# prism-build.sh fills in the REMOTE default when it copies this script to the
# share, from the gitignored prism/remote.  Run from the repo it needs REMOTE set.
#
# Environment:
#   ROOTDEV     root= for the new entry, default /dev/sda2.  The running kernel
#               can name the disk differently: pople's stock kernel has it as
#               sdb2 and the no-initrd kernel as sda2.
#   TEST_ARGS   arguments for the new entry.  They replace any panic=,
#               modprobe.blacklist= and radeon.* the box is running with, so a
#               stage that wants radeon loaded at boot sets this.  A rerun for
#               the same release rewrites the entry.
#   REMOTE_DIR  where to look for the tarball.  Set it to .../fallback for the
#               fallback kernels, which are kept out of the newest-tarball pick.
#   PICK        only consider tarballs with this in their name, such as novga.

set -euo pipefail
REMOTE=${REMOTE:-@PRISM_REMOTE@}
SHARE=/nfs/altix/prismkerns
REMOTE_DIR=${REMOTE_DIR:-$SHARE}
PICK=${PICK:-}
DIR=/root/prismkerns
GRUB=/boot/grub/grub.cfg
ROOTDEV=${ROOTDEV:-/dev/sda2}
# panic=0 leaves a crash frozen for errdmp, CONFIG_PANIC_TIMEOUT would reboot.
# radeon is blocked until a stage loads it by hand.
TEST_ARGS=${TEST_ARGS-panic=0 modprobe.blacklist=amdgpu,radeon}

die() { echo "$*" >&2; exit 1; }
warn() { echo "WARNING: $*" >&2; }

# Check this kernel can bring the box up before grub is touched.  Disk names
# can differ between kernels, so only the filesystem is fatal: with no initrd it
# has to be built in.
preflight() {
	local mods=$tmp/lib/modules/$REL names m src
	names=$tmp/.provided
	sed 's/.*\///; s/\.ko.*//' "$mods/modules.builtin" "$mods/modules.order" |
		tr - _ > "$names"

	m=$(findmnt -no FSTYPE /)
	sed 's/.*\///; s/\.ko.*//' "$mods/modules.builtin" | tr - _ | grep -Fxq "$m" ||
		die "root is $m, which is not built in to $REL"

	src=$(readlink -f "$(findmnt -no SOURCE /)")
	[ "$src" = "$(readlink -f "$ROOTDEV")" ] ||
		warn "root is $src here, the entry will use root=$ROOTDEV"

	for m in $(cut -d' ' -f1 /proc/modules) \
		 $(lspci -k 2>/dev/null | awk '/Kernel driver in use:/ {print $NF}'); do
		grep -Fxq "${m//-/_}" "$names" || warn "$REL has no driver $m, which this boot uses"
	done
}

case $REMOTE in
	@*) die "REMOTE is not set, use the copy prism-build.sh put on the share" ;;
esac

[ "$(stat -c %d /boot)" = "$(stat -c %d /)" ] ||
	die "/boot is a separate filesystem, grub entry paths would be wrong"

mkdir -p "$DIR"
newest=$(ssh "$REMOTE" "ls -t $REMOTE_DIR/linux-*$PICK*.tar.gz | head -1")
[ -n "$newest" ] || die "no kernel tarball in $REMOTE:$REMOTE_DIR"
tarball=$DIR/${newest##*/}
REL=${tarball##*/linux-}
REL=${REL%.tar.gz}

# always fetched: a dirty tree rebuilds under the same release name
echo "fetching $newest"
scp -p "$REMOTE:$newest" "$tarball"

# not -C /: the tarball's ./ and ./boot entries would change those directories
tmp=$(mktemp -d "$DIR/.extract.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
tar xzf "$tarball" --no-same-owner -C "$tmp"
[ -f "$tmp/boot/vmlinuz-$REL" ] && [ -d "$tmp/lib/modules/$REL" ] ||
	die "$tarball does not contain kernel $REL"
preflight

echo "installing $REL"
rm -rf "/lib/modules/$REL"
mv "$tmp/lib/modules/$REL" /lib/modules/
install -m 644 "$tmp"/boot/*-"$REL" /boot/

# prism_probe is built per kernel: there are no kernel headers on the box
if scp -p "$REMOTE:${newest%/*}/prism_probe-$REL.ko" "$tmp/prism_probe.ko"; then
	install -D -m 644 "$tmp/prism_probe.ko" "/lib/modules/$REL/extra/prism_probe.ko"
else
	warn "no prism_probe for $REL"
fi
depmod -a "$REL"

# FW_LOADER_USER_HELPER is off, so a missing CP image fails the radeon load
for fw in R300_cp.bin R420_cp.bin; do
	ls /lib/firmware/radeon/"$fw"* >/dev/null 2>&1 && continue
	mkdir -p /lib/firmware/radeon
	scp -p "$REMOTE:$SHARE/firmware/radeon/$fw" /lib/firmware/radeon/ ||
		warn "could not fetch radeon/$fw"
done

ID=sn2-$REL
cp -p "$GRUB" "$GRUB.before-$REL-$(date +%Y%m%d-%H%M%S)"
args=$(sed -E 's/^BOOT_IMAGE=[^ ]* *//; s/(^| )(root|panic|modprobe\.blacklist|radeon\.[a-z_]+)=[^ ]*//g; s/^ +//; s/ *$//' /proc/cmdline)
case " $args " in
	*" rootwait "*) ;;
	*) args="$args rootwait" ;;
esac
line="linux /boot/vmlinuz-$REL root=$ROOTDEV $args${TEST_ARGS:+ $TEST_ARGS}"
if grep -Fq "menuentry \"$REL\"" "$GRUB"; then
	esc=$(printf '%s' "$line" | sed 's/[\\&|]/\\&/g')
	sed -i "s|^\tlinux /boot/vmlinuz-$REL .*|\t$esc|" "$GRUB"
	echo "updated grub entry \"$REL\""
else
	printf '\nmenuentry "%s" --id "%s" {\n\t%s\n}\n' "$REL" "$ID" "$line" >> "$GRUB"
	echo "added grub entry \"$REL\""
fi
echo "$line"
# entries from before --id was added
sed -i "s/^menuentry \"$REL\" {/menuentry \"$REL\" --id \"$ID\" {/" "$GRUB"
sed -i "s/^set default=.*/set default=\"$ID\"/" "$GRUB"
# entries are appended, so the stock entry stays first and is the way back
sed -i "s/^set fallback=.*/set fallback=0/" "$GRUB"
grep -Fxq "set default=\"$ID\"" "$GRUB" && grep -Fq -- "--id \"$ID\"" "$GRUB" ||
	die "could not set the default in $GRUB"
sync

echo "installed $REL as the grub default, reboot to use it"
