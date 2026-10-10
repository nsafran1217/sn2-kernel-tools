#!/bin/bash
# Start in base dir

set -e
ver=$1
_BASE_DIR=$(pwd)

echo $_BASE_DIR

CROSS_COMPILER_PATH="$_BASE_DIR/tools/gcc-14.2.0-nolibc/ia64-linux"
export PATH="${CROSS_COMPILER_PATH}/bin:$PATH"
CROSS_COMPILER=$(basename "${CROSS_COMPILER_PATH}/bin/ia64-linux-gcc")
CROSS_COMPILER_AND_VERSION=$(${CROSS_COMPILER} --version | head -n1)

echo $CROSS_COMPILER_AND_VERSION

# Ensure the version argument is provided
if [ -z "$ver" ]; then
    echo "Usage: $0 <kernel_version>"
    exit 1
fi

# Copy kernel config
cp ./config/sn2-4.19.ns.config ./src/kerns/linux-${ver}/.config

# Build the kernel
cd $_BASE_DIR/src/kerns/linux-$ver

pwd
#untested
echo "SED to fix bug"
sed -i 's/void sn_dma_flush(u64 addr)/void sn_dma_flush(unsigned long addr)/' ./arch/ia64/sn/pci/pcibr/pcibr_dma.c

make ARCH=ia64 CROSS_COMPILE=ia64-linux- olddefconfig
echo "kern release"
make -s ARCH=ia64 CROSS_COMPILE=ia64-linux- kernelrelease
echo "tar-pkg"
make -j$(nproc) ARCH=ia64 CROSS_COMPILE=ia64-linux- tar-pkg

# Move the tarball and include vmlinuz if desired
#make dir to tar

tarname=$(ls linux-*-ia64.tar)
mkdir $_BASE_DIR/release/linux-${ver}-ia64
#move tar
mv "$tarname" "$_BASE_DIR/release/linux-${ver}-ia64/"

#cp vmlinuz
mkdir "$_BASE_DIR/release/linux-${ver}-ia64/boot"
cp vmlinux.gz "$_BASE_DIR/release/linux-${ver}-ia64/boot/vmlinuz-${ver}"
#cd
cd "$_BASE_DIR/release/linux-${ver}-ia64/"
#extract then recombine
tar xf "$_BASE_DIR/release/linux-${ver}-ia64/$tarname"
rm -f "$_BASE_DIR/release/linux-${ver}-ia64/$tarname"
tar cf "$_BASE_DIR/release/linux-${ver}-ia64.tar" .

echo "Kernel package for $ver created at $_BASE_DIR/release/linux-${ver}-ia64.tar"
