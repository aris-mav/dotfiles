function nt

    if test (count $argv) -eq 0
        $NOTES_DIR/nt.sh no_args
        cd $NOTES_DIR
    else 
        $NOTES_DIR/nt.sh $argv
    end    

end
