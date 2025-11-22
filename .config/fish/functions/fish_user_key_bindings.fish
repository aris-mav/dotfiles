function fish_user_key_bindings

    # Ctrl-Z to fg
    bind -Mdefault -Minsert \cZ 'fg 2>/dev/null ; commandline -f repaint ; fish_vi_key_bindings insert'

end
