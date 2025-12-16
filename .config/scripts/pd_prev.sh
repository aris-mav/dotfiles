#!/bin/sh

pandoc $1 -o /tmp/preview.pdf
xdg-open /tmp/preview.pdf >/dev/null 2>&1 &
