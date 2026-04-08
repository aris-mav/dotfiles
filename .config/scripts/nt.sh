#!/bin/sh

help_msg() {
    echo "Provide one of the follwing options:"
    echo "	some_text    - edit filename containing some_text"
    echo "	-n/--new     - new note"
    echo "	-r/--random  - view a random note"
    echo "	-t/--tags    - print available tags"
    echo "	-s/--search  - search content in all notes"
    echo "	-p/--preview - preview an .md file as .pdf"
    echo "	-h/--help    - print this message"
}

md_preview() {

    input_markdown_file="$1"
    if [ -z "$input_markdown_file" ]; then
        echo "Usage: nt -p <file.md>" >&2
        return 1
    fi

    note_cache="$HOME/.cache/nt_notes"
    mkdir -p "$note_cache"

    mdname="$(basename "$input_markdown_file")"
    pdf_filename="$note_cache/${mdname%.md}.pdf"

    if [ ! -f "$pdf_filename" ] || [ "$input_markdown_file" -nt "$pdf_filename" ]; then

        if LC_ALL=C grep '[^ -~]' "$input_markdown_file" >/dev/null 2>&1; then

            if command -v xelatex >/dev/null 2>&1; then
                ENGINE="xelatex"
            elif command -v lualatex >/dev/null 2>&1; then
                ENGINE="lualatex"
            else
                echo "Error: Non-ASCII characters detected, but neither xelatex nor lualatex was found." >&2
                exit 1
            fi

            if fc-list -q "FreeSans"; then
                SELECTED_FONT="FreeSans"
            else
                SELECTED_FONT=$(fc-list : family | head -n 1 | cut -d: -f2 | cut -d, -f1 | sed 's/^ //')
            fi

            set -- "--pdf-engine=$ENGINE" -V "mainfont=$SELECTED_FONT"

        else
            set -- "-V fontfamily=newpx"
        fi

        pandoc "$input_markdown_file" -o "$pdf_filename" "$@" \
            -V documentclass=extarticle \
            -V fontsize=20pt \
            -V geometry:margin=0.5in \
            -V pagestyle=empty \
            -V linestretch=1.3 \
            -V colorlinks=true \
            -V linkcolor=blue
    fi

    if command -v zathura >/dev/null 2>&1; then
        zathura --mode fullscreen -c "$HOME/.config/zathura/dark" "$pdf_filename" >/dev/null 2>&1 &
    else
        xdg-open "$pdf_filename" >/dev/null 2>&1 &
    fi
}

if [ "$1" = "-p" ]; then
    md_preview "$2"
    exit 0
