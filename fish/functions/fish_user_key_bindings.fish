function fish_user_key_bindings

    # Ctrl-Z to fg
    bind -Minsert \cZ 'fg 2>/dev/null ; commandline -f repaint ; fish_vi_key_bindings insert'
    bind -Mdefault \cZ 'fg 2>/dev/null ; commandline -f repaint ; fish_vi_key_bindings default'

    # Ctrl-f to file browser
    bind -Minsert \cF "$FILE_BROWSER ; commandline -f repaint ; fish_vi_key_bindings insert"
    bind -Mdefault \cF "$FILE_BROWSER ; commandline -f repaint ; fish_vi_key_bindings default"

end
