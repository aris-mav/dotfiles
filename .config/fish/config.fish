# For interactive sessions:
if status is-interactive

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
    abbr grb 'git rebase'
    abbr gacp 'git add . ; git commit ; git push '

    # general stuff
    abbr e "$EDITOR"
    abbr f "$FILE_BROWSER"
    abbr xo 'xdg-open'
    abbr x 'xargs'

    if test "$XDG_SESSION_TYPE" = "wayland"
        abbr y 'wl-copy -n'
    else 
        abbr y 'xclip'
    end

    if type -q nix
        abbr rb 'sudo nixos-rebuild switch -I nixos-config=~/.config/nixos/configuration.nix'
        abbr ns 'nix-shell --command fish -p '
    end

    if set -q FUZZYFIND

        abbr fp "$FUZZYFIND --preview='less {}'"
        abbr gaf "git add (git diff --name-only | $FUZZYFIND --preview='less {}')"

        if test $FUZZYFIND = sk
            abbr -a skr 'echo (string split -m 1 : (sk --ansi -i -c \'rg -i --color=always --line-number "{}"\'))[1]'
        end 

    end

    # vi mode settings
    fish_vi_key_bindings
    set fish_cursor_default     block      
    set fish_cursor_insert      line       blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual      block

    # open tmux automatically
    if type -q tmux 

        if not set -q TMUX
            if tmux has-session -t main
                exec tmux attach-session -t main
            else
                set -l term_width (tput cols)
                if test $term_width -gt 150 # If screen is wide, split it
                    exec tmux new-session -s main -n home \; split-window -h \; resize-pane -x (math -s0 $term_width/2 + 25)
                else if test $term_width -gt 120 
                    exec tmux new-session -s main -n home \; split-window -h \; resize-pane -x 66%
                else
                    exec tmux new-session -s main -n home 
                end
            end
        end

    else if type -q zellij

        set -gx ZELLIJ_AUTO_ATTACH true
        eval (zellij setup --generate-auto-start fish | string collect)

    end

    # Cosmetic stuff
    set fish_greeting # disables the greeting

    if type -q lsd
        function ls
            lsd $argv
        end
    end

end
