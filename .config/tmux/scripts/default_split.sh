#!/bin/sh

width=$(tmux display -p "#{pane_width}"); 

if [ "$width" -gt 150 ]; then 
    size="$((width / 2 - 28))"
else
    size="$((width * 33 / 100))"
fi
tmux split-window -d -b -h -l $size
