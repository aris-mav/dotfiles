#!/bin/sh

args_error() {
    echo "Provide one argument:"
    echo "	n (new note)"
    echo "	s (search notes)"
    echo "	t (edit TODO list)"
    echo "	r (print a random note)"
    echo "	b (log a book you finished)"
    echo "	B (log a book you want to read)"
    exit 1
}

if [ $# -gt 1 ]; then
    args_error
fi

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
            grepcmd='rg --multiline --line-number --no-heading --color=always --smart-case'
        else
            # grep fallback (keep filename:line:match format)
            grepcmd='grep -R -n -i --color=always -H'
        fi

        case "$EDITOR" in
            nvim|vim|vi )
                editcommand="$EDITOR +{2} {1}"
                ;;
            helix|hx )
                editcommand="$EDITOR {1}:{2}"
                ;;
            nano )
                editcommand="$EDITOR +{2},1 {1}"
                ;;
            * )
                editcommand="$EDITOR {1}"
                ;;
        esac

        if [ $(tput cols) -gt 100 ]; then
            prevwin='right:66%:wrap'
        else
            prevwin='up:66%:wrap'
        fi

        if command -v fzf >/dev/null 2>&1; then

            fzf --ansi \
                --delimiter : \
                --bind "change:reload:sleep 0.1;$grepcmd {q} || true" \
                --bind "enter:execute($editcommand)" \
                --bind "ctrl-q:abort" \
                --preview "$previewcmd" \
                --preview-window="$prevwin" \
                --reverse --height 100%

        elif command -v sk >/dev/null 2>&1; then

            sk --ansi \
                --cmd  "$grepcmd '{}'" \
                --delimiter : \
                --preview "$previewcmd" \
                --preview-window="$prevwin" \
                --bind "Enter:execute($editcommand)" \
                --bind "ctrl-q:abort" \
                --reverse --height 100%

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
        file=$(ls -1 *.md | shuf -n 1)
        if command -v bat >/dev/null 2>&1; then
            bat -p "$file"
        elif command -v batcat >/dev/null 2>&1; then
            batcat -p "$file"
        else
            cat "$file"
        fi
        ;;
    no_args )
        # use this if you just want to pull the remote
        ;;
    * )
        args_error
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
