function git
    # If we're in $HOME
    if test (pwd) = $HOME
        # Use your bare dotfiles repo
        command git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME $argv
    else
        # Normal git behavior elsewhere
        command git $argv
    end
end
