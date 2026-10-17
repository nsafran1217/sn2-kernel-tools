#!/bin/bash
# Build mvbench.ko for a kernel and install it, with the target-side scripts
# and benchmark sources, into the shared NFS root on the boot server
# (/t2/altixroot/opt/machvec-bench, i.e. /opt/machvec-bench on pople,
# rx2800 and hprx).
#
# usage: build-mvbench.sh <kernel-tree> [artifact-dir]
#
# Without artifact-dir the tree must hold the build of the kernel in
# question.  With an artifact dir saved by src/machvec/build-matrix.sh, the
# tree is re-prepared for that build's .config and release (modules_prepare
# only; the config has no MODVERSIONS or module signing, so a matching
# vermagic is all that is needed).  This changes the tree's .config.
#
# MVB_HOSTS="rx2800 hprx" also installs to those boxes' /opt/machvec-bench.
# Use the same IA64_GCC_VERSION the kernel was built with.

set -euo pipefail
KSRC=$(cd "${1:?usage: build-mvbench.sh <kernel-tree> [artifact-dir]}" && pwd)
ART=${2:+$(cd "$2" && pwd)}
HERE=$(cd "$(dirname "$0")" && pwd)
BOOTSERVER=10.40.0.121
DEST=/t2/altixroot/opt/machvec-bench
BENCHSRC=${BENCHSRC:-$HOME/projects/altix_cross/src/machvec/benchsrc}

cd ~/projects/altix_cross
source sn2-kernel-tools/setup_cross.sh >/dev/null
M="make -s -C $KSRC ARCH=ia64 CROSS_COMPILE=ia64-linux-"

if [ -n "$ART" ]; then
	KREL=$(cat "$ART/include/config/kernel.release")
	cp "$ART/.config" "$KSRC/.config"
	$M olddefconfig
	# release without the LOCALVERSION ia64-build.sh passed (it includes
	# CONFIG_LOCALVERSION and the tree's localversion* files)
	$M LOCALVERSION= include/config/kernel.release
	BASE=$(cat "$KSRC/include/config/kernel.release")
	LV=${KREL#"$BASE"}
	if [ "$LV" = "$KREL" ]; then
		# CONFIG_LOCALVERSION_AUTO puts its -NNNNN-g<sha> after
		# LOCALVERSION: KREL = PRE LV AUTO, BASE = PRE AUTO.  AUTO is the
		# longest common suffix that starts with '-'.
		AUTO="" i=1
		while [ $i -le ${#BASE} ] && [ "${BASE: -$i}" = "${KREL: -$i}" ]; do
			[ "${BASE: -$i:1}" = - ] && AUTO=${BASE: -$i}
			i=$((i + 1))
		done
		PRE=${BASE%"$AUTO"}
		LV=${KREL#"$PRE"}; LV=${LV%"$AUTO"}
	fi
	$M LOCALVERSION="$LV" modules_prepare
	GOT=$(cat "$KSRC/include/config/kernel.release")
	[ "$GOT" = "$KREL" ] || { echo "release mismatch: $GOT != $KREL" >&2; exit 1; }
	export KBUILD_MODPOST_WARN=1	# no Module.symvers from modules_prepare
else
	KREL=$(cat "$KSRC/include/config/kernel.release")
fi

BUILD=$(mktemp -d)
trap 'rm -rf "$BUILD"' EXIT
cp "$HERE"/mvbench/{mvbench.c,Makefile} "$BUILD"/
$M M="$BUILD" modules
VERMAGIC=$(ia64-linux-objcopy -O binary --only-section=.modinfo "$BUILD/mvbench.ko" /dev/stdout |
	tr '\0' '\n' | sed -n 's/^vermagic=//p')
case $VERMAGIC in
"$KREL "*) ;;
*) echo "vermagic '$VERMAGIC' doesn't match $KREL" >&2; exit 1 ;;
esac

ssh $BOOTSERVER "mkdir -p $DEST/mvbench/$KREL $DEST/src"
scp -q "$BUILD/mvbench.ko" $BOOTSERVER:$DEST/mvbench/$KREL/
scp -q "$HERE/mvbench.sh" "$HERE/mvbench-setup.sh" "$HERE/tlbbench.c" $BOOTSERVER:$DEST/
[ -d "$BENCHSRC" ] && rsync -a --exclude .git "$BENCHSRC"/ $BOOTSERVER:$DEST/src/
echo "installed mvbench.ko for $KREL and scripts in $BOOTSERVER:$DEST"

# Grub-booted boxes with their own root (rx2800, hprx): same layout in
# /opt/machvec-bench.  Run mvbench-setup.sh there once.
for h in ${MVB_HOSTS:-}; do
	ssh root@$h "mkdir -p /opt/machvec-bench/mvbench/$KREL /opt/machvec-bench/src"
	scp -q "$BUILD/mvbench.ko" root@$h:/opt/machvec-bench/mvbench/$KREL/
	scp -q "$HERE/mvbench.sh" "$HERE/mvbench-setup.sh" "$HERE/tlbbench.c" root@$h:/opt/machvec-bench/
	[ -d "$BENCHSRC" ] && rsync -a --exclude .git "$BENCHSRC"/ root@$h:/opt/machvec-bench/src/
	echo "installed mvbench.ko for $KREL and scripts on $h"
done
