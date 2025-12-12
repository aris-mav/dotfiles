function nt

    if test (count $argv) -eq 0
        ~/.config/scripts/nt.sh no_args
        cd $NOTES_DIR
    else 
        ~/.config/scripts/nt.sh $argv
    end    

end
