# Dotfiles

These are managed by a normal (not "bare") git repo, with * on `gitignore`.

To install these:

1. ` cd ~ && git init`.
2. ` echo \* > .gitignore `
3. ` git add remote origin git@github.com:aris-mav/dotfiles.git `
4. ` git fetch `
5. ` git merge `

On nixos, run `sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/configuration.nix`.
