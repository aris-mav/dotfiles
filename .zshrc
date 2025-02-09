# PROMPT='%~%# '
PS1='%F{cyan}%n@%m %F{yellow}%~ %F{reset}%# '

export EDITOR="nvim"

export PATH="/home/arismav/.local/bin":$PATH
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export HELIX_RUNTIME=~/software/helix/runtime

# export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# Aliases

alias e='$EDITOR'
alias f='pipx run --spec ranger-fm ranger'
alias td='e ~/TODO.md'

alias gc='git commit'
alias gf='git fetch'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git pull'
alias gP='git push'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias tree='tree -C'

note() {
  cd ~/Documents/notes || return
  filename=$(date +"%Y%m%d%H%M%S.md")
  nvim "$filename"
}

gacp() {
    git add .
    git commit
    git push
}

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[0 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Automatic stuff below this line

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/arismav/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

unsetopt beep

bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/arismav/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
