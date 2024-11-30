#!/bin/bash

#
# CREDITS:
# https://raw.githubusercontent.com/calyxir/calyx/86434a53fbba47b5525c91ad8d0316b0d71dd1b9/primitives/float/get_hardfloat.sh
#

PATCHES_VERSION="0.1.0"
HARDFLOAT_DIR="src/hardfloat/"
HARDFLOAT_URL="https://github.com/ethanuppal/berkeley-hardfloat/archive/refs/tags/v$PATCHES_VERSION.zip"
ZIP_FILE="v$PATCHES_VERSION.zip"
ZIP_SUBFOLDER="berkeley-hardfloat-$PATCHES_VERSION/extract"

rm -rf "${HARDFLOAT_DIR}"
mkdir -p "${HARDFLOAT_DIR}"

curl -LO "${HARDFLOAT_URL}"

if [ -f "$ZIP_FILE" ]; then
    TEMP_DIR=$(mktemp -d)

    unzip "$ZIP_FILE" -d "$TEMP_DIR"

    mv "$TEMP_DIR/$ZIP_SUBFOLDER"/* "${HARDFLOAT_DIR}"

    rm -rf "$TEMP_DIR"
    rm "$ZIP_FILE"

    echo "HardFloat library source files fetched and extracted to ${HARDFLOAT_DIR}"
else
    echo "Failed to download HardFloat library from ${HARDFLOAT_URL}"
    exit 1
fi
