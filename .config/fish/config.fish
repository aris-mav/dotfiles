if status is-interactive
    # Commands to run in interactive sessions can go here
      fish_vi_key_bindings
end

# Set the cursor shapes for the different vi modes.
set fish_cursor_default     block      blink
set fish_cursor_insert      line       blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual      bloch
function fish_mode_prompt; end
