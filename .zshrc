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
alias hm='cd ~'
alias z='zellij'
alias h='cd ~'

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

    if [ "$NT_PULLED" = "yes" ] ; then
        git pull
        export NT_PULLED="yes"
    fi
    $EDITOR $(date +"%Y%m%d%H%M%S.md")
    git commit -am "."
    git push
}

td() {
    cd ~/Documents/notes
    $EDITOR TODO.md
}


alias ze='zellij edit -x 30% --width 70% -y 3% --height 97% -f'

jf() {fg %$(jobs | $FUZZYFIND | sed -E 's/^\[([0-9]+).*/\1/') }

fp() {$FUZZYFIND --preview='less {}'}

gacP() {

    target_folder="$1" 

    if [ -z "$target_folder" ]; then
        echo "Please provide a target folder as argument."
        return 1
    fi

    git -C "$target_folder" add .
    git -C "$target_folder" commit
    git -C "$target_folder" push
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

if [[ "$PREFIX" == *"com.termux"* ]]; then
    source /data/data/com.termux/files/home/.config/broot/launcher/bash/br
else
    source /home/arismav/.config/broot/launcher/bash/br
fi 

eval "$(zellij setup --generate-auto-start zsh)"
