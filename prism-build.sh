#!/bin/bash
# Build a release tarball for the Prism and put it on the NFS share, where
# prism-install.sh on the Prism picks it up.  Nothing goes to the netboot
# server.  Builds the linux-sn2-prism worktree unless KSRC says otherwise.
#
#   prism-build.sh             build, then refresh everything on the share
#   prism-build.sh --scripts   only refresh the scripts and firmware on the share
#
# The Prism boots without an initrd, so the .config must have the root
# filesystem and disk driver built in (configs/7.3-epic-sn2-prism.config).
#
# prism/remote holds the user@host prism-install.sh fetches from.  It is
# gitignored to keep the hostname out of the public repo.
#
# PRISM_DEST overrides where the tarball and its prism_probe go.  Anything under
# a subdirectory is out of reach of the newest-tarball pick in prism-install.sh,
# which is how prism-build-fallbacks.sh keeps its kernels from being installed
# by accident.

set -euo pipefail

_BASE_DIR=~/projects/altix_cross
_TOOLS="$_BASE_DIR/sn2-kernel-tools"
_SHARE=/mnt/nfs/altix/prismkerns
_DEST=${PRISM_DEST:-$_SHARE}
_REMOTE_FILE="$_TOOLS/prism/remote"
_KSRC=${KSRC:-src/mainline/linux-sn2-prism}

[ -d "$_SHARE" ] || { echo "$_SHARE not found, is the NFS share mounted?" >&2; exit 1; }
_remote=$(cat "$_REMOTE_FILE" 2>/dev/null) || true
[ -n "$_remote" ] || { echo "$_REMOTE_FILE is missing or empty, it needs user@host" >&2; exit 1; }

_copy_scripts() {
	sed "s/@PRISM_REMOTE@/$_remote/" "$_TOOLS/prism-install.sh" > "$_SHARE/prism-install.sh"
	install -m 755 "$_TOOLS/prism/prism-capture.sh" "$_SHARE/"
	mkdir -p "$_SHARE/firmware/radeon"
	cp /lib/firmware/radeon/R300_cp.bin /lib/firmware/radeon/R420_cp.bin "$_SHARE/firmware/radeon/"
}

if [ "${1:-}" = --scripts ]; then
	_copy_scripts
	echo "Refreshed the scripts and firmware in $_SHARE"
	exit 0
fi

mkdir -p "$_DEST"
# staged on the share: the rename below is atomic, so prism-install.sh can't
# pick up a partial tarball
_stage=$(mktemp -d "$_DEST/.stage.XXXXXX")
trap 'rm -rf "$_stage"' EXIT

KSRC=$_KSRC DEPLOY=none RELEASE_DIR="$_stage" "$_TOOLS/ia64-build.sh" --release

_tarball=$(echo "$_stage"/linux-*.tar.gz)
_release=${_tarball##*/linux-}
_release=${_release%.tar.gz}

# built after the kernel: its vermagic has to match, and there are no kernel
# headers on the Prism to build it there
(
	cd "$_BASE_DIR"
	source sn2-kernel-tools/setup_cross.sh >/dev/null
	cd "$_KSRC"
	make M="$_TOOLS/prism/probe" ARCH=ia64 CROSS_COMPILE=ia64-linux- clean >/dev/null
	make M="$_TOOLS/prism/probe" ARCH=ia64 CROSS_COMPILE=ia64-linux- modules >/dev/null
)
cp "$_TOOLS/prism/probe/prism_probe.ko" "$_DEST/prism_probe-$_release.ko"

mv "$_tarball" "$_DEST/"
_copy_scripts

echo "Copied to $_DEST/${_tarball##*/}"
