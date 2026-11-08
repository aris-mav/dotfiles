#! /bin/sh

current=$(gsettings get org.gnome.desktop.interface color-scheme)

if echo "$current" | grep -q dark; then
    scheme=prefer-light
    bg='#eff1f5'
    bg=$(awk '$1 == "background" { print $2; exit }' \
         ~/.config/kitty/light-theme.auto.conf)
else
    scheme=prefer-dark
    bg=$(awk '$1 == "background" { print $2; exit }' \
         ~/.config/kitty/dark-theme.auto.conf)
fi

sed -i -E "s/^(\s*background-color )\"[^\"]*\"/\1\"$bg\"/" \
    ~/.config/niri/config.kdl

gsettings set org.gnome.desktop.interface color-scheme "$scheme"
