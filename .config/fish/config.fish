# For interactive sessions:
if status is-interactive

    # vi mode settings
    fish_vi_key_bindings
    set fish_cursor_default     block      
    set fish_cursor_insert      line       blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual      block

    # disables the greeting
    set fish_greeting 

end
