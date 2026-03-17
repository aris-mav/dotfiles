#!/bin/sh

# Usage: ./filter_files.sh <query> <validfiles_path> <grep_command>

QUERY="$1"
VALIDFILES="$2"
GREPCMD="$3"

# Check if the query is empty or only whitespace
if [ -z "$QUERY" ]; then
    cat "$VALIDFILES"
else
    # Use xargs to pass the file list to grep
    # Note: -d '\n' is a GNU extension. For strict POSIX, 
    # we use a while loop or ensure the grep command handles the list.
    cat "$VALIDFILES" | xargs -d '\n' $GREPCMD -- "$QUERY" || true
fi
