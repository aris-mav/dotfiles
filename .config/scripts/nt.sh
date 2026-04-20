#!/bin/sh

help_msg() {
    echo "Provide one of the follwing options:"
    echo "	some_text    - edit filename containing some_text"
    echo "	-n/--new     - new note"
    echo "	-r/--random  - view a random note"
    echo "	-t/--tags    - print available tags"
    echo "	-s/--search  - search content in all notes"
    echo "	-p/--preview - preview an .md file as .pdf"
    echo "	-b/--book    - log a finished book"
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

    if [ ! "$input_markdown_file" -ot "$pdf_filename" ]; then

        if LC_ALL=C grep '[^ -~]' "$input_markdown_file" >/dev/null 2>&1; then

            if command -v xelatex >/dev/null 2>&1; then
                ENGINE="xelatex"
            elif command -v lualatex >/dev/null 2>&1; then
                ENGINE="lualatex"
            else
                echo "Error: Non-ASCII characters detected, \
                    but neither xelatex nor lualatex was found." >&2
                exit 1
            fi

            if fc-list -q "FreeSans"; then
                SELECTED_FONT="FreeSans"
            else
                SELECTED_FONT=$(
                    fc-list : family | \
                        head -n 1 | \
                        cut -d: -f2 | \
                        cut -d, -f1 | \
                        sed 's/^ //'
                    )
            fi

            set -- "--pdf-engine=$ENGINE" -V "mainfont=$SELECTED_FONT"

        else
            set -- "-V fontfamily=newpx"
        fi

        case "$input_markdown_file" in
            [0-9]*.md)
                pandoc "$input_markdown_file" -o "$pdf_filename" "$@" \
                    -V documentclass=extarticle \
                    -V fontsize=20pt \
                    -V geometry:margin=0.5in \
                    -V pagestyle=empty \
                    -V linestretch=1.3 \
                    -V colorlinks=true \
                    -V linkcolor=blue
                ;;
            *)
                pandoc "$input_markdown_file" -o "$pdf_filename"
                ;;
        esac
    fi

    if command -v zathura >/dev/null 2>&1; then
        zathura --mode fullscreen \
            -c "$HOME/.config/zathura/dark" "$pdf_filename" >/dev/null 2>&1 &
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
        edit_cmd="$EDITOR +{2} {1}"
        ;;
    helix|hx )
        edit_cmd="$EDITOR {1}:{2}"
        ;;
    nano )
        edit_cmd="$EDITOR +{2},1 {1}"
        ;;
    * )
        edit_cmd="$EDITOR {1}"
        ;;
esac

note_search() {

    validfiles=$(mktemp --tmpdir -u valid_files_XXXXX)
    trap 'rm -f "$validfiles"' 0 INT TERM
    find -- *.md -maxdepth 1 -type f | sort -R > "$validfiles"

    if command -v fzf >/dev/null 2>&1; then

        if command -v rg >/dev/null 2>&1; then
            grep_cmd="rg -SHn"
            get_filenames="rg -oP '[a-zA-Z0-9_.-]+\.[a-z]+(?=:)'"
        elif command -v grep >/dev/null 2>&1; then
            # grep fallback (keep filename:line:match format)
            grep_cmd="grep -E -n -i -H"
            get_filenames="grep -oP '[a-zA-Z0-9_.-]+\.[a-z]+(?=:)'"
        fi

        bat=$(command -v bat || command -v batcat)
        if [ ! -z "$bat" ];then
            bat="$bat --style=numbers --color=always"
            prev_cmd="[ -z {2} ] && $bat {1} || $bat --highlight-line {2} {1}"
        else
            prev_cmd="cat {1}"
        fi

        if [ "$(tput cols)" -gt 100 ]; then
            prev_win='right:66%:wrap'
        else
            prev_win='up:66%:wrap'
        fi

        grep_filter=" 
        [ -z {q} ] || \
            cat $validfiles | \
            xargs -d '\n' $grep_cmd -- {q} | \
            $get_filenames | \
            sort -ur > $validfiles.tmp \
            &&  mv $validfiles.tmp $validfiles
        "
        change_cmd="
        [ -z {q} ] && cat $validfiles || \
            cat $validfiles | \
            xargs -d '\n' $grep_cmd --color=always -- {q} \
            || true
        "
        reset_cmd="find -- *.md -maxdepth 1 -type f | sort -R > $validfiles"

        fzf --ansi \
            --disabled \
            --delimiter : \
            --preview="$prev_cmd" \
            --preview-window="$prev_win" \
            --reverse --height 100% \
            --bind "start:reload(cat \"$validfiles\")" \
            --bind "change:reload:sleep 0.1; $change_cmd" \
            --bind "enter:execute-silent($grep_filter)" \
            --bind "enter:+clear-query" \
            --bind "ctrl-o:execute-silent($reset_cmd)" \
            --bind "ctrl-o:+clear-query+reload(cat $validfiles)" \
            --bind "ctrl-s:reload(cat \"$validfiles\" | sort -r)" \
            --bind "ctrl-z:execute($0 -p {1})" \
            --bind "ctrl-e:execute($edit_cmd)" \
            --bind "ctrl-q:abort" \

        elif command -v br >/dev/null 2>&1; then
            br -HI --cmd cr/ .

        elif [ "$EDITOR" = "nvim" ]; then
            nvim -c "Telescope live_grep"
        else
            echo "Install fzf, br or nvim (with telescope)."
            exit 1
    fi

}

new_note() {

    datetime=$(date +%Y%m%d%H%M%S)
    newnote="$datetime.md"
    $EDITOR "$newnote"

    if [ -s "$newnote" ] ; then
        first_line=$(head -n 1 "$newnote")
        git add "$newnote"
        git commit -m "new note $first_line"
        committed_anything=true
    else # The file is empty.
        rm -f "$newnote"
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

commit_changes() { 
    for file in $(git diff --name-only); do

        if [ -s "$file" ]; then
            # The file is not-empty.
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
        else
            # The file is empty.
            git rm "$file"
            git commit -m "removed $file"
            committed_anything=true
        fi
    done

    if [ "$committed_anything" = true ]; then
        git push
    fi
}

# switch for input flags
case "$1" in
    -n|--new )
        new_note
        commit_changes
        ;;
    -s|--search )
        note_search
        commit_changes
        ;;
    -r )
        random_note
        ;;
    -t )
        tags
        ;;
    -b )
        dt=$(date +%Y/%m/%d)
        echo "$dt" >> "books_finished.tsv"

        $EDITOR + "books_finished.tsv"

        if [ "$(tail -n 1 "books_finished.tsv")" = "$dt" ]; then
            git restore "books_finished.tsv"
        fi
        commit_changes
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
            "$EDITOR" "$file"
        fi
        commit_changes
        ;;
esac
