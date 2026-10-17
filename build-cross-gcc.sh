#!/bin/bash
# Build an ia64-linux nolibc cross toolchain (binutils + gcc + libgcc) with
# the ia64 patches T2 SDE carries, laid out like the kernel.org crosstool
# builds in tools/:
#
#   tools/gcc-<ver>-nolibc/ia64-linux/bin/ia64-linux-gcc
#
# usage: build-cross-gcc.sh [gcc-version] [binutils-version]
#        (defaults: whatever T2 trunk uses, read from its .desc files)
#
# Needs: libgmp-dev libmpfr-dev libmpc-dev, zstd, xz.  Source tarballs are
# taken from src/toolchain/download (fetched if missing) and verified against
# the T2 checksums.  Configure flags match the kernel.org 14.2.0 build.

set -euo pipefail

BASE=~/projects/altix_cross
T2=$BASE/src/t2-trunk
GCC_PKG=$T2/package/develop/gcc
BU_PKG=$T2/package/develop/binutils
TC=$BASE/src/toolchain
DL=$TC/download

desc_ver() { sed -n 's/^\[V\] //p' "$1"; }
GCC_VER=${1:-$(desc_ver $GCC_PKG/gcc.desc)}
BU_VER=${2:-$(desc_ver $BU_PKG/binutils.desc)}
PREFIX=$BASE/tools/gcc-$GCC_VER-nolibc/ia64-linux
JOBS=${JOBS:-$(nproc)}

# T2 checksum = sha224 of the decompressed tarball
verify() { # file desc
	local want got
	want=$(awk -v f="$(basename "$1")" '$1 == "[D]" && $3 == f { print $2 }' "$2")
	case $1 in
	*.xz)  got=$(xz -dc "$1" | sha224sum | cut -d' ' -f1) ;;
	*.zst) got=$(zstd -dc "$1" | sha224sum | cut -d' ' -f1) ;;
	*.gz)  got=$(gzip -dc "$1" | sha224sum | cut -d' ' -f1) ;;
	esac
	[ -n "$want" ] || { echo "no T2 checksum for $1 in $2" >&2; exit 1; }
	[ "$want" = "$got" ] || { echo "checksum mismatch for $1" >&2; exit 1; }
	echo "verified $(basename "$1")"
}

fetch() { # desc -> path of tarball
	local line file url
	line=$(grep '^\[D\]' "$1" | grep -v '\.jar ' | head -1)
	file=$(echo "$line" | awk '{print $3}')
	url=$(echo "$line" | awk '{print $4}')
	mkdir -p "$DL"
	[ -f "$DL/$file" ] || curl -fL -o "$DL/$file" "$url$file" >&2
	verify "$DL/$file" "$1" >&2
	echo "$DL/$file"
}

# ia64-relevant T2 patches: ones named for ia64 plus the .ia64 arch patches.
# Generic distro policy patches (tune-inline, no-unsafe-Ofast-math, ...) and
# other-arch/libc patches are left out.
patch_tree() { # srcdir pkgdir
	local p
	for p in $(ls "$2"/*ia64*.patch "$2"/*.patch.ia64 2>/dev/null | sort -u); do
		echo "applying $(basename "$p")"
		patch -d "$1" -p1 --no-backup-if-mismatch < "$p"
	done
}

unpack() { # tarball destdir
	rm -rf "$2"
	mkdir -p "$2"
	tar -xf "$1" -C "$2" --strip-components=1
}

BU_TAR=$(fetch $BU_PKG/binutils.desc)
GCC_TAR=$(fetch $GCC_PKG/gcc.desc)

# ---- binutils ----------------------------------------------------------------
unpack "$BU_TAR" $TC/binutils-$BU_VER
patch_tree $TC/binutils-$BU_VER $BU_PKG
rm -rf $TC/build-binutils && mkdir -p $TC/build-binutils && cd $TC/build-binutils
../binutils-$BU_VER/configure --target=ia64-linux --prefix="$PREFIX" \
	--disable-nls --disable-werror --disable-gdb --disable-gdbserver \
	--disable-sim --disable-gprofng --disable-multilib
make -j"$JOBS"
make install
export PATH="$PREFIX/bin:$PATH"

# ---- gcc + libgcc ---------------------------------------------------------------
unpack "$GCC_TAR" $TC/gcc-$GCC_VER
patch_tree $TC/gcc-$GCC_VER $GCC_PKG
rm -rf $TC/build-gcc && mkdir -p $TC/build-gcc && cd $TC/build-gcc
../gcc-$GCC_VER/configure --target=ia64-linux --enable-targets=all \
	--prefix="$PREFIX" --enable-languages=c --without-headers \
	--disable-bootstrap --disable-nls --disable-threads --disable-shared \
	--disable-libmudflap --disable-libssp --disable-libgomp \
	--disable-decimal-float --disable-libquadmath --disable-libatomic \
	--disable-libcc1 --disable-libmpx --enable-checking=release \
	--with-system-libunwind --enable-obsolete \
	--with-pkgversion="altix_cross T2-patched"
make -j"$JOBS" all-gcc all-target-libgcc
make install-gcc install-target-libgcc

"$PREFIX/bin/ia64-linux-gcc" --version | head -1
echo "installed in $PREFIX"
