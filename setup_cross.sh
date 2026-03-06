#!/bin/bash
_BASE_DIR=$(pwd)

echo $_BASE_DIR


#CROSS_COMPILER_PATH="$_BASE_DIR/tools/gcc-11.5.0-nolibc/ia64-linux"
CROSS_COMPILER_PATH="$_BASE_DIR/tools/gcc-14.2.0-nolibc/ia64-linux"
export PATH="${CROSS_COMPILER_PATH}/bin:$PATH"
CROSS_COMPILER=$(basename "${CROSS_COMPILER_PATH}/bin/ia64-linux-gcc")
CROSS_COMPILER_AND_VERSION=$(${CROSS_COMPILER} --version | head -n1)

echo $CROSS_COMPILER_AND_VERSION

export PATH="$_BASE_DIR/sn2-kernel-tools":$PATH
