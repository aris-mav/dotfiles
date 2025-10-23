function git
    # If we're in $HOME
    if test (pwd) = $HOME
        # Use your bare dotfiles repo
        echo "Using dotfiles bare repo fish function instead of normal git command."
        command git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME $argv
    else
        # Normal git behavior elsewhere
        command git $argv
    end
end
