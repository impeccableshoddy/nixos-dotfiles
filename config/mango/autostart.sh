#!/usr/bin/env bash
waybar -c ~/.config/mango/config.jsonc -s ~/.config/mango/style.css >/dev/null 2>&1 &
dunst >/dev/null 2>&1 &

nm-applet --indicator >/dev/null 2>&1 &
blueman-applet >/dev/null 2>&1 &

# SURE-FIRE FALLBACK ARCHITECTURE:
CACHE_FILE="$HOME/.cache/current_bg"
if [ -f "$CACHE_FILE" ] && [ -f "$(cat "$CACHE_FILE")" ]; then
    BG=$(cat "$CACHE_FILE")
else
    BG="$HOME/nixos-dotfiles/wallpapers/arcade.jpg"
fi

swaybg -i "$BG" -m fill >/dev/null 2>&1 &
