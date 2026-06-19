#!/usr/bin/env bash
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILENAME="${SCREENSHOT_DIR}/$(date +%Y-%m-%d_%H-%M-%S).png"
TMPFILE="/tmp/screenshot-$(date +%s).png"

if grim -g "$(slurp)" "$TMPFILE" 2>/dev/null; then
    swappy -f "$TMPFILE" -o "$FILENAME"
else
    grim "$TMPFILE"
    swappy -f "$TMPFILE" -o "$FILENAME"
fi

if [ -f "$FILENAME" ]; then
    wl-copy < "$FILENAME"
    notify-send -i "$FILENAME" "Screenshot" "Saved as $(basename "$FILENAME")"
fi
rm -f "$TMPFILE"
