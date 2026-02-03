#!/bin/sh

rm /tmp/note*pdf
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
        set -- "-V fontfamily=newpx"
    fi

    pandoc "$input_markdown_file" -o "$tmpfilename" "$@" \
        -V documentclass=extarticle \
        -V fontsize=20pt \
        -V geometry:margin=0.5in \
        -V pagestyle=empty \
        -V linestretch=1.3 \
        -V colorlinks=true \
        -V linkcolor=blue

fi

if command -v zathura >/dev/null 2>&1; then
    zathura \
        --mode fullscreen \
        -c $HOME/.config/zathura/dark \
        "$tmpfilename" >/dev/null 2>&1 &
else
    xdg-open "$tmpfilename" >/dev/null 2>&1 &
fi
