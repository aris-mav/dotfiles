if status is-interactive
    # Commands to run in interactive sessions can go here
      fish_vi_key_bindings
end

# Set the cursor shapes for the different vi modes.
set fish_cursor_default     block      
set fish_cursor_insert      line       blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual      bloch

# Define abbreviations
abbr e '$EDITOR'
abbr jl 'julia -t auto'
abbr z 'zellij'
abbr gC 'git commit'
abbr gc 'git checkout'
abbr gf 'git fetch'
abbr ga 'git add'
abbr gd 'git diff'
abbr gs 'git status'
abbr gp 'git pull'
abbr gP 'git push'
abbr gb 'git branch'
abbr gacp 'git add . ; git commit ; git push '
abbr fp '$FUZZYFIND --preview="less {}"'
