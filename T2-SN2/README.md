# Creating a custom T2 ISO for SGI Altix

These tools will allow you to create a T2 ISO you can burn to a DVD and boot your SGI  
Altix or Prism with to install T2 SDE Linux

### Preamble
The SGI SN2 Altix support in the kernel is decided when the kernel is compiled, and T2 does not host an ISO with 
Altix support. Unpatched grub2 also does not work on Altix. 
Therefore, we must modify the T2 ISO with our custom kernel, initrd, and grub2.

The resultant ISO can be burned to a DVD or `dd`'ed to a disk.  
`dd`'ing to a disk is the preferred way as it is more reliable.

## Dependencies:

* xorriso        (osirrox for ISO extraction, xorrisofs for ISO creation)
* squashfs-tools (unsquashfs, mksquashfs)
* kmod           (modinfo, depmod)
* grub-mkimage   (from grub2 on the build host)
* cpio, zstd, curl
* mtools         (mkfs.vfat, mmd, mcopy) — for the EFI FAT image

Building on macOS works too, see [Building on macOS](#building-on-macos) below.

## Howto:

I suggest making a new directory to do this in
```
mkdir t2work
cd t2work
```

1. Download the ia64 ISO from [https://dl.t2sde.org/binary/2026/](https://dl.t2sde.org/binary/2026/)  
The current version of T2 this is written for is 26.6. 26.3 will work as well 
```
wget https://dl.t2sde.org/binary/2026/t2-26.6-ia64-desktop-glibc-gcc-itanium2.iso
```
2. Download the script `Generate-SN2-T2-ISO.sh`. You must have 5GB of free disk space for this to work.  

```
wget https://raw.githubusercontent.com/nsafran1217/sn2-kernel-tools/refs/heads/main/T2-SN2/Generate-SN2-T2-ISO.sh
chmod +x ./Generate-SN2-T2-ISO.sh
```

3. Download and extract an SN2 kernel. Place the extracted items in a directory called `sn2-kernel`.
```
wget https://github.com/nsafran1217/linux-sn2/releases/download/v7.0-epic2-sn2-gpu/linux-7.0.0-epic2-SN2-GPU-cf436192c70f-ia64-ia64.tar.gz
mkdir sn2-kernel
cd sn2-kernel
tar xf ../linux-7.0.0-epic2-SN2-GPU-cf436192c70f-ia64-ia64.tar.gz
cd ..
```
4. Download the patched grub from here and extract. It will extract to a folder called `grub`.
```
wget https://github.com/nsafran1217/linux-sn2/releases/download/v7.0-epic2-sn2-gpu/grub-sn2.tar.gz
tar xf grub-sn2.tar.gz
```

5. Create the ISO. By default, this will work in /tmp.  
If you want, you can specify a `--workdir` and to `--keep-workdir` to help troubleshoot if there is an issue.  
```
sudo ./Generate-SN2-T2-ISO.sh \
    -i t2-26.6-ia64-desktop-glibc-gcc-itanium2.iso \
    -o t2-26.6-Altix.iso \
    --kernel-dir ./sn2-kernel \
    --grub-dir   ./grub \
    --workdir ./workdir \
    --keep-workdir
```

6. Burn your ISO, or dd to a disk

`dd if=t2-26.6-Altix.iso of=/dev/sdX status=progress bs=4M`

7. Boot like normal on Altix. Find the EFI file and launch it in the EFI shell.

```
Device mapping table
  fs0  : Acpi(PNP0A03,1)/Pci(3|0)/Sata(Pun1,Lun0)/HD(Part1,SigC89C51D6-208A-4A9D-A00E-DF7A29B0A00F)
  fs1  : Acpi(PNP0A03,1)/Pci(3|0)/Sata(Pun2,Lun0)/HD(Part2,Sig00000000)
  ....
Shell> fs1:
fs1:\> efi\boot\bootia64
```

8. Cleanup your workdir if needed

## Building on macOS

The script also runs on macOS (tested on Apple Silicon with Homebrew). The steps are the same as above, with these differences.

1. Install the tools with Homebrew. The GNU tools are needed because T2's `mkinitrd` expects GNU `sed`, `grep` and `find`, bash 4 or newer, and `readelf`. `x86_64-elf-grub` provides `x86_64-elf-grub-mkimage`, which builds ia64 EFI images like any other `grub-mkimage`. `wget` is only for the download commands in this guide.
```
brew install xorriso squashfs zstd mtools coreutils findutils gnu-sed grep bash binutils x86_64-elf-grub wget
```

2. Download `kmod-shim.py` next to the script. macOS has no `modinfo` or `depmod`; the shim stands in for both. Its `depmod` rebuilds the initrd's module index files from the ones in the kernel tarball, in the same binary format kmod writes.
```
wget https://raw.githubusercontent.com/nsafran1217/sn2-kernel-tools/refs/heads/main/T2-SN2/kmod-shim.py
chmod +x ./kmod-shim.py
```

3. Do not extract the kernel tarball yourself. A normal Mac disk is case-insensitive, so files whose names only differ in case overwrite each other (for example `xt_DSCP.ko` and `xt_dscp.ko`). Pass the tarball with `--kernel-tar` instead and the script unpacks it in its own work area. Extracting `grub-sn2.tar.gz` as in step 4 is fine.

4. Create the ISO. If the work directory is not on a case-sensitive volume, the script creates a case-sensitive APFS disk image for it and removes it again at the end (keep it with `--keep-workdir`). It grows to about 15GB, so make sure you have that much free space.
```
sudo ./Generate-SN2-T2-ISO.sh \
    -i t2-26.6-ia64-desktop-glibc-gcc-itanium2.iso \
    -o t2-26.6-Altix.iso \
    --kernel-tar ./linux-7.0.0-epic2-SN2-GPU-cf436192c70f-ia64-ia64.tar.gz \
    --grub-dir   ./grub
```

5. Write it to a disk. Find the disk number with `diskutil list`, unmount it, then write to the raw device `/dev/rdiskN`:
```
diskutil unmountDisk /dev/diskN
sudo dd if=t2-26.6-Altix.iso of=/dev/rdiskN bs=4m status=progress
```
