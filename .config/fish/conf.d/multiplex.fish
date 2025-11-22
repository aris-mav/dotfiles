if status is-interactive

    if not test "$TERM_PROGRAM" = "WezTerm"

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

    end
end
