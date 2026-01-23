if status is-interactive

    if not test "$TERM_PROGRAM" = "WezTerm"

        if type -q tmux 

            if not set -q TMUX

                if tmux has-session
                    exec tmux attach-session
                else
                    exec tmux new-session -s main -n home 
                end
            end
            if test (tmux display-message -p '#{window_panes}') -eq 1
                ~/.config/tmux/scripts/new_win_split.sh
            end

        else if type -q zellij

            set -gx ZELLIJ_AUTO_ATTACH true
            eval (zellij setup --generate-auto-start fish | string collect)

        end

    end
end
