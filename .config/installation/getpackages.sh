#!/bin/sh

# Detect package manager and set commands
if command -v apt >/dev/null 2>&1; then
    PM="apt"
    UPDATE_CMD="sudo apt update"
    INSTALL_CMD="sudo apt install -y"
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
    UPDATE_CMD="sudo dnf check-update"
    INSTALL_CMD="sudo dnf install -y"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
    UPDATE_CMD="sudo yum check-update"
    INSTALL_CMD="sudo yum install -y"
elif command -v pacman >/dev/null 2>&1; then
    PM="pacman"
    UPDATE_CMD="sudo pacman -Syu"
    INSTALL_CMD="sudo pacman -S --noconfirm"
else
    echo "No supported package manager found (apt, dnf, yum, pacman)." >&2
    exit 1
fi

MAINPACKAGES="fish nvim gcc tmux curl tar wget" 
EXTRAPACKAGES="broot lsd bat ripgrep ripgrep-all sd sk git-delta"

# Update system package lists
$UPDATE_CMD

if [ "$PM" = "apt" ]; then
    # Install main packages
    $INSTALL_CMD $MAINPACKAGES
    # Install nvim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    fish -c 'fish_add_path /opt/nvim-linux-x86_64/bin/'
else
    # Install all packages
    $INSTALL_CMD $MAINPACKAGES
    $INSTALL_CMD $EXTRAPACKAGES
fi

fish -c 'set -U EDITOR nvim'

# Install julia
curl -fsSL https://install.julialang.org | sh
fish -c 'fish_add_path $HOME/.juliaup/bin'
fish -c 'julia -e '\''using Pkg; Pkg.add("VimBindings"); Pkg.add("Revise")'\'''
fish -c 'JULIA_PROJECT=$HOME/.julia/environments/lsp julia -e '\''using Pkg; Pkg.add("LanguageServer")'\'''

# Install rust 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fish -c 'fish_add_path $HOME/.cargo/bin'
