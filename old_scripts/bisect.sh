#!/bin/bash
# Start in base dir

set -e



_BASE_DIR=$(pwd)

echo $_BASE_DIR


#CROSS_COMPILER_PATH="$_BASE_DIR/tools/gcc-11.5.0-nolibc/ia64-linux"
CROSS_COMPILER_PATH="$_BASE_DIR/tools/gcc-14.2.0-nolibc/ia64-linux"
export PATH="${CROSS_COMPILER_PATH}/bin:$PATH"
CROSS_COMPILER=$(basename "${CROSS_COMPILER_PATH}/bin/ia64-linux-gcc")
CROSS_COMPILER_AND_VERSION=$(${CROSS_COMPILER} --version | head -n1)

echo $CROSS_COMPILER_AND_VERSION



# Copy kernel config
cp ./config/ns-altix-bisect ./src/linux-stable-bisect/.config

# Build the kernel
cd $_BASE_DIR/src/linux-stable-bisect
ver=$(git log --oneline | head -n1 | grep -o "Linux\ .*" | cut -d' ' -f2-)
echo $ver

# define LOCALVERSION
_currentCommitHashShort=$( git rev-parse --short HEAD )

if [[ "$_currentCommitHashShort" == "" ]]; then

	_localversionCurrentCommit=""
else
	_localversionCurrentCommit="-${_currentCommitHashShort}"
fi

_localversion="${_localversionCurrentCommit}-ia64"

if [[ $EMPTY_LOCALVERSION -eq 1 ]]; then

	_localversion=""
fi
echo $_localversion

pwd
#untested
echo "SED to fix bug"
sed -i 's/void sn_dma_flush(u64 addr)/void sn_dma_flush(unsigned long addr)/' ./arch/ia64/sn/pci/pcibr/pcibr_dma.c

make LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- olddefconfig
echo "kern release"
make -s LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- kernelrelease
echo "tar-pkg"
make -j$(nproc) LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- tar-pkg

# Move the tarball and include vmlinuz if desired
#make dir to tar

tarname=$(ls linux-*-ia64.tar)
mkdir $_BASE_DIR/release/linux-${_localversion}-ia64
#move tar
mv "$tarname" "$_BASE_DIR/release/linux-${_localversion}-ia64/"

#cp vmlinuz
mkdir "$_BASE_DIR/release/linux-${_localversion}-ia64/boot"
cp vmlinux.gz "$_BASE_DIR/release/linux-${_localversion}-ia64/boot/vmlinuz-$ver"
#cd
cd "$_BASE_DIR/release/linux-${_localversion}-ia64/"
#extract then recombine
tar xf "$_BASE_DIR/release/linux-${_localversion}-ia64/$tarname"
rm -f "$_BASE_DIR/release/linux-${_localversion}-ia64/$tarname"
tar cf "$_BASE_DIR/release/bisect-$tarname" .

echo "Kernel package for $_localversion created at $_BASE_DIR/release/bisect-$tarname.tar"
