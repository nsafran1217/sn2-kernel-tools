#!/bin/bash
set -e

# Directories
BASE_DIR=$(pwd)
BUILD_DIR="${BASE_DIR}/${1:-main}"  # Branch defaults to 'main' if not passed
TOOLS_DIR="${BASE_DIR}/tools"

SUMMARY_FILE="${BASE_DIR}/summary.md"
touch "${SUMMARY_FILE}"


# Prepare tools
cd "${TOOLS_DIR}"




CROSS_COMPILER_PATH="./gcc-14.2.0-nolibc/ia64-linux"
export PATH="$PATH:${PWD}/${CROSS_COMPILER_PATH}/bin"
CROSS_COMPILER=$(basename "${CROSS_COMPILER_PATH}/bin/ia64-linux-gcc")
CROSS_COMPILER_AND_VERSION=$(${CROSS_COMPILER} --version | head -n1)

# Exports
export BASE_DIR BUILD_DIR TOOLS_DIR 
export CROSS_COMPILER_AND_VERSION SUMMARY_FILE EXIT_EARLY=0

# Start build
cd "${BUILD_DIR}"
LAST_KERNEL_VERSION=$(cat "${BASE_DIR}${1:-main}-last-kernel-version" 2>/dev/null || true)
KERNEL_VERSION=$(git log --oneline | head -n1 | grep -o "Linux\ .*")

if [[ "${LAST_KERNEL_VERSION}" == "${KERNEL_VERSION}" ]]; then
    echo "Kernel is up to date. Exiting early."
    exit 0
fi

# Apply patches if available
USED_PATCHES="no extra patches needed"
if [[ -d "${TOOLS_DIR}/patches/${1:-main}" ]]; then
    USED_PATCHES="see [__mirror/patches/${1:-main}/](https://github.com/johnny-mnemonic/linux-stable-rc/tree/__mirror/patches/${1:-main}/)"
    for patch in "${TOOLS_DIR}/patches/${1:-main}"/*patch; do
        patch -p1 < "${patch}" || true
    done
fi

# Build kernel
cd "${TOOLS_DIR}"
echo "| STATUS | BRANCH | VERSION | TYPE | USED PATCHES | COMPILER | DOWNLOAD |" >> "${SUMMARY_FILE}"
echo "| ------ | ------ | ------- | ---- | ------------ | -------- | -------- |" >> "${SUMMARY_FILE}"

BUILD_COMMAND="time ./make-kernel.bash ../config/linux-for-hp-integrities-v7 ia64 ${BUILD_DIR} nate tar-pkg"
if ${BUILD_COMMAND}; then
    mkdir -p build-artifacts
    mv "$(cat ${BUILD_DIR}/LINUX_BUILD_LOG)" "$(cat ${BUILD_DIR}/LINUX_TARBALL)" build-artifacts/
    pushd build-artifacts/ > /dev/null
    sha256sum * > SHA256
    popd > /dev/null

    echo "| :white_check_mark: | ${1:-main} | ${KERNEL_VERSION} | regular | ${USED_PATCHES} | ${CROSS_COMPILER_AND_VERSION} |" >> "${SUMMARY_FILE}"
    echo "${KERNEL_VERSION}" > "${BASE_DIR}${1:-main}-last-kernel-version"
else
    echo "| :x: | ${1:-main} | ${KERNEL_VERSION} | regular | ${USED_PATCHES} | ${CROSS_COMPILER_AND_VERSION} |" >> "${SUMMARY_FILE}"
fi

echo "Build completed."
