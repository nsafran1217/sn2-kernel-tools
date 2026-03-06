#!/bin/bash

# t2trap - bootstrap T2 root FS
# 2024 Frank Scheiner

_myName="t2trap"
_version="0.3.1"

_default_bootstrap_type="minimal"

_minimal_pkg_list="00-dirtree ncurses mpfr gmp gdbm glibc32 less readline openssl bash mksh coreutils util-linux diffutils file kmod make pam patch udev findutils gawk grep pcre2 sed glibc sysfiles t2-src xz zlib zstd tar time libxcrypt nghttp2 curl brotli libpsl icu4c gcc isl mpc linux-header binutils flex m4 texinfo bison gettext gzip libxml expat unzip glib pkgconfig apr apr-util serf sqlite utf8proc lz4 subversion"

_pkg_suffix=".tar.zst"

on_exit()
{
	# unmount all mounted dirs
	for _mount in $MOUNTS; do

		umount "$_mount"
	done

	return
}

trap on_exit EXIT

mount_iso()
{
	local _iso="$1"
	local _mount="$2"

	mount -o loop "$_iso" "$_mount" 2>/dev/null

	return
}


mount_http_dir()
{
	local _http_dir="$1"
	local _mount="$2"

	httpdirfs "$_http_dir" "$_mount" 2>/dev/null

	return
}


if [[ "$1" == "" ]]; then

	cat <<-USAGE
		usage: ${_myName} TARGET SOURCE_ISO [TYPE]
		       ${_myName} [--help]

		--help gives more information
	USAGE

	exit 64 # command line usage error

elif [[ "$1" == "--help" || "$1" == "-h" ]]; then

	cat <<-HELP
		${_myName} v${_version}

		SYNOPSIS:

		${_myName} TARGET SOURCE_ISO [TYPE]


		DESCRIPTION:

		t2trap is a tool like slackstrap, but instead allows to
		create T2 root file systems from release ISOs.


		OPTIONS:

		The options are as follows:

		TARGET         The target directory for the root FS. If not
		               existing, it will be created.

		SOURCE_ISO     The full URL to the source ISO used for the
		               bootstrap. Can also be a local file. When not
		               available locally, then the httpdirfs tool is
		               needed!

		TYPE           The type of bootstrap, either "full" or
		               "minimal". If empty, the default "${_default_bootstrap_type}" is
		               used.

		----------------------------------------------------------------

		[--help|-h]    Prints out this help message.
	HELP

	exit 0
fi

_target="$1"

_source_iso="$2"

if [[ "$3" != "" ]]; then

	_type="$3"
else
	_type="$_default_bootstrap_type"
fi

if [[ "$_source_iso" == "" ]]; then

	echo "E: SOURCE_ISO argument is empty. Cannot continue." 1>&2
	exit 1

elif [[ -e "$_source_iso" ]]; then

	# source ISO is a local file, mount directly
	_iso_mount=$( mktemp -d )

	if ! mount_iso "$_source_iso" "$_iso_mount"; then

		echo "E: \"$_source_iso\" could not be mounted. Cannot continue." 1>&2
		exit 2
	fi

	MOUNTS="$_iso_mount"	
else
	# assume URL
	# 1. mount remote HTTP(S) dir
	_http_mount=$( mktemp -d )

	if ! mount_http_dir "$( dirname $_source_iso )/" "$_http_mount"; then

		echo "E: \"$( dirname $_source_iso )/\" could not be mounted. Cannot continue." 1>&2
		exit 3
	fi	

	MOUNTS="$_http_mount"

	# 2. mount actual ISO
	_iso_mount=$( mktemp -d )

	if ! mount_iso "${_http_mount}/$( basename $_source_iso )" "$_iso_mount"; then

		echo "E: \"${_http_mount}/$( basename $_source_iso )\" could not be mounted. Cannot continue." 1>&2
		exit 2
	fi

	MOUNTS="$_iso_mount $MOUNTS"
fi

if [[ ! -d "$_target" ]]; then

	mkdir -p "$_target" || exit 4
fi

pushd "$_target" &>/dev/null

if [[ "$_type" == "minimal" ]]; then

	for _pkg in $_minimal_pkg_list; do

		if [[ "$_pkg" == "mksh" ]]; then

			echo -n "$( basename ${_iso_mount}/*/pkgs/${_pkg}-R[0-9]* ) ..."
			tar --numeric-owner -xpf $( echo ${_iso_mount}/*/pkgs/${_pkg}-R[0-9]* )
			echo " OK"
		else
			# Won't work for mksh[-R59c.tar.zst]
			echo -n "$( basename ${_iso_mount}/*/pkgs/${_pkg}-[0-9]* ) ..."
			tar --numeric-owner -xpf $( echo ${_iso_mount}/*/pkgs/${_pkg}-[0-9]* )
			echo " OK"
		fi
	done
else
	for _pkg in $( echo ${_iso_mount}/*/pkgs/*${_pkg_suffix} ); do

		_pkg_list="${_pkg_list} $( basename $_pkg )"
	done

	for _pkg in $_pkg_list; do

		echo -n "$_pkg ..."
		tar --numeric-owner -xpf ${_iso_mount}/*/pkgs/${_pkg}
		echo " OK"
	done
fi

popd &>/dev/null

exit
