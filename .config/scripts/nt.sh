#!/bin/sh

mode=$1

if [ -n "$NOTES_DIR" ]; then
    cd "$NOTES_DIR" || { echo "Failed to cd into $NOTES_DIR"; exit 1; }
else
    echo "Environment variable 'NOTES_DIR' is not set."
    exit 1
fi

committed_anything=false

# Commit zotero_library.bib if changed
if ! git diff --quiet zotero_library.bib ; then
    git add zotero_library.bib
    git commit --allow-empty-message -m ""
    committed_anything=true
fi

now=$(date +%s)
last_pull=0
if [ -f ".last_pull_time" ]; then
    last_pull=$(cat ".last_pull_time")
fi

if [ $(( now - last_pull )) -gt 3600 ]; then
    git pull
    echo "$now" > ".last_pull_time"
fi

case "$mode" in
    n )
        # Make a new note
        datetime=$(date +%Y%m%d%H%M%S)
        newnote="$datetime.md"
        $EDITOR "$newnote"

        if [ -f "$newnote" ] ; then
            first_line=$(head -n 1 "$newnote")

            git add "$newnote"
            git commit -m "new note $first_line"

            committed_anything=true
        fi
        ;;
    s )
        if [ "$FILE_BROWSER" = "br" ]; then
            $SHELL -c "br -HI --cmd cr/ ."
        elif [ "$EDITOR" = "nvim" ] ; then
            nvim -c "Telescope live_grep"
        else 
            "$FILE_BROWSER"
        fi
        ;;
    b )
        dt=$(date +%Y/%m/%d)
        echo "$dt" >> books_finished.tsv

        $EDITOR + books_finished.tsv

        if [ "$(tail -n 1 books_finished.tsv)" = "$dt" ]; then
            git restore books_finished.tsv
        fi
        ;;
    B )
        $EDITOR + books_to_read.tsv
        ;;
    t )
        $EDITOR TODO.md
        ;;
    r )
        if command -v glow >/dev/null 2>&1; then
            file=$(ls -1 *.md | shuf -n 1)
            glow "$file"
        else
            file=$(ls -1 *.md | shuf -n 1)
            cat "$file"
        fi
        ;;
    * )
        echo "Invalid mode: $mode" >&2
        exit 1
        ;;
esac

for file in $(git diff --name-only); do
    if [ ! -f "$file" ]; then
        continue
    fi

    case "$file" in
        TODO.md | books_finished.tsv | books_to_read.tsv)
            commit_msg=""
            ;;
        *)
            first_line=$(head -n 1 "$file")
            commit_msg="edits on $first_line"
            ;;
    esac

    git add "$file"
    git commit --allow-empty-message -m "$commit_msg"

    committed_anything=true
done

if [ "$committed_anything" = true ]; then
    git push
fi
