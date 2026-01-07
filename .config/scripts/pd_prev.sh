#!/bin/sh

input_markdown_file="$1"

id=$(cksum "$input_markdown_file" | awk '{print $1}')
tmpfilename="/tmp/note$id.pdf"

if [ ! -f "$tmpfilename" ]; then
  pandoc "$file" -o "$tmpfilename"
fi

xdg-open "$tmpfilename" >/dev/null 2>&1 &
