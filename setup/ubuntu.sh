#!/bin/sh

sudo apt-get update
sudo apt-get install gcc pkg-config python3-venv libssl-dev pipx iverilog # verilator=4.106
pipx install maturin==1.2.3
pipx ensurepath
sudo snap install zig --classic --beta
