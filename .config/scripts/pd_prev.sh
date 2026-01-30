#!/bin/sh

input_markdown_file="$1"

id=$(cksum "$input_markdown_file" | awk '{print $1}')
tmpfilename="/tmp/note$id.pdf"

if [ ! -f "$tmpfilename" ]; then

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
        set -- 
    fi

    pandoc "$input_markdown_file" -o "$tmpfilename" "$@"

fi

xdg-open "$tmpfilename" >/dev/null 2>&1 &
