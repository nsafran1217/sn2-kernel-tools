#!/bin/bash
# Generate-SN2-T2-ISO.sh — Build a custom T2 live ISO from offline components.
#
# What this does:
#   1. Extracts an existing T2 ISO (squashfs provides all the system binaries
#      that the initrd needs — udevd, kmod, embutils, etc.)
#   2. Grafts your kernel modules and System.map into the extracted squashfs root.
#   3. Generates a fresh initrd using T2's mkinitrd.sh (fetched from SVN tag 26.3),
#      pulling modules from your kernel/ folder and binaries from the squashfs.
#   4. Splices the live-boot init (squashfs-scanning / overlayfs logic) onto the
#      initrd after the hardware-init PANICMARK cut point.
#   5. Copies the kernel image, System.map, and initrd into the squashfs /boot/
#      and creates standard unversioned symlinks:
#        vmlinuz -> vmlinuz-<VER>
#        vmlinux -> vmlinuz-<VER>
#        System.map -> System.map-<VER>
#        initrd -> initrd-<VER>
#   6. Merges your grub tree (tools, modules, fonts, grub.d scripts) into the
#      squashfs so the installed system can run grub2-install / grub-mkconfig.
#   7. Repacks the squashfs with all of the above.
#   8. Builds a bootia64.efi EFI executable from your grub modules using
#      grub-mkimage, wraps it in a FAT image for EFI booting.
#   9. Assembles the final ISO with a clean /boot/ (no leftover kernels from
#      the original ISO) containing only your kernel, initrd, grub modules,
#      and a minimal grub.cfg with the following kernel cmdline appended:
#        modprobe.blacklist=amdgpu,radeon console=ttySG0,38400n8 systemd.unit=multi-user.target
#
# Folder layout expected by this script:
#
#   kernel/
#     boot/
#       vmlinuz-<VER>      kernel image
#       System.map-<VER>   required by mkinitrd/depmod
#     lib/
#       modules/<VER>/     kernel module tree — must contain modules.order and
#                          modules.builtin as produced by `make modules_install`
#
#   grub/                  collected from a running system with your patched grub:
#     usr/
#       lib/
#         grub/
#           ia64-efi/      grub module tree (*.mod, *.lst, moddep.lst, etc.)
#       sbin/
#         grub*            grub2-install, grub-mkconfig, grub-probe, etc.
#       share/
#         grub/            unicode.pf2, themes/, grub-mkconfig_lib, etc.
#     etc/
#       grub.d/            00_header, 10_linux, 40_custom, etc.
#
#   Collect from your running system with:
#     mkdir -p grub
#     cp -a /usr/lib/grub   grub/usr/lib/
#     cp -a /usr/sbin/grub* grub/usr/sbin/
#     cp -a /usr/share/grub grub/usr/share/
#     cp -a /etc/grub.d     grub/etc/
#
# Usage:
#   sudo ./Generate-SN2-T2-ISO.sh -i input.iso -o output.iso \
#        --kernel-dir ./kernel \
#        --grub-dir   ./grub   \
#        [--workdir   /tmp/remaster]   # default: /tmp/remaster-$$
#        [--keep-workdir]              # don't delete workdir on exit
#
# T2 scripts (mkinitrd.sh and target/share/live/init) are fetched automatically
# from https://svn.exactcode.de/t2/tags/26.3 — no local T2 source tree needed.
#
# Must run as root — mkinitrd uses mknod for /dev nodes.
#
# Host requirements:
#   xorriso        (osirrox for ISO extraction, xorrisofs for ISO creation)
#   squashfs-tools (unsquashfs, mksquashfs)
#   kmod           (modinfo, depmod)
#   grub-mkimage   (from grub2 on the build host)
#   cpio, zstd, curl
#   mtools         (mkfs.vfat, mmd, mcopy) — for the EFI FAT image

set -euo pipefail

# ── T2 SVN source URLs (tag 26.3) ─────────────────────────────────────────────

T2_SVN_BASE="https://svn.exactcode.de/t2/tags/26.3"
T2_MKINITRD_URL="$T2_SVN_BASE/package/base/mkinitrd/mkinitrd.sh"
T2_LIVE_INIT_URL="$T2_SVN_BASE/target/share/live/init"

