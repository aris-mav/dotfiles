pacman -Syu --noconfirm
pacman -S --needed --noconfirm - < ./archpackages.txt

# Install Julia
curl -fsSL https://install.julialang.org | sh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Add paths to fish for the above
# fish -c "fish_add_path $HOME/.juliaup/bin"
# fish -c 'julia -e '\''using Pkg; Pkg.add("VimBindings"); Pkg.add("Revise")'\'''
# fish -c "JULIA_PROJECT=$HOME/.julia/environments/lsp julia -e '\''using Pkg; Pkg.add("LanguageServer")'\''"
# fish -c "fish_add_path $HOME/.cargo/bin"

# cargo install kanata --features cmd

systemctl enable bluetooth
systemctl enable NetworkManager.service

useradd -m -u 1000 -g users -s /bin/bash arismav
# replace "password" with actual password before running
echo "arismav:password" | chpasswd

# Install gnome 
pacman -S --noconfirmg nome gnome-tweaks
systemctl enable gdm.service
