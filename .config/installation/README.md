# dotfiles

To install, follow these steps:

(method taken from [this blog](https://drewdevault.com/2019/12/30/dotfiles.html))

1. Install git.
2. Make ssh key by running `ssh-keygen -t ed25519 -C "mail@example.com"`.
3. `cat ~/.ssh/id_ed25519.pub` and add the key to github.
4. Run these:
```
cd ~ 
git init
echo \* > .gitignore
git remote add origin git@github.com:aris-mav/dotfiles.git
git fetch
git checkout -f home
```
To addd a new file, `git add -f "filename"`.


# Nix config

On nixos, run `sudo nixos-rebuild switch -I nixos-config=$HOME/.installs/nixos/configuration.nix`.

# Non-nix config

Run the script `~/.config/installation/getpackages.sh`