# ── defaults ─────────────────────────────────────────────────────────────────

input_iso=
output_iso=
kernel_dir=
grub_dir=
workdir=
keep_workdir=

# ── argument parsing ──────────────────────────────────────────────────────────

usage() {
    grep '^#' "$0" | grep -v '^#!/' | sed 's/^# \?//'
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -i)             input_iso="$2";   shift 2 ;;
        -o)             output_iso="$2";  shift 2 ;;
        --kernel-dir)   kernel_dir="$2";  shift 2 ;;
        --grub-dir)     grub_dir="$2";    shift 2 ;;
        --workdir)      workdir="$2";     shift 2 ;;
        --keep-workdir) keep_workdir=1;   shift   ;;
        -h|--help)      usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

[[ -z "$input_iso"  ]] && echo "Error: -i input.iso is required"   && exit 1
[[ -z "$output_iso" ]] && echo "Error: -o output.iso is required"  && exit 1
[[ -z "$kernel_dir" ]] && echo "Error: --kernel-dir is required"   && exit 1
[[ -z "$grub_dir"   ]] && echo "Error: --grub-dir is required"     && exit 1
[[ ! -f "$input_iso" ]] && echo "Error: $input_iso not found"      && exit 1
[[ $UID -ne 0 ]]        && echo "Error: must run as root (mkinitrd requires mknod)" && exit 1

# ── check tools ───────────────────────────────────────────────────────────────

need() { type -p "$1" >/dev/null || { echo "Error: '$1' not found — please install ${2:-$1}"; exit 2; }; }

need osirrox    xorriso
need xorrisofs  xorriso
need unsquashfs squashfs-tools
need mksquashfs  squashfs-tools
need modinfo    kmod
need depmod     kmod
need cpio       cpio
need zstd       zstd
need curl       curl
need mkfs.vfat  mtools
need mmd        mtools
need mcopy      mtools
need grub-mkimage grub2

# ── workdir setup ─────────────────────────────────────────────────────────────

[[ -z "$workdir" ]] && workdir="/tmp/remaster-$$"
workdir="$(mkdir -p "$workdir" && cd "$workdir" && pwd)"

iso_extract="$workdir/iso"
squashfs_root="$workdir/rootfs"
initrd_overlay="$workdir/initrd-overlay"
t2_cache="$workdir/t2"

mkdir -p "$iso_extract" "$squashfs_root" "$initrd_overlay/bin" "$initrd_overlay/sbin" "$t2_cache"

cleanup() {
    [[ -z "$keep_workdir" ]] && rm -rf "$workdir"
}
trap cleanup EXIT

# ── download T2 source files from SVN tag 26.3 ───────────────────────────────

mkinitrd_sh="$t2_cache/mkinitrd.sh"
live_init="$t2_cache/live-init"

echo "==> Fetching T2 scripts from $T2_SVN_BASE ..."
curl -fsSL "$T2_MKINITRD_URL"  -o "$mkinitrd_sh" || { echo "Error: failed to fetch mkinitrd.sh";  exit 1; }
curl -fsSL "$T2_LIVE_INIT_URL" -o "$live_init"   || { echo "Error: failed to fetch live/init";    exit 1; }
chmod +x "$mkinitrd_sh"

# Patch live/init to create /run/live marker before switch_root.
# This lands in the real root's /run/live after switch_root and is used
# as the ConditionPathExists for live-only systemd services.
sed -i 's|boot $init "$@"|mkdir -p /mnt/run\n\t    touch /mnt/run/live\n\t    boot $init "$@"|' "$live_init"

echo "    mkinitrd.sh : $(wc -l < "$mkinitrd_sh") lines"
echo "    live/init   : $(wc -l < "$live_init") lines"

# ── resolve kernel version ────────────────────────────────────────────────────

kernelver=$(find "$kernel_dir/lib/modules" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | head -1)
[[ -z "$kernelver" ]] && echo "Error: no version directory found under $kernel_dir/lib/modules/" && exit 1

