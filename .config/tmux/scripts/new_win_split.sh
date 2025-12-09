#!/bin/sh

tmux new-window 

width=$(tmux display -p "#{window_width}"); 

if [ "$width" -gt 150 ]; then 
    tmux split-window -h; 
    tmux resize-pane -x $((width / 2 + 25)); 
elif [ "$width" -gt 120 ]; then 
    tmux split-window -h; 
    tmux resize-pane -x $((width * 66 / 100)); 
fi
