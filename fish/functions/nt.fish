function nt

    if set -q NOTES_DIR
        if test (count $argv) -eq 0
            $NOTES_DIR/.scripts/nt.sh
            cd $NOTES_DIR
        else
            $NOTES_DIR/.scripts/nt.sh $argv
        end
    else
        echo "NOTES_DIR is not set."
    end

end
