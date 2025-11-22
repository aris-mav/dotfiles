# dotfiles

(method taken from [this blog](https://www.atlassian.com/git/tutorials/dotfiles))

1. Install git.
2. Make ssh key by running `ssh-keygen -t ed25519 -C "mail@example.com"`.
3. `cat ~/.ssh/id_ed25519.pub`, and add the key to GitHub.
4. `cd ~` 
5. `git clone --bare git@github.com:aris-mav/dotfiles.git `
6. `alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME' `
7. `dotfiles checkout home`
8. `dotfiles config --local status.showUntrackedFiles no`

If there is a file which you want to keep in the 
repo but stop tracking, use
`git update-index --skip-worktree <file>`
and restore by
`git update-index --no-skip-worktree <file>`.


# Nix config

On nixos, run `sudo nixos-rebuild switch -I nixos-config=$HOME/.installs/nixos/configuration.nix`.