kernel_img=$(find "$kernel_dir/boot" -name 'vmlinuz-*' 2>/dev/null | head -1)
kernel_img_uncompressed=$(find "$kernel_dir/boot" -name 'vmlinux-*' 2>/dev/null | head -1)
kernel_basename="${kernel_img##*/}"
kernel_basename_uncompressed="${kernel_img_uncompressed##*/}"
sysmap="$kernel_dir/boot/System.map-$kernelver"
moddir="$kernel_dir/lib/modules/$kernelver"

[[ -z "$kernel_img"              ]] && echo "Error: no vmlinuz-* found under $kernel_dir/boot/"  && exit 1
[[ -z "$kernel_img_uncompressed" ]] && echo "Error: no vmlinux-* found under $kernel_dir/boot/" && exit 1
[[ ! -f "$sysmap"   ]]  && echo "Error: $sysmap not found"                             && exit 1
[[ ! -d "$moddir"   ]]  && echo "Error: $moddir not found"                             && exit 1

echo "==> Kernel version : $kernelver"
echo "    Kernel image   : $kernel_img"
echo "    Kernel (raw)   : $kernel_img_uncompressed"
echo "    System.map     : $sysmap"
echo "    Module dir     : $moddir"

# ── step 1: extract ISO ───────────────────────────────────────────────────────

echo
echo "==> Extracting ISO: $input_iso"
osirrox -indev "$input_iso" -extract / "$iso_extract/"

sqf=$(find "$iso_extract" -name "live.squash" | head -1)
[[ -z "$sqf" ]] && echo "Error: live.squash not found in ISO" && exit 1
echo "    Found squashfs : $sqf"

# ── step 2: extract squashfs for system binaries ──────────────────────────────

echo
echo "==> Extracting squashfs (this provides the initrd binaries) ..."
unsquashfs -f -d "$squashfs_root" "$sqf"

[[ -f "$squashfs_root/sbin/initrdinit" ]] ||
    { echo "Error: /sbin/initrdinit not found in squashfs — wrong ISO?"; exit 1; }

# ── step 3: overlay kernel modules + System.map into the squashfs root ────────
#
# mkinitrd uses a single -R root for everything: modules, binaries, libs,
# configs. We temporarily graft our kernel's modules and System.map into
# the extracted squashfs so that -R points to one consistent tree.

echo
echo "==> Grafting kernel modules into squashfs root ..."

# Remove any existing modules from the squashfs (different kernel version)
rm -rf "$squashfs_root/lib/modules"
mkdir -p "$squashfs_root/lib/modules"
cp -a "$kernel_dir/lib/modules/$kernelver" "$squashfs_root/lib/modules/"

# System.map goes into boot/
mkdir -p "$squashfs_root/boot"

# Remove old kernel files (ending in -t2) and any broken symlinks they leave behind
echo "    Removing old kernel files from squashfs /boot/ ..."
find "$squashfs_root/boot" -maxdepth 1 \( -type f -o -type l \) -name "*-t2" -delete
# Remove any symlinks that are now broken (kconfig, minird, netrd, etc.)
find "$squashfs_root/boot" -maxdepth 1 -type l | while read lnk; do
    [[ -e "$lnk" ]] || { echo "      Removing dangling symlink: ${lnk##*/}"; rm -f "$lnk"; }
done

cp -f "$sysmap" "$squashfs_root/boot/"

echo "    Modules copied : $(find "$squashfs_root/lib/modules/$kernelver" -name '*.ko*' | wc -l) .ko files"

# Copy the kernel image and System.map into the squashfs /boot so the running
# live system has them available, then create standard unversioned symlinks:
#   /boot/vmlinuz    -> vmlinuz-$kernelver
#   /boot/System.map -> System.map-$kernelver
cp -f "$kernel_img"              "$squashfs_root/boot/$kernel_basename"
cp -f "$kernel_img_uncompressed" "$squashfs_root/boot/$kernel_basename_uncompressed"
# System.map was already copied above for mkinitrd; ensure it is present
cp -f "$sysmap" "$squashfs_root/boot/System.map-$kernelver"

