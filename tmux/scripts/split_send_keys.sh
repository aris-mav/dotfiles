#!/bin/sh

tmux split-window " tmux send-keys -t $(tmux display -p "#P") ($1)"
