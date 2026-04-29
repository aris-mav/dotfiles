#!/bin/sh

info=$(
    tmux display-message -p \
        "#{window_panes} #{pane_width} #{pane_height} #{pane_current_path}"
    )

# shellcheck disable=SC2086
set -- $info

panes=$1
width=$2
height=$3
path=$4

if [ "$panes" -eq 1 ] && [ "$width" -gt 120 ]; then

    if [ "$width" -gt 150 ]; then 
        size="$((width / 2 - 28))"
    else
        size="$((width * 33 / 100))"
    fi
    tmux split-window -d -b -h -l $size -c "$path"

elif [ "$width" -gt 80 ] && [ "$height" -gt 30 ]; then

    tmux split-window -v -c "$path" -l "$((height * 33 / 100))"

elif [ "$width" -ge 30 ] && [ "$height" -ge 10 ]; then

    [ "$((width / height))" -gt 3 ] \
        && split_type="-h" \
        || split_type="-v"

    tmux split-window "$split_type" -c "$path"
fi
