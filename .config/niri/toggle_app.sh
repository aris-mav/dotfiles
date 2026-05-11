#!/bin/sh

APP_NAME=$1

ID=$(
    niri msg -j windows \
        | jq -r \
        ".[] | select(.app_id | ascii_downcase == \"${APP_NAME}\") | .id" \
        | head -n 1
    )

if [ -z "$ID" ] || [ "$ID" = "null" ]; then
    # Not open? Launch it.

    if [ "$APP_NAME" = "music" ]; then
        niri msg action spawn -- alacritty \
        --class music \
        --title rmpc \
        -e rmpc

    else
        niri msg action spawn -- "$APP_NAME"
    fi

else
    # Open? Focus it.
    niri msg action focus-window --id "$ID"
fi