ln -sf "$kernel_basename"              "$squashfs_root/boot/vmlinuz"
ln -sf "$kernel_basename_uncompressed" "$squashfs_root/boot/vmlinux"
ln -sf "System.map-$kernelver"         "$squashfs_root/boot/System.map"
echo "    Symlink : /boot/vmlinuz -> $kernel_basename"
echo "    Symlink : /boot/vmlinux -> $kernel_basename_uncompressed"
echo "    Symlink : /boot/System.map -> System.map-$kernelver"

# ── step 4: generate the initrd ───────────────────────────────────────────────

echo
echo "==> Running mkinitrd ..."

initrd_out="$workdir/initrd-$kernelver"
initrd_plain="$workdir/initrd-plain-$kernelver"

bash "$mkinitrd_sh" \
    -R "$squashfs_root" \
    -o "$initrd_out" \
    "$kernelver"

echo "    Initrd size    : $(du -sh "$initrd_out" | cut -f1)"
cp -f "$initrd_out" "$initrd_plain"

# ── step 5: build the live-boot init and extend the initrd ───────────────────
#
# The initrd's /init is currently T2's initrdinit.sh (hardware init, udev,
# module loading, LVM/LUKS, NFS root, etc.) followed by # PANICMARK and a
# debug shell fallback.
#
# For the live ISO we need to replace everything after # PANICMARK with the
# squashfs-scanning / loop-mount / overlayfs logic from target/share/live/init.

echo
echo "==> Building live-boot init overlay ..."

# The initrd already contains /init as initrdinit. Extract and splice it.
initrd_unpack="$workdir/initrd-unpack"
mkdir -p "$initrd_unpack"
(cd "$initrd_unpack" && zstd -d -c "$initrd_out" | cpio -i --quiet)

# Splice: hardware init (up to PANICMARK) + live squashfs-mount logic
sed '/PANICMARK/Q' "$initrd_unpack/init" > "$initrd_unpack/init.new"
cat "$live_init"                         >> "$initrd_unpack/init.new"
chmod +x "$initrd_unpack/init.new"
mv "$initrd_unpack/init.new" "$initrd_unpack/init"

# Repack
echo "    Repacking with live-boot init ..."
(cd "$initrd_unpack" && find . | cpio -o -H newc --quiet | zstd -19 -T0 -q > "$initrd_out")
rm -rf "$initrd_unpack"

echo "    Final initrd   : $(du -sh "$initrd_out" | cut -f1)"

# ── Resolve grub platform ─────────────────────────────────────────────────────

grub_lib_dir="$grub_dir/usr/lib/grub"
[[ -d "$grub_lib_dir" ]] || { echo "Error: $grub_lib_dir not found — check your grub/ layout"; exit 1; }
grub_modules_src=$(find "$grub_lib_dir" -mindepth 1 -maxdepth 1 -type d | head -1)
[[ -z "$grub_modules_src" ]] && { echo "Error: no platform dir found under $grub_lib_dir"; exit 1; }
grub_platform="${grub_modules_src##*/}"
# ── step 6: set up the ISO directory ─────────────────────────────────────────

echo
echo "==> Preparing ISO tree ..."

iso_boot="$iso_extract/boot"
mkdir -p "$iso_boot"

# Remove any kernels and initrds from the original ISO
rm -f "$iso_boot"/vmlinuz-* "$iso_boot"/vmlinux-* "$iso_boot"/initrd-* "$iso_boot"/initrd

# Install our kernel (both compressed and uncompressed)
cp -f "$kernel_img"              "$iso_boot/$kernel_basename"
cp -f "$kernel_img_uncompressed" "$iso_boot/$kernel_basename_uncompressed"
echo "    Kernel         : /boot/$kernel_basename"
echo "    Kernel (raw)   : /boot/$kernel_basename_uncompressed"

# Place initrd
cp -f "$initrd_out" "$iso_boot/initrd-$kernelver"
echo "    Initrd         : /boot/initrd-$kernelver"
# ── step 7: set up grub ───────────────────────────────────────────────────────
#
# Expected grub/ layout (collected from a running system):
#   grub/usr/lib/grub/<platform>/   module tree  (*.mod, moddep.lst, etc.)
#   grub/usr/sbin/grub-*            grub tools
#   grub/usr/share/grub/            unicode.pf2 etc.
#   grub/etc/grub.d/                mkconfig scripts
#
# grub-mkimage is run here to produce the EFI executable from those modules.
# The modules and tools are also merged into the squashfs so the installed
# system can run grub-install / grub-mkconfig.

