# Run this script after doing arch-chroot into the root partition

# replace "password" with actual password before running
useradd -m -u 1000 -g users -s /bin/bash arismav
echo "arismav:password" | chpasswd

pacman -Syu --noconfirm
pacman -S --needed --noconfirm - < ./archpackages.txt

# Install Julia
curl -fsSL https://install.julialang.org | sh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

fish -c "fish_add_path /home/arismav/.juliaup/bin"
fish -c 'julia -e '\''using Pkg; Pkg.add("VimBindings"); Pkg.add("Revise")'\'''
fish -c "JULIA_PROJECT=/home/arismav/.julia/environments/lsp julia -e '\''using Pkg; Pkg.add("LanguageServer")'\''"
fish -c "fish_add_path /home/arismav/.cargo/bin"

# setup kanata
cargo install kanata --features cmd
groupadd uinput
sudo usermod -aG input arismav
sudo usermod -aG uinput arismav 
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' > /etc/udev/rules.d/99-input.rules
udevadm control --reload-rules && udevadm trigger
modprobe uinput
logintl enable-linger

# Install gnome 
pacman -S --noconfirm gnome gnome-tweaks

pystemctl enable gdm.service
systemctl enable bluetooth
systemctl enable NetworkManager.service

flatpak install vivaldi zotero sioyek

# SETUP BOOTLOADER after this
