    abbr gC 'git commit'
    abbr gc 'git checkout'
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
    abbr gacp 'git add -u ; git commit ; git push '

    if set -q FUZZYFIND

        abbr gaf "git add (git diff --name-only \
        | $FUZZYFIND --multi --preview 'git diff --color=always {}')"

        abbr grf "git reset (git diff --name-only --cached \
        | $FUZZYFIND --multi --preview 'git diff --color=always --cached {}')"

        abbr gdf "git diff --name-only \
        | $FUZZYFIND --multi --preview 'git diff --color=always {}'"

        abbr cdp "cd (tmux list-panes -a -F '#{pane_current_path}' | $FUZZYFIND)"

    end

    abbr e "$EDITOR"
    abbr f "$FILE_BROWSER"
    abbr y "$YANKTEXT"
    abbr xo 'xdg-open'
    abbr x 'xargs'

    abbr nn "nt -n"
    abbr ns "nt -s"

    if type -q pacman
        abbr pa 'sudo pacman'
    else if type -q apt
        abbr pa 'sudo apt'
    else if type -q nix
        abbr rb 'sudo nixos-rebuild switch \
        -I nixos-config=~/.config/nixos/configuration.nix'
        abbr ns 'nix-shell --command fish -p '
    end

