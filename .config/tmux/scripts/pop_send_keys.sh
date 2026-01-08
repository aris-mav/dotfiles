#!/bin/sh

# open popup, run command, send output to current pane
tmux display-popup -E "tmux send-keys -t $(tmux display -p "#P") ($1)"
