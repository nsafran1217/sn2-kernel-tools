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

## Howto:

I suggest making a new directory to do this in
```
mkdir t2work
cd t2work
```

1. Download the ia64 ISO from [https://dl.t2sde.org/binary/2026/](https://dl.t2sde.org/binary/2026/)  
The current version of T2 this is written for is 26.3.  
```
wget https://dl.t2sde.org/binary/2026/t2-26.3-ia64-desktop.iso
```
2. Download the script `Generate-SN2-T2-ISO.sh`. You must have 5GB of free disk space for this to work.  

```
wget https://raw.githubusercontent.com/nsafran1217/sn2-kernel-tools/refs/heads/main/T2-SN2/Generate-SN2-T2-ISO.sh
```

3. Download and extract an SN2 kernel. Place the extracted items in a directory called `sn2-kernel`.
```
wget https://github.com/nsafran1217/linux-sn2/releases/download/v7.0-rc1-epic1-sn2-beta/linux-7.0.0-rc1-epic1-SN2-9cf2872e9999-ia64-ia64.tar.gz
mkdir sn2-kernel
cd sn2-kernel
tar xf ../linux-7.0.0-rc1-epic1-SN2-9cf2872e9999-ia64-ia64.tar.gz
cd ..
```
4. Download the patched grub from here and extract. It will extract to a folder called `grub`.
```
wget https://github.com/nsafran1217/linux-sn2/releases/download/v7.0-rc1-epic1-sn2-beta/grub-sn2.tar.gz
tar xf grub-sn2.tar.gz
```

5. Create the ISO. By default, this will work in /tmp.  
If you want, you can specify a `--workdir` and to `--keep-workdir` to help troubleshoot if there is an issue.  
```
./Generate-SN2-T2-ISO.sh \
    -i t2-26.3-ia64-desktop.iso \
    -o t2-26.3-Altix.iso \
    --kernel-dir ./sn2-kernel \
    --grub-dir   ./grub \
    --workdir ./workdir \
    --keep-workdir
```

6. Burn your ISO, or dd to a disk

`dd if=t2-26.3-Altix.iso of=/dev/sdX status=progress bs=4M`

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