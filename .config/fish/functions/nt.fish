function nt

    argparse 't/todo' 'b/bookread' 'B/booktoread' 's/search' 'n/new' 'r/random' -- $argv
    or return

    if set -q NOTES_DIR
        cd $NOTES_DIR
    else
        echo "Environment variable 'NOTES_DIR' is not set."
        echo "Use 'set -Ux NOTES_DIR path/to/notes'."
        return
    end

    set datetime (date +%Y%m%d%H%M%S)
    set committed_anything false

    # check for zotero updates, commit them
    if not git diff --quiet zotero_library.bib
        git add zotero_library.bib
        git commit -m "zotero updates"
        set committed_anything true
    end

    # git pull, only if you haven't pulled already, 
    # or if the last pull was more than 1h ago.
    if not set -q PREV_PULL || test (math $datetime - $PREV_PULL) -gt 10000
        git pull
        set -gx PREV_PULL $datetime
    end

    # Do something, according to the used flag
    if set -ql _flag_new

        set newnote "$datetime.md"
        $EDITOR "$newnote"

        # if the new file was created, commit it
        if test -f $newnote 
            set first_line (head -n 1 $newnote)
            git add $newnote
            git commit -m "new note $first_line"
            set committed_anything true
        end

    else if set -ql _flag_search

        if test "$FILE_BROWSER" = "br"
            br -HI --cmd cr/ .
        else if test "$EDITOR" = "nvim"
            nvim -c "Telescope live_grep"
        else 
            $FILE_BROWSER
        end

    else if set -ql _flag_todo

        $EDITOR TODO.md

    else if set -ql _flag_b

        set -l dt (date +%Y/%m/%d)
        echo $dt >> books_finished.tsv

        $EDITOR + books_finished.tsv

        # if you only add the date but no other details, abort
        if test (tail -n 1 books_finished.tsv) = $dt
            git restore books_finished.tsv
        end
    else if set -ql _flag_B
        $EDITOR + books_to_read.tsv
    else if set -ql _flag_r 
        if type -q glow
            glow (ls -1 *.md | shuf -n 1)
        else
            cat (ls -1 *.md | shuf -n 1)
        end
    else
        # Just go to the folder and exit,
        # if no flags are provided
        return 0
   end

    # check if any of the tracked files was edited, commit changes
    for file in (git diff --name-only)
        if test -f "$file"
            switch $file
                case 'TODO.md'
                    set commit_msg "Update TODO list"
                case 'books_finished.tsv'
                    set commit_msg "Log finished books"
                case 'books_to_read.tsv'
                    set commit_msg "Log books to read"
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
