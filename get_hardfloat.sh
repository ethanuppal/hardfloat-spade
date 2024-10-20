#!/bin/bash

#
# CREDITS:
# https://raw.githubusercontent.com/calyxir/calyx/86434a53fbba47b5525c91ad8d0316b0d71dd1b9/primitives/float/get_hardfloat.sh
#

HARDFLOAT_DIR="src/hardfloat/"
HARDFLOAT_URL="http://www.jhauser.us/arithmetic/HardFloat-1.zip"
ZIP_FILE="HardFloat-1.zip"

rm -rf "${HARDFLOAT_DIR}"
mkdir -p "${HARDFLOAT_DIR}"

curl -LO "${HARDFLOAT_URL}"

if [ -f "$ZIP_FILE" ]; then
    TEMP_DIR=$(mktemp -d)

    unzip "$ZIP_FILE" -d "$TEMP_DIR"

    mv "$TEMP_DIR/HardFloat-1/source"/* "${HARDFLOAT_DIR}"

    rm -rf "$TEMP_DIR"
    rm "$ZIP_FILE"

    echo "HardFloat library source files fetched and extracted to ${HARDFLOAT_DIR}"
else
    echo "Failed to download HardFloat library from ${HARDFLOAT_URL}"
fi
