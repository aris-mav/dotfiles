#!/bin/sh

current=$(gsettings get org.gnome.desktop.interface color-scheme)

case $current in
    *light*) mode=dark ;;
    *)       mode=light ;;
esac

bg=$(
    awk '$1 == "background" { print $2; exit }' \
    "$HOME/.config/kitty/$mode-theme.auto.conf"
)

sed -i -E "/^include.*themes/s|[^/[:space:]]+\$|$mode|" \
    "$HOME/.config/zathura/zathurarc"

if [ -n "$bg" ]; then
    sed -i -E "s/^([[:space:]]*background-color )\"[^\"]*\"/\1\"$bg\"/" \
        "$HOME/.config/niri/config.kdl"
fi

gsettings set org.gnome.desktop.interface color-scheme "prefer-$mode"