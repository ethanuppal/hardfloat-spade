#!/bin/sh

# $(which pip3 || which pip) install "cocotb~=|1.8.1|"
brew update
brew install zig
brew install icarus-verilog
brew install verilator
cargo install --git https://gitlab.com/spade-lang/swim
