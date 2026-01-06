    # git stuff
    abbr gC 'git commit'
    abbr gc 'git checkout'
    abbr gr 'git restore'
    abbr gR 'git reset'
    abbr gf 'git fetch'
    abbr ga 'git add'
    abbr gd 'git diff'
    abbr gs 'git status'
    abbr gp 'git pull'
    abbr gP 'git push'
    abbr gb 'git branch'
    abbr gl 'git log'
    abbr grb 'git rebase'
    abbr gacp 'git add -u ; git commit ; git push '

    abbr gx 'git annex'

    # general stuff
    abbr e "$EDITOR"
    abbr f "$FILE_BROWSER"
    abbr y "$YANKTEXT"
    abbr xo 'xdg-open'
    abbr x 'xargs'


    if type -q nix
        abbr rb 'sudo nixos-rebuild switch -I nixos-config=~/.config/nixos/configuration.nix'
        abbr ns 'nix-shell --command fish -p '
    end

    if type -q pacman
        abbr pa 'sudo pacman'
    end

    if set -q FUZZYFIND

        abbr fp "$FUZZYFIND --preview='less {}'"
        abbr gaf "git add (git diff --name-only | $FUZZYFIND --preview='less {}')"

        if test "$FUZZYFIND" = "sk"
            abbr -a skr 'echo (string split -m 1 : (sk --ansi -i -c \'rg -i --color=always --line-number "{}"\'))[1]'
        end 

    end
