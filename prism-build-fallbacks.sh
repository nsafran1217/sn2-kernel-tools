#!/bin/bash
# Build the Prism kernels held back for a failed first boot.  They differ from
# the first-boot kernel by one thing each, so booting one tests that one thing.
#
#   prism-build-fallbacks.sh
#
#   notioca   adds the sn2_no_tioca boot argument, which leaves the CA out of
#             the PCI scan.  Without the argument it matches the base kernel.
#   novga     CONFIG_VGA_CONSOLE off, for a death in or near console_init
#   notiocx   CONFIG_SGI_TIOCX and CONFIG_SGI_MBCS off
#
# They build in the linux-sn2-prism-fallback worktree on sn2-prism-fallback, and
# go to fallback/ on the share, where prism-install.sh only looks when told to:
#
#   PICK=novga REMOTE_DIR=/nfs/altix/prismkerns/fallback prism-install.sh

set -euo pipefail

_BASE_DIR=~/projects/altix_cross
_TOOLS="$_BASE_DIR/sn2-kernel-tools"
_TREE="$_BASE_DIR/src/mainline/linux-sn2-prism-fallback"
_DEST=/mnt/nfs/altix/prismkerns/fallback

_build() {
	local variant=$1
	shift
	cp "$_TOOLS/configs/7.3-epic-sn2-prism.config" "$_TREE/.config"
	(
		cd "$_TREE"
		scripts/config --set-str LOCALVERSION "-SN2-PRISM-$variant" "$@"
	)
	KSRC=$_TREE PRISM_DEST=$_DEST "$_TOOLS/prism-build.sh"
}

_build notioca
_build novga --disable VGA_CONSOLE
_build notiocx --disable SGI_TIOCX --disable SGI_MBCS
