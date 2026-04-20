#!/bin/bash
# this script is used to compile a linux kernel
# It will copy a known config and apply two patches to fix known altix boot issues


#_BASE_DIR=$(pwd)

_BASE_DIR=~/altix_cross

echo $_BASE_DIR



# Build the kernel
#cd $_BASE_DIR/src/mainline/linux
# do it in pwd
if [ ! -f .config ]; then
	echo ".config not found, are you in a linux source tree?"
	exit 1
fi


# fix known compile bug
#echo "fix sn_dma_flush compile bug"
#git apply $_BASE_DIR/sn2-kernel-tools/diff/misc/sn_dma_flush.patch

#echo "SED to fix combile bug"
#sed -i 's/void sn_dma_flush(u64 addr)/void sn_dma_flush(unsigned long addr)/' ./arch/ia64/sn/pci/pcibr/pcibr_dma.c

# Fix IO_RESOURCE 
#echo "fix io resource"
#git apply $_BASE_DIR/sn2-kernel-tools/diff/misc/io_resource.patch

# Fix sn_mmiowb.patch
#echo "fix sn_mmiowb.patch"
#git apply $_BASE_DIR/sn2-kernel-tools/diff/misc/sn_mmiowb.patch



set -e # end on any error



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
_kernelrelease=$(make -s LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- kernelrelease)
echo "$_kernelrelease"

echo "tar-pkg"
make -j$(nproc) LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- tar-pkg

# Move the tarball and include vmlinuz if desired
#make dir to tar
_srclocation=$(pwd)
echo "$_srclocation"

# Package everything

_releasedir="$_BASE_DIR/release/linux-${_kernelrelease}"  # use kernelrelease, not localversion
_tarname=$(ls linux-*-ia64.tar)

mkdir -p "$_releasedir"
mv "$_tarname" "$_releasedir/"

tar xf "$_releasedir/$_tarname" -C "$_releasedir"
rm -f "$_releasedir/$_tarname"

cp "$_srclocation/vmlinux.gz" "$_releasedir/boot/vmlinuz-${_kernelrelease}"

tar cf "$_BASE_DIR/release/$_tarname" -C "$_releasedir" .
echo "Kernel package created at $_BASE_DIR/release/$_tarname"

# Copy to NFS server
scp "$_releasedir/boot/vmlinuz-${_kernelrelease}" nfs:/t2/tftproot/t2/kernel/vmlinuz-test
scp "$_releasedir/boot/vmlinuz-${_kernelrelease}" nfs:/t2/altixroot/boot/vmlinuz-test
rsync -rl "$_releasedir/lib/modules/" nfs:/t2/altixroot/lib/modules/

rm -rf "$_releasedir"

echo "Copy complete, reboot to test ${_kernelrelease}"
