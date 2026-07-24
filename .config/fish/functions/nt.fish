function nt

    if set -q NOTES_DIR
        if test (count $argv) -eq 0
            cd $NOTES_DIR
        else
            $NOTES_DIR/nt.sh $argv
        end
    else
        echo "NOTES_DIR is not set."
    end

end
