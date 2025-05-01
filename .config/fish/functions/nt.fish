function nt
    cd ~/Documents/notes

    set datetime (date +%Y%m%d%H%M%S)

    # git pull, only if you haven't pulled already, or if the last pull was more than 1h ago.
    if not set -q PREV_PULL || test (math $datetime - $PREV_PULL) -gt 10000
        git pull
        set -gx PREV_PULL $datetime
    end
    set committed_anything false

    # create note in editor
    set newnote "$datetime.md"
    $EDITOR $newnote

    # if the new file was saved, commit it
    if test -f $newnote 
        set first_line (head -n 1 $newnote)
        git add $newnote
        git commit -m "new note $first_line"
        set committed_anything true
    end

    # check if any of the tracked files was edited, commit changes
    for file in (git diff --name-only)
        if test -f "$file"
            switch $file
                case 'TODO.md'
                    set commit_msg "Update TODO list"
                case 'books_finished.csv'
                    set commit_msg "Log finished books"
                case '*'
                    set first_line (head -n 1 $file)
                    set commit_msg "edits on $first_line"
            end

            git add "$file"
            git commit -m "$commit_msg"
            set committed_anything true
        end
    end

    # push changes, if there are any
    if test "$committed_anything" = true
        git push
    end

    # return to your previous dir
    cd -
end
