#!/bin/sh

# Usage: ./preview.sh <file_path> <line_number>

FILE="$1"
LINE="$2"

# Determine which 'bat' command to use
if command -v bat >/dev/null 2>&1; then
    BAT_BIN="bat"
elif command -v batcat >/dev/null 2>&1; then
    BAT_BIN="batcat"
else
    BAT_BIN=""
fi

# Logic: If bat exists, use it. If line number is missing, skip the highlight.
if [ -n "$BAT_BIN" ]; then
    if [ -z "$LINE" ] || [ "$LINE" = "0" ]; then
        "$BAT_BIN" --style=numbers --color=always "$FILE"
    else
        "$BAT_BIN" --style=numbers --color=always --highlight-line "$LINE" "$FILE"
    fi
else
    # Fallback to less if bat is not installed
    less -f "$FILE"
fi
