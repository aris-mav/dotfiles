#!/bin/sh

WIN="$1"
CMD="$2"

if [ -z "$WIN" ] || [ -z "$CMD" ]; then
    echo "Usage: $0 <window-name> <command>"
    exit 1
fi

# Check if the window exists
if tmux list-windows -F '#W' | grep -qx "$WIN"; then

    current_win=$(tmux display -p "#W")
    if [ $current_win = $WIN ] ; then
        tmux select-window -l
    else
        tmux select-window -t :"$WIN"
    fi

else
    tmux new-window -n "$WIN" "$CMD"
fi
