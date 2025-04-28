function nt
    cd ~/Documents/notes

    if not set -q NT_PULLED
        git pull
        set -gx NT_PULLED true
    end

    set committed_anything false

    set newnote (date "+%Y%m%d%H%M%S.md")
    $EDITOR $newnote

    if test -f $newnote
        set first_line (head -n 1 $newnote)
        git add $newnote
        git commit -m "new note $first_line"
        set committed_anything true
    end

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

    if test "$committed_anything" = true
        git push
    end

    cd -
end
