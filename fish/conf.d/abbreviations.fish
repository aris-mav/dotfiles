abbr --set-cursor=% gc "git commit -m '%'"
abbr gC 'git checkout'
abbr gr 'git restore'
abbr gR 'git reset'
abbr gf 'git fetch'
abbr ga 'git add'
abbr gd 'git diff'
abbr gs 'git status'
abbr gS 'git stash'
abbr gp 'git pull'
abbr gP 'git push'
abbr gb 'git branch'
abbr gl 'git log'
abbr gm 'git merge'
abbr grb 'git rebase'
abbr gcp 'git cherry-pick'
abbr gau 'git add -u'
abbr gac 'git commit -a'
abbr gacp 'git commit -a ; git push'
abbr e "$EDITOR"
abbr f "$FILE_BROWSER"
abbr --set-cursor=% n "nt -%"

if type -q pacman
    abbr pa 'sudo pacman'
else if type -q apt
    abbr pa 'sudo apt'
else if type -q nix
    abbr rb 'sudo nixos-rebuild switch \
        -I nixos-config=~/.config/nixos/configuration.nix'
    abbr ns 'nix-shell --command fish -p '
end
