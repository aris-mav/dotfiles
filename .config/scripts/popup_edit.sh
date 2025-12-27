#!/bin/sh

wtype -M ctrl -k a -m ctrl
sleep 0.05
wtype -M ctrl -k x -m ctrl

tmpfile=$(mktemp /tmp/nvim.popup.XXXXXX)
trap 'rm -f "$tmpfile"' EXIT

wl-paste -n > "$tmpfile"

alacritty \
  --config-file "$HOME/.config/alacritty/alacritty_minimal.toml" \
  -e nvim -n "$tmpfile"

wl-copy -n < "$tmpfile"
sleep 0.05
wtype -M ctrl -k v -m ctrl
