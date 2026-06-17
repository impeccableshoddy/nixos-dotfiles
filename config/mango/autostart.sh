#!/usr/bin/env bash

# Start notification daemon
mako >/dev/null 2>&1 &

# Start wallpaper daemon
awww-daemon >/dev/null 2>&1 &

# Set initial wallpaper with fast outer transition
CACHE_FILE="$HOME/.cache/current_bg"
if [ -f "$CACHE_FILE" ] && [ -f "$(cat "$CACHE_FILE")" ]; then
    BG=$(cat "$CACHE_FILE")
else
    BG="$HOME/nixos-dotfiles/wallpapers/mecha.jpg"
    echo "$BG" > "$CACHE_FILE"
fi

awww img "$BG" --transition-type outer --transition-duration 0.5 --transition-fps 60 >/dev/null 2>&1
