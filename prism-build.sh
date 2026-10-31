#!/bin/bash
# Build a release tarball for the Prism and put it on the NFS share, where
# prism-install.sh on the Prism picks it up.  Nothing goes to the netboot
# server.  Builds the linux-sn2-prism worktree unless KSRC says otherwise.
#
#   prism-build.sh
#
# The Prism boots without an initrd, so the .config must have the root
# filesystem and disk driver built in (configs/7.3-epic-sn2-prism.config).
#
# prism/remote holds the user@host prism-install.sh fetches from.  It is
# gitignored to keep the hostname out of the public repo.

set -euo pipefail

_BASE_DIR=~/projects/altix_cross
_TOOLS="$_BASE_DIR/sn2-kernel-tools"
_DEST=/mnt/nfs/altix/prismkerns
_REMOTE_FILE="$_TOOLS/prism/remote"

[ -d "$_DEST" ] || { echo "$_DEST not found, is the NFS share mounted?" >&2; exit 1; }
_remote=$(cat "$_REMOTE_FILE" 2>/dev/null) || true
[ -n "$_remote" ] || { echo "$_REMOTE_FILE is missing or empty, it needs user@host" >&2; exit 1; }

# staged on the share: the rename below is atomic, so prism-install.sh can't
# pick up a partial tarball
_stage=$(mktemp -d "$_DEST/.stage.XXXXXX")
trap 'rm -rf "$_stage"' EXIT

KSRC=${KSRC:-src/mainline/linux-sn2-prism} DEPLOY=none RELEASE_DIR="$_stage" \
	"$_TOOLS/ia64-build.sh" --release

_tarball=$(echo "$_stage"/linux-*.tar.gz)
mv "$_tarball" "$_DEST/"
sed "s/@PRISM_REMOTE@/$_remote/" "$_TOOLS/prism-install.sh" > "$_DEST/prism-install.sh"

echo "Copied to $_DEST/${_tarball##*/}"
