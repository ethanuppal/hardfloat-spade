#!/bin/bash

#
# CREDITS:
# https://raw.githubusercontent.com/calyxir/calyx/86434a53fbba47b5525c91ad8d0316b0d71dd1b9/primitives/float/get_hardfloat.sh
#

HARDFLOAT_DIR="src/hardfloat/"
HARDFLOAT_URL="https://github.com/ethanuppal/berkeley-hardfloat/archive/refs/heads/main.zip"
ZIP_FILE="main.zip"

rm -rf "${HARDFLOAT_DIR}"
mkdir -p "${HARDFLOAT_DIR}"

curl -LO "${HARDFLOAT_URL}"

if [ -f "$ZIP_FILE" ]; then
    TEMP_DIR=$(mktemp -d)

    unzip "$ZIP_FILE" -d "$TEMP_DIR"

    mv "$TEMP_DIR/berkeley-hardfloat-main/extract"/* "${HARDFLOAT_DIR}"

    rm -rf "$TEMP_DIR"
    rm "$ZIP_FILE"

    echo "HardFloat library source files fetched and extracted to ${HARDFLOAT_DIR}"
else
    echo "Failed to download HardFloat library from ${HARDFLOAT_URL}"
    exit 1
fi

echo "Copyright 2019 The Regents of the University of California. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the University nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS “AS IS”, AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE." >"$HARDFLOAT_DIR/LICENSE"
