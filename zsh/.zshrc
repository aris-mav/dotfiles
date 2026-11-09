HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

unsetopt beep

# PROMPT='%~%# '
PS1='%F{cyan}%n@%m %F{yellow}%~ %F{reset}%# '

export EDITOR="nvim"
export FUZZYFIND="sk"

export PATH="$PATH:/home/arismav/.local/bin"
export PATH="$PATH:/home/arismav/.scripts"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export HELIX_RUNTIME=~/software/helix/runtime

if [[ "$PREFIX" == *"com.termux"* ]]; then
    export PATH="$PATH:/data/data/com.termux/files/home/.cargo/bin"
else
    # export PATH="$HOME/.cargo/bin:$PATH"
    . "$HOME/.cargo/env"
fi 

# Aliases

alias e='$EDITOR'
alias jl='julia -t auto'
alias z='zellij'

alias gC='git commit'
alias gc='git checkout'
alias gf='git fetch'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git pull'
alias gP='git push'
alias gb='git branch'

if type lsd > /dev/null; then
    alias ls='lsd'
else
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias tree='tree -C'

nt() {
    cd ~/Documents/notes

    if [ -z "$NT_PULLED" ]; then
        git pull
        export NT_PULLED="yes"
    fi
    local committed_anything=false

    newnote=$(date +"%Y%m%d%H%M%S.md")
    $EDITOR $newnote

    if [ -f $newnote ]; then
        first_line=$(head -n 1 "$newnote")
        git add $newnote
        git commit -m "new note $first_line"
        local committed_anything=true
    fi

    for file in ${(f)"$(git diff --name-only)"}; do
        # following if excludes deleted files
        if [ -f "$file" ]; then

            case "$file" in
                TODO.md)
                    commit_msg="Update TODO list"
                    ;;
                books_finished.csv)
                    commit_msg="Log finished books"
                    ;;
                *)
                    first_line=$(head -n 1 "$file")
                    commit_msg="edits on $first_line"
                    ;;
            esac

            git add  "$file"
            git commit -m "$commit_msg"
            local committed_anything=true
        fi
    done

    if $committed_anything; then
        git push
    fi

    cd $OLDPWD
}

alias ze='zellij edit -x 30% --width 70% -y 3% --height 97% -f'

jf() {fg %$(jobs | $FUZZYFIND | sed -E 's/^\[([0-9]+).*/\1/') }

fp() {$FUZZYFIND --preview='less {}'}

gacP() {
    git add .
    git commit
    git push
}

# vi mode
bindkey -v
setopt vi
KEYTIMEOUT=1

# change cursor shape in vi mode
zle-keymap-select () {
    if [[ $KEYMAP == vicmd ]]; then
        # the command mode for vi
        echo -ne "\e[2 q"
    else
        # the insert mode for vi
        echo -ne "\e[5 q"
    fi
}
precmd_functions+=(zle-keymap-select)
zle -N zle-keymap-select


# Automatic stuff below this line

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/arismav/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<


# The following lines were added by compinstall
zstyle :compinstall filename '/home/arismav/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(zellij setup --generate-auto-start zsh)"

if [[ "$PREFIX" == *"com.termux"* ]]; then
    source /data/data/com.termux/files/home/.config/broot/launcher/bash/br
else
    source /home/arismav/.config/broot/launcher/bash/br
fi 

source /home/arismav/.config/broot/launcher/bash/br
