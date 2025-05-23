# Define abbreviations

# general stuff
abbr e "$EDITOR"
abbr f 'br'
abbr y 'wl-copy'
abbr xo 'xdg-open'

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

# nix stuff
# abbr rb 'sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/configuration.nix'
# abbr ns 'nix-shell --command fish -p '

# Define some software preferences
for candidate in nvim hx vim vi
    if type -q $candidate
        set -gx EDITOR $candidate
        break
    end
end

# Fuzzyfind stuff
for candidate in sk fzf
    if type -q $candidate
        set -gx FUZZYFIND $candidate
        break
    end
end
if set -q FUZZYFIND

    abbr fp "$FUZZYFIND --preview='less {}'"
    abbr gaf "git add (git diff --name-only | $FUZZYFIND --preview='less {}')"

    if test $FUZZYFIND = sk
        abbr -a skr 'echo (string split -m 1 : (sk --ansi -i -c \'rg -i --color=always --line-number "{}"\'))[1]'
    end 

end


# For interactive sessions
if status is-interactive

    # vi mode settings
    fish_vi_key_bindings
    set fish_cursor_default     block      
    set fish_cursor_insert      line       blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual      block

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
    set fish_color_user yellow
    set fish_color_host cyan
    set fish_color_cwd  blue

    if type -q lsd
        function ls
            lsd $argv
        end
    end

end

