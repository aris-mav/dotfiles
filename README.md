# dotfiles

These are simply managed by a good ol (not "bare") git repo, with `*` on `.gitignore`.

To install, follow these steps:

1. `cd ~ && git init`
2. `echo \* > .gitignore`
3. `git add remote origin git@github.com:aris-mav/dotfiles.git`
4. `git fetch && git merge`

To addd a new file, `git add -f "filename"`.

On nixos, run `sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/configuration.nix`.
