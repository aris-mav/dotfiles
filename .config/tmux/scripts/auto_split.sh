#!/bin/sh

tmux_info=$(
    tmux display-message -p \
        "#{window_panes} #{pane_width} #{pane_height} #{pane_current_path}"
)

read -r panes width height path << EOF
$tmux_info
EOF

if [ "$panes" -eq 1 ]; then

    if [ "$width" -gt 150 ]; then 
        tmux split-window -b -d -h; 
        tmux resize-pane -x $((width / 2 + 28)); 
    elif [ "$width" -gt 120 ]; then 
        tmux split-window -b -d -h; 
        tmux resize-pane -x $((width * 66 / 100)); 
    fi

elif [ "$width" -gt "$((height * 2))" ]; then
    tmux split-window -h -c "$path"
else
    tmux split-window -v -c "$path"
fi
