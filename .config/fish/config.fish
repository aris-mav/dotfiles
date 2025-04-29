# Set up PATH entries
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.scripts
fish_add_path $HOME/.juliaup/bin/
fish_add_path /opt/nvim-linux-x86_64/bin

if string match -q '*com.termux*' "$PREFIX"
    fish_add_path /data/data/com.termux/files/home/.cargo/bin
else
    fish_add_path $HOME/.cargo/bin
end

set -gx HELIX_RUNTIME ~/software/helix/runtime

# Define abbreviations
abbr e '$EDITOR'
abbr jl 'julia -t auto'
abbr z 'zellij'
abbr gC 'git commit'
abbr gc 'git checkout'
abbr gr 'git restore'
abbr gR 'git reset'
abbr gf 'git fetch'
abbr ga 'git add'
abbr gd 'git diff'
abbr gs 'git status'
abbr gp 'git pull'
abbr gP 'git push'
abbr gb 'git branch'
abbr gacp 'git add . ; git commit ; git push '
abbr fp '$FUZZYFIND --preview="less {}"'

# Define some software preferences
for candidate in nvim hx vim vi
    if type -q $candidate
        set -gx EDITOR $candidate
        break
    end
end

for candidate in sk fzf
    if type -q $candidate
        set -gx FUZZYFIND $candidate
        break
    end
end

# For interactive sessions
if status is-interactive

    # vi mode settings
    fish_vi_key_bindings
    set fish_cursor_default     block      
    set fish_cursor_insert      line       blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual      bloch

    # zellij auto-start
    if type -q zellij
        set -gx ZELLIJ_AUTO_ATTACH true
        eval (zellij setup --generate-auto-start fish | string collect)
    end

end

