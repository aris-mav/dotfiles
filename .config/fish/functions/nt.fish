function nt

    if test (count $argv) -eq 0
        cd $NOTES_DIR
    else 
        ~/.config/scripts/nt.sh $argv
    end    

end
