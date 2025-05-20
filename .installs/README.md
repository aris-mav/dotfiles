# dotfiles

To install, follow these steps:

1. Install git.
2. Make ssh key by running `ssh-keygen -t ed25519 -C "mail@example.com"`.
3. `cat ~/.ssh/id_ed25519.pub` and add the key to github.
4. Run these:
```
cd ~ 
git init
echo \* > .gitignore
git remote add origin git@github.com:aris-mav/dotfiles.git
git checkout -t origin/master
git fetch
git merge
```

To addd a new file, `git add -f "filename"`.

On nixos, run `sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/configuration.nix`.
