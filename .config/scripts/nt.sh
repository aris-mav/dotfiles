#!/bin/sh

mode=$1

if [ -n "$NOTES_DIR" ]; then
    cd "$NOTES_DIR" || { echo "Failed to cd into $NOTES_DIR"; exit 1; }
else
    echo "Environment variable 'NOTES_DIR' is not set."
    exit 1
fi

committed_anything=false

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
        # Search in notes
        if command -v bat >/dev/null 2>&1; then
            previewcmd='bat --style=numbers --color=always --highlight-line {2} {1}'
        elif command -v batcat >/dev/null 2>&1; then
            previewcmd='batcat --style=numbers --color=always --highlight-line {2} {1}'
        else
            previewcmd='less {1}'
        fi

        if command -v rg >/dev/null 2>&1; then
            grepcmd='rg --line-number --no-heading --color=always'
        else
            # grep fallback (keep filename:line:match format)
            grepcmd='grep -R -n --color=always -H'
        fi

        if command -v sk >/dev/null 2>&1; then

            sk --ansi \
                --cmd  "$grepcmd '{}'" \
                --delimiter : \
                --preview "$previewcmd" \
                --preview-window="right:66%:wrap" \
                --bind "Enter:execute($EDITOR {1}),ctrl-q:abort" \
                --reverse

        elif command -v fzf >/dev/null 2>&1; then

            $grepcmd "" 2>/dev/null | \
                fzf --ansi \
                --delimiter : \
                --bind "change:reload:$grepcmd {q} || true" \
                --bind "enter:become($EDITOR {1})" \
                --bind "ctrl-q:abort" \
                --preview "$previewcmd" \
                --preview-window=right:66%:wrap \
                --height 100%

        elif command -v br >/dev/null 2>&1; then
            br -HI --cmd cr/ .

        elif [ "$EDITOR" = "nvim" ]; then
            nvim -c "Telescope live_grep"
        fi
        ;;
    b )
        # Log book you just finished
        dt=$(date +%Y/%m/%d)
        echo "$dt" >> books_finished.tsv

        $EDITOR + books_finished.tsv

        if [ "$(tail -n 1 books_finished.tsv)" = "$dt" ]; then
            git restore books_finished.tsv
        fi
        ;;
    B )
        # Log book you want to read
        $EDITOR + books_to_read.tsv
        ;;
    t )
        # Edit your TODO list
        $EDITOR TODO.md
        ;;
    r )
        # Print a random note
        if command -v glow >/dev/null 2>&1; then
            file=$(ls -1 *.md | shuf -n 1)
            glow "$file"
        else
            file=$(ls -1 *.md | shuf -n 1)
            cat "$file"
        fi
        ;;
    * )
        echo "Provide one argument:"
        echo "	n (new note)"
        echo "	s (search notes)"
        echo "	t (edit TODO list)"
        echo "	r (print a random note)"
        echo "	b (log a book you finished)"
        echo "	B (log a book you want to read)"
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
