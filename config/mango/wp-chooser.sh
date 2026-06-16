#!/usr/bin/env bash

WP_DIRS=("${HOME}/Downloads/host" "${HOME}/nixos-dotfiles/wallpapers")
CACHE_FILE="${HOME}/.cache/current_bg"

mkdir -p "$(dirname "$CACHE_FILE")"

# Find actual files, skip any directories or broken links
FILES=$(find "${WP_DIRS[@]}" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null)

if [ -z "$FILES" ]; then
    exit 1
fi

CHOICE=$(printf "%s\n" "$FILES" | xargs -I {} basename "{}" | fuzzel -d -p "󰸉 Select Wallpaper: " --width=40 --lines=10)

if [ -z "$CHOICE" ]; then
    exit 0
fi

FULL_PATH=$(printf "%s\n" "$FILES" | grep -m 1 "/${CHOICE}$")

if [ -f "$FULL_PATH" ]; then
    # Save target path to hidden safe cache file
    echo "$FULL_PATH" > "$CACHE_FILE"

    # Apply wallpaper instantly
    pkill swaybg
    swaybg -i "$FULL_PATH" -m fill >/dev/null 2>&1 &

    # Generate themes directly into your repo config folder structure
    matugen -c ~/nixos-dotfiles/config/matugen/config.toml image "$FULL_PATH"
fi