elif [ $# -gt 1 ]; then
    help_msg
    exit 1
fi

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

note_search() {

    validfiles=$(mktemp --tmpdir -u valid_files_XXXXX)
    trap 'rm -f "$validfiles"' 0 INT TERM
    find -- *.md -maxdepth 1 -type f | sort -R > "$validfiles"

    if command -v rg >/dev/null 2>&1; then
        grepcmd="rg -SHn"
        get_filenames="rg -oP '[a-zA-Z0-9_.-]+\.[a-z]+(?=:)'"
    elif command -v grep >/dev/null 2>&1; then
        # grep fallback (keep filename:line:match format)
        grepcmd="grep -E -n -i -H"
        get_filenames="grep -oP '[a-zA-Z0-9_.-]+\.[a-z]+(?=:)'"
    fi

    bat=$(command -v bat || command -v batcat)
    if [ ! -z "$bat" ];then
        bat="$bat --style=numbers --color=always"
        prevcmd="[ -z {2} ] && $bat {1} || $bat --highlight-line {2} {1}"
    else
        prevcmd="cat {1}"
    fi

    if [ "$(tput cols)" -gt 100 ]; then
        prevwin='right:66%:wrap'
    else
        prevwin='up:66%:wrap'
    fi

    if command -v fzf >/dev/null 2>&1; then

        fzf --ansi \
            --disabled \
            --delimiter : \
            --preview="$prevcmd" \
            --preview-window="$prevwin" \
            --reverse --height 100% \
            --bind "start:reload(cat \"$validfiles\")" \
            --bind "change:reload:sleep 0.1; [ -z {q} ] && cat $validfiles || cat $validfiles | xargs -d '\n' $grepcmd --color=always -- {q} || true" \
            --bind "enter:execute-silent([ -z {q} ] || cat $validfiles | xargs -d '\n' $grepcmd -- {q} | $get_filenames | sort -ur > $validfiles.tmp && mv $validfiles.tmp $validfiles)" \
            --bind "enter:+clear-query" \
            --bind "ctrl-o:execute-silent(find -- *.md -maxdepth 1 -type f | sort -R > $validfiles)" \
            --bind "ctrl-o:+clear-query+reload(cat $validfiles)" \
            --bind "ctrl-s:reload(cat \"$validfiles\" | sort -r)" \
            --bind "ctrl-z:execute($0 -p {1})" \
            --bind "ctrl-e:execute($editcommand)" \
            --bind "ctrl-q:abort" \

        elif command -v br >/dev/null 2>&1; then
            br -HI --cmd cr/ .

        elif [ "$EDITOR" = "nvim" ]; then
            nvim -c "Telescope live_grep"
    fi

}

new_note() {

    datetime=$(date +%Y%m%d%H%M%S)
    newnote="$datetime.md"
    $EDITOR "$newnote"

    if [ -f "$newnote" ] ; then
        first_line=$(head -n 1 "$newnote")

        git add "$newnote"
        git commit -m "new note $first_line"

        committed_anything=true
    fi
}

random_note() {

    file=$(find -- *.md -maxdepth 1 -type f | shuf -n 1)
    if command -v bat >/dev/null 2>&1; then
        bat -p "$file"
    elif command -v batcat >/dev/null 2>&1; then
        batcat -p "$file"
    else
        cat "$file"
    fi

}

tags() {

    if command -v rg >/dev/null 2>&1; then
        rg -PINo '(?<!\S)#[a-zA-Z]+' | sort -u
    else
        grep -ahPo '(?<!\S)#[a-zA-Z]+\b' ./* | sort -u
    fi

}

# switch for input flags
case "$1" in
    -n|--new )
        new_note
        ;;
    -s|--search )
        note_search
        ;;
    -r )
        random_note
        ;;
    -t )
        tags
        ;;
    --help|-h )
        help_msg
        ;;
    -* )
        echo "$1 flag not valid."
        help_msg
        exit 1
        ;;
    no_args ) # use this option if you just want to pull the remote
        ;;
    * ) # nt 'file' opens a filename containing 'file' in the name

        tmp=$(mktemp) || exit 1
        trap 'rm -f "$tmp"' 0 INT TERM

        if command -v rg >/dev/null 2>&1; then
            find . -maxdepth 1 -type f | rg -S -- "$1" > "$tmp"
        else
            find . -maxdepth 1 -type f | grep -i -- "$1" > "$tmp"
        fi

        count=$(wc -l < "$tmp")

        if [ "$count" -gt 1 ]; then

            if command -v fzf >/dev/null 2>&1; then
                file=$(fzf < "$tmp")
            elif command -v sk >/dev/null 2>&1; then
                file=$(sk < "$tmp")
            fi

            echo "$file" > "$tmp"

        elif [ "$count" -eq 0 ]; then
            echo "No file matches for '$1' in $NOTES_DIR."
            exit 1
        fi

        IFS= read -r file < "$tmp"

        if [ -f "$file" ]; then 

            if [ "$file" = "books_finished.tsv" ]; then 
                # Log book you just finished
                dt=$(date +%Y/%m/%d)
                echo "$dt" >> "$file"

                $EDITOR + "$file"

                if [ "$(tail -n 1 "$file")" = "$dt" ]; then
                    git restore "$file"
                fi
            else
                "$EDITOR" "$file"
            fi
        fi
        ;;
esac

# git commits, if there are changes
for file in $(git diff --name-only); do
    if [ ! -f "$file" ]; then
        continue
    fi

    case "$file" in
        [0-9]*.md)
            first_line=$(head -n 1 "$file")
            commit_msg="edits on $first_line"
            ;;
        *)
            commit_msg=""
            ;;
    esac

    git add "$file"
    git commit --allow-empty-message -m "$commit_msg"

    committed_anything=true
done

if [ "$committed_anything" = true ]; then
    git push
fi