echo
echo "==> Setting up grub ..."

# Derive the EFI executable name from the platform
case "$grub_platform" in
    x86_64-efi) efi_basename="bootx64.efi"  ;;
    i386-efi)   efi_basename="bootia32.efi" ;;
    ia64-efi)   efi_basename="bootia64.efi" ;;
    arm64-efi)  efi_basename="bootaa64.efi" ;;
    arm-efi)    efi_basename="bootarm.efi"  ;;
    *)          efi_basename="boot.efi"     ;;
esac

echo "    Grub platform  : $grub_platform"
echo "    EFI executable : $efi_basename"

# ── Build the EFI executable from the modules ─────────────────────────────────
# Embed enough modules that grub can find grub.cfg on ANY filesystem/device:
#   - search + search_fs_file: scan all partitions for a file
#   - iso9660: read the ISO9660 filesystem (DVD or dd'd disk)
#   - fat: read the EFI FAT partition
#   - ext2: read ext2/3/4 (installed system)
#   - part_msdos + part_gpt: understand partition tables
#   - regexp: needed for the prefix stub
#   - linux + initrd: load the kernel
#   - normal + configfile: load grub.cfg and process it

# The prefix stub searches all partitions for /boot/grub/grub.cfg
# so grub.cfg is found whether booting from DVD or a dd'd SATA disk.
cat > "$workdir/efi-prefix.cfg" <<'EOF'
search --no-floppy --file --set=root /boot/grub/grub.cfg
set prefix=($root)/boot/grub
EOF

echo "    Building $efi_basename with grub-mkimage ..."
efi_out="$workdir/$efi_basename"
grub-mkimage \
    -O "$grub_platform" \
    -p /boot/grub \
    -d "$grub_modules_src" \
    -o "$efi_out" \
    -c "$workdir/efi-prefix.cfg" \
    --compression auto \
    iso9660 fat ext2 part_msdos part_gpt regexp \
    search search_fs_file normal configfile linux

# ── Copy modules into the ISO and wrap EFI executable in a FAT image ─────────

mkdir -p "$iso_extract/boot/grub/$grub_platform"
cp -a "$grub_modules_src/." "$iso_extract/boot/grub/$grub_platform/"
echo "    Grub modules   : /boot/grub/$grub_platform/ ($(find "$grub_modules_src" -name '*.mod' | wc -l) modules)"

# Place the EFI executable as a plain file in the ISO tree (efi/boot/)
# so IA-64 firmware can find it directly on the ISO9660 filesystem
mkdir -p "$iso_extract/efi/boot"
cp -f "$efi_out" "$iso_extract/efi/boot/$efi_basename"
echo "    EFI plain      : efi/boot/$efi_basename"

# Also wrap it in a FAT image for the appended EFI partition
efi_img="$iso_extract/efi.img"
dd if=/dev/zero bs=1024 count=1440 of="$efi_img" 2>/dev/null
mkfs.vfat "$efi_img"
mmd  -i "$efi_img" ::/EFI
mmd  -i "$efi_img" ::/EFI/BOOT
mcopy -i "$efi_img" "$efi_out" "::/EFI/BOOT/$efi_basename"
echo "    EFI image      : efi.img ($(du -sh "$efi_img" | cut -f1))"
# ── step 8: write grub.cfg ────────────────────────────────────────────────────

grub_cfg="$iso_extract/boot/grub/grub.cfg"
echo
echo "==> Writing grub.cfg ..."

KERNEL_CMDLINE="modprobe.blacklist=amdgpu,radeon console=ttySG0,38400n8 systemd.unit=multi-user.target"

cat > "$grub_cfg" <<GRUBCFG
set timeout=8
set default=0
set fallback=1

GRUBCFG

for k in $(find "$iso_boot" -name 'vmlinux-*' | sort); do
    kver="${k##*/}"
    kver="${kver#vmlinux-}"
    kname="${k##*/}"
    initrd_entry="/boot/initrd-$kver"

    cat >> "$grub_cfg" <<ENTRY
