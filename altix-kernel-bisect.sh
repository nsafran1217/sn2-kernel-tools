#!/bin/bash
# this script is used to compile a linux kernel
# It will copy a known config and apply two patches to fix known altix boot issues


#_BASE_DIR=$(pwd)

_BASE_DIR=~/altix_cross

echo $_BASE_DIR



# Build the kernel
cd $_BASE_DIR/src/mainline/linux

# fix known compile bug
git apply $_BASE_DIR/sn2-kernel-tools/diff/sn_dma_flush.patch

#echo "SED to fix combile bug"
#sed -i 's/void sn_dma_flush(u64 addr)/void sn_dma_flush(unsigned long addr)/' ./arch/ia64/sn/pci/pcibr/pcibr_dma.c

# Fix IO_RESOURCE 
echo "fix io resource"
git apply $_BASE_DIR/sn2-kernel-tools/diff/io_resource.patch

# Fix sn_mmiowb.patch
echo "fix sn_mmiowb.patch"
#git apply $_BASE_DIR/sn2-kernel-tools/diff/sn_mmiowb.patch



set -e # end on any error


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

make LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- olddefconfig
echo "kern release"
make -s LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- kernelrelease
echo "tar-pkg"
make -j$(nproc) LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- tar-pkg

# Move the tarball and include vmlinuz if desired
#make dir to tar
pwd

tarname=$(ls linux-*-ia64.tar)
mkdir -p $_BASE_DIR/release/linux-${_localversion}-ia64
#move tar
mv "$tarname" "$_BASE_DIR/release/linux-${_localversion}-ia64/"

#cp vmlinuz
mkdir -p "$_BASE_DIR/release/linux-${_localversion}-ia64/boot"
cp vmlinux.gz "$_BASE_DIR/release/linux-${_localversion}-ia64/boot/vmlinuz-$ver"
#cd
cd "$_BASE_DIR/release/linux-${_localversion}-ia64/"
#extract then recombine
tar xf "$_BASE_DIR/release/linux-${_localversion}-ia64/$tarname"
rm -f "$_BASE_DIR/release/linux-${_localversion}-ia64/$tarname"
tar cf "$_BASE_DIR/release/$tarname" .

echo "Kernel package for $_localversion created at $_BASE_DIR/release/$tarname.tar"

# Copy to NFS server
scp boot/vmlinuz-$ver nfs:/t2/tftproot/t2/kernel/vmlinuz-test
scp boot/vmlinuz-$ver nfs:/t2/altixroot/boot/vmlinuz-test
rsync -rl --progress lib/modules/ nfs:/t2/altixroot/lib/modules/

cd ..
rm -rf linux-${_localversion}-ia64/

echo "Copy complete, reboot to test $ver $_localversion"