#!/bin/sh

# A simple "launch or focus" script for Niri
APP_NAME=$1

ID=$(
    niri msg -j windows \
        | jq -r \
        ".[] | select(.app_id | ascii_downcase == \"${APP_NAME}\") | .id" \
        | head -n 1
    )

if [ -z "$ID" ] || [ "$ID" = "null" ]; then
    # Not open? Launch it.
    niri msg action spawn -- "$APP_NAME"
else
    # Open? Focus it.
    niri msg action focus-window --id "$ID"
fi
