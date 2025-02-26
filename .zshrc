HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

unsetopt beep

# PROMPT='%~%# '
PS1='%F{cyan}%n@%m %F{yellow}%~ %F{reset}%# '

export EDITOR="nvim"
export FUZZYFIND="sk"

export PATH="/home/arismav/.local/bin":$PATH
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export HELIX_RUNTIME=~/software/helix/runtime

# export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# Aliases

alias e='$EDITOR'
alias f='pipx run --spec ranger-fm ranger'
alias jl='julia -t auto'
alias hm='cd ~'
alias z='zellij'

alias gc='git commit'
alias gf='git fetch'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git pull'
alias gP='git push'

if type lsd > /dev/null; then
    alias ls='lsd'
else
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias tree='tree -C'

alias nt='$EDITOR ~/Documents/notes/$(date +"%Y%m%d%H%M%S.md")'
alias td='$EDITOR ~/Documents/notes/TODO.md'

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

source /home/arismav/.config/broot/launcher/bash/br