menuentry "T2 Live ($kver)" {
    linux /boot/$kname $KERNEL_CMDLINE
    initrd $initrd_entry
}

ENTRY
    echo "    Menu entry     : T2 Live ($kver)"
done

cat >> "$grub_cfg" <<'GRUBCFG'
menuentry "Boot from hard disk" {
    if [ "$grub_platform" != "efi" ]; then
        chainloader (hd0)+1
    else
        set root=(hd0,gpt1)
        insmod regexp
        chainloader ($root)/efi/boot/boot*.efi
    fi
}
GRUBCFG
# ── step 9: repack the squashfs ───────────────────────────────────────────────

# Copy initrd into squashfs /boot and create unversioned symlink
cp -f "$initrd_plain" "$squashfs_root/boot/initrd-$kernelver"
ln -sf "initrd-$kernelver" "$squashfs_root/boot/initrd"
echo "    Symlink : /boot/initrd -> initrd-$kernelver"

# ── Merge grub into the squashfs so the installed system has working grub ────

echo "==> Merging grub into squashfs ..."
# usr/lib/grub/<platform>/
mkdir -p "$squashfs_root/usr/lib/grub"
cp -a "$grub_lib_dir/." "$squashfs_root/usr/lib/grub/"
# usr/sbin/grub*
if [[ -d "$grub_dir/usr/sbin" ]]; then
    mkdir -p "$squashfs_root/usr/sbin"
    cp -a "$grub_dir/usr/sbin"/grub* "$squashfs_root/usr/sbin/" 2>/dev/null || true
fi
# usr/share/grub/  (unicode.pf2 etc.)
if [[ -d "$grub_dir/usr/share/grub" ]]; then
    mkdir -p "$squashfs_root/usr/share/grub"
    cp -a "$grub_dir/usr/share/grub/." "$squashfs_root/usr/share/grub/"
fi
# etc/grub.d/
if [[ -d "$grub_dir/etc/grub.d" ]]; then
    mkdir -p "$squashfs_root/etc/grub.d"
    cp -a "$grub_dir/etc/grub.d/." "$squashfs_root/etc/grub.d/"
fi

# ── Install live-only systemd service to start serial console ───────────────

echo "==> Installing live-serial-console.service ..."
mkdir -p "$squashfs_root/etc/systemd/system"
mkdir -p "$squashfs_root/etc/systemd/system/multi-user.target.wants"

cat > "$squashfs_root/etc/systemd/system/live-serial-console.service" <<'UNIT'
[Unit]
Description=Start serial console on live boot
After=multi-user.target
ConditionPathExists=/run/live

[Service]
Type=oneshot
ExecStart=/bin/systemctl start serial-getty@ttySG0.service
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
UNIT

ln -sf /etc/systemd/system/live-serial-console.service \
    "$squashfs_root/etc/systemd/system/multi-user.target.wants/live-serial-console.service"

echo
echo "==> Repacking squashfs ..."
new_sqf="$workdir/live.squash"
mksquashfs "$squashfs_root" "$new_sqf" -noappend -comp zstd -Xcompression-level 19 \
    -b 1M -processors "$(nproc)" -quiet
# Replace the squashfs in the ISO tree
cp -f "$new_sqf" "$sqf"
echo "    Squashfs size  : $(du -sh "$sqf" | cut -f1)"
# ── step 10: build the ISO ────────────────────────────────────────────────────

echo
echo "==> Building ISO: $output_iso"

xorrisofs \
    -r -J -l -quiet \
    -V "T2" \
    -A "T2 SDE (remastered)" \
    -publisher "T2 System Development Environment - https://t2sde.org" \
    -eltorito-alt-boot \
    -no-emul-boot \
    -partition_offset 16 \
    -append_partition 2 0xef "$efi_img" \
    -e --interval:appended_partition_2:all:: \
    -iso_mbr_part_type 0x83 \
    -o "$output_iso" \
    "$iso_extract/"

echo
echo "==> Done: $output_iso ($(du -sh "$output_iso" | cut -f1))"
