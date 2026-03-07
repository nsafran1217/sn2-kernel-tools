# Notes added after i did most of the work.

So im rediscovering this unfortunalty.

Im just going to document the simple stuff I have, not the fancy scripts. If you need to bisect, relearn them.

To get started. Always start in the parent dir of this directory.


run `source sn2-kernel-tools/setup_cross.sh`

This sets up your PATH so you have the cross GCC avaliable

You can cd into a kernel tree, for example src/kerns/linux-4.19.325

Menuconfig:  
`make ARCH=ia64 CROSS_COMPILE=ia64-linux- menuconfig`

And to make it:  
`make -j$(nproc) ARCH=ia64 CROSS_COMPILE=ia64-linux- tar-pkg`

Grab your tar. It puts it in the working directory.  
This does not have the compressed kernel, but that okay. If you want it, grab vmlinux.gz 

# Bisecting kernels
Scirpt is `altix-kernel-bisect.sh` to build and apply git diff


Checkout the version you want to work with:


`git checkout v5.0`

### Initial setup in git tree
copy in the config you want:  
```
cp sn2-kernel-tools/configs/baremin_nfs_altix_nomod.config src/mainline/linux/.config
pushd src/mainline/linux/
make ARCH=ia64 CROSS_COMPILE=ia64-linux- olddefconfig
popd
```
copy firmware from a know good kern:  
`cp -r src/kerns/linux-4.19.325/firmware src/mainline/linux/`


After that, you are good to build with  


cd src/mainline/linux

altix-kernel-bisect.sh

then do you bisecting or whatevers


