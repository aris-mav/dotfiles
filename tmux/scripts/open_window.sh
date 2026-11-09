#!/bin/sh

# run "command" in "window_name"
# if "window" exists, just go there
# -c makes repeated calls cycle betwen target window and previous window
# use as : #0 window command_name
# or as  : #0 -c window command_name

if [ "$1" = "-c" ]; then
    mode="cycle"
    shift
fi

WIN="$1"
CMD="$2"

if [ -z "$WIN" ]; then
    echo "Usage: $0 <window-name> <command>"
    exit 1
fi

case "$WIN" in
    [0-9])
        current_win=$(tmux display -p "#W")
        if [ "$current_win" = "$WIN" ]; then
            # go to previous window
            [ "$mode" = "cycle" ] && tmux select-window -l 
        else
            # go to chosen window
            tmux select-window -t :"$WIN" || \
                tmux display-message "Can't find window: $WIN"
        fi
        exit 0
        ;;

    *) 
        # Check if the window exists
        if tmux list-windows -F '#W' | grep -qx "$WIN"; then
            current_win=$(tmux display -p "#W")
            if [ "$current_win" = "$WIN" ]; then
                [ "$mode" = "cycle" ] && tmux select-window -l 
            else
                tmux select-window -t :"$WIN"
            fi
            exit 0
        else 
            # if the window does not already exist
            if [ -z "$CMD" ]; then
                tmux new-window -n "$WIN"
            else
                tmux new-window -n "$WIN" "$CMD"
            fi
            exit 0
        fi
        ;;
esac
