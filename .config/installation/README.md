# dotfiles

To install, follow these steps:

(method taken from [this blog](https://www.atlassian.com/git/tutorials/dotfiles))

1. Install git.
2. Make ssh key by running `ssh-keygen -t ed25519 -C "mail@example.com"`.
3. `cat ~/.ssh/id_ed25519.pub` and add the key to github.
4. Run these:
```
cd ~ 

# 1. Clone the bare repo
git clone --bare https://github.com/aris-mav/dotfiles.git $HOME/.dotfiles.git

# 2. Define the alias (temporary for this shell)
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'

# 3. Checkout the home branch into $HOME
dotfiles checkout home

# 4. Hide untracked files
dotfiles config --local status.showUntrackedFiles no
```

# Nix config

On nixos, run `sudo nixos-rebuild switch -I nixos-config=$HOME/.installs/nixos/configuration.nix`.

