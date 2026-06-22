#!/usr/bin/env bash

WP_DIRS=("${HOME}/nixos-dotfiles/wallpapers")
CACHE_FILE="${HOME}/.cache/current_bg"

mkdir -p "$(dirname "$CACHE_FILE")"

FILES=$(find "${WP_DIRS[@]}" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null)

[ -z "$FILES" ] && exit 1

CHOICE=$(printf "%s\n" "$FILES" | xargs -I {} basename "{}" | fuzzel -d -p "󰸉 Select Wallpaper: " --width=40 --lines=10)

[ -z "$CHOICE" ] && exit 0

FULL_PATH=$(printf "%s\n" "$FILES" | grep -m 1 "/${CHOICE}$")

if [ -f "$FULL_PATH" ]; then
    echo "$FULL_PATH" > "$CACHE_FILE"
    # Random transition each time for variety
    TRANSITIONS=("outer" "center" "wipe" "simple")
    RAND=$((RANDOM % 4))
    awww img "$FULL_PATH" --transition-type "${TRANSITIONS[$RAND]}" --transition-duration 0.6 --transition-fps 60
    notify-send "Wallpaper" "$(basename "$FULL_PATH")"
fi
