#!/bin/bash
# this script is used to compile a linux kernel
# It will copy a known config and apply two patches to fix known altix boot issues


#_BASE_DIR=$(pwd)

_BASE_DIR=~/projects/altix_cross

echo $_BASE_DIR

cd $_BASE_DIR
source sn2-kernel-tools/setup_cross.sh

cd src/mainline/linux-sn2

_BOOTSERVER="10.40.0.121"

# Build the kernel
#cd $_BASE_DIR/src/mainline/linux
# do it in pwd
if [ ! -f .config ]; then
	echo ".config not found, are you in a linux source tree?"
	exit 1
fi




_RELEASE=0
_KERNSUFFIX="test"
for _arg in "$@"; do
	case "$_arg" in
		--release) _RELEASE=1 ;;
		-*) echo "unknown option: $_arg"; echo "usage: $0 [--release] [kernel-suffix]"; exit 1 ;;
		*) _KERNSUFFIX=$_arg ;;
	esac
done
echo $_KERNSUFFIX


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

make LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- olddefconfig >/dev/null 2>&1
_kernelrelease=$(make -s LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- kernelrelease)

_srclocation=$(pwd)
_tarinstall="$_srclocation/tar-install"
rm -rf "$_tarinstall" # stale module dirs here would get rsynced to the boot server
mkdir -p "$_tarinstall/boot"

make -j$(nproc) LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- >/dev/null

make -j$(nproc) LOCALVERSION="${_localversion}" ARCH=ia64 CROSS_COMPILE=ia64-linux- \
    INSTALL_MOD_PATH="$_tarinstall" modules_install >/dev/null


#echo "Assembling boot files"
cp "$_srclocation/System.map"  "$_tarinstall/boot/System.map-${_kernelrelease}"
cp "$_srclocation/.config"     "$_tarinstall/boot/config-${_kernelrelease}"
cp "$_srclocation/vmlinux.gz"  "$_tarinstall/boot/vmlinuz-${_kernelrelease}"

if [[ $_RELEASE -eq 1 ]]; then
	cp "$_srclocation/vmlinux"     "$_tarinstall/boot/vmlinux-${_kernelrelease}"
fi

# Copy to NFS server
echo "copy to NFS boot server"

scp "$_tarinstall/boot/vmlinuz-${_kernelrelease}" $_BOOTSERVER:/t2/tftproot/t2/kernel/vmlinuz-$_KERNSUFFIX
scp "$_tarinstall/boot/vmlinuz-${_kernelrelease}" $_BOOTSERVER:/t2/altixroot/boot/vmlinuz-$_KERNSUFFIX

scp "$_srclocation/System.map"  "$_BOOTSERVER:/t2/altixroot/boot/System.map-${_kernelrelease}"
scp "$_srclocation/System.map"  "$_BOOTSERVER:/t2/altixroot/boot/System.map"
rsync -rl "$_tarinstall/lib/modules/" $_BOOTSERVER:/t2/altixroot/lib/modules/

echo "Copy complete, reboot to test ${_kernelrelease}"

#echo "Gen initrd"
#echo "${_kernelrelease}"
#ssh netboot "sudo /t2/mkinitrd -R /t2/altixroot/ -o /t2/altixroot/boot/initrd ${_kernelrelease}"
#
#ssh netboot 'cp /t2/altixroot/boot/initrd /t2/tftproot/t2/kernel/initrd'
#
echo "Copy complete, reboot to test ${_kernelrelease}"
#
if [[ $_RELEASE -eq 1 ]]; then
	echo "Tar'ing package"
	_tarname="linux-${_kernelrelease}.tar"
	mkdir -p "$_BASE_DIR/release"
	tar cfz "$_BASE_DIR/release/${_tarname}.gz" -C "$_tarinstall" .
	echo "Kernel package created at $_BASE_DIR/release/${_tarname}.gz"
fi

rm -rf "$_tarinstall"

echo "Done!: ${_kernelrelease}"
