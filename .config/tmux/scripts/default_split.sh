#!/bin/sh

width=$(tmux display -p "#{pane_width}"); 

if [ "$width" -gt 150 ]; then 

    tmux split-window -d -b -h -l "$((width / 2 - 28))"

elif [ "$width" -gt 120 ]; then 

    tmux split-window -d -b -h -l "$((width * 33 / 100))"
fi
