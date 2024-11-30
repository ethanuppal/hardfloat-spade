#!/bin/sh

sudo apt update
sudo apt install gcc pkg-config python3-venv libssl-dev pipx iverilog
pipx install maturin==1.2.3
pipx ensurepath
sudo snap install zig --classic --beta
cargo install --git git@gitlab.com:spade-lang/swim.git
