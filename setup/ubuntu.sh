#!/bin/sh

sudo apt-get update
sudo apt-get install gcc pkg-config python3-venv libssl-dev pipx iverilog
pipx install maturin==1.2.3
pipx ensurepath
sudo snap install zig --classic --beta
