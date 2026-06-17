#!/usr/bin/env bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILENAME="${SCREENSHOT_DIR}/$(date +%Y-%m-%d_%H-%M-%S).png"
TMPFILE="/tmp/screenshot-$(date +%s).png"

# Try area select first — if user clicks without dragging, slurp exits with error
# and we fall back to full screen
if grim -g "$(slurp)" "$TMPFILE" 2>/dev/null; then
    # Area selected — open swappy automatically
    swappy -f "$TMPFILE" -o "$FILENAME"
else
    # Click without drag = full screen — open swappy automatically
    grim "$TMPFILE"
    swappy -f "$TMPFILE" -o "$FILENAME"
fi

if [ -f "$FILENAME" ]; then
    wl-copy < "$FILENAME"
    notify-send -i "$FILENAME" "Screenshot" "Saved as $(basename "$FILENAME")"
fi

rm -f "$TMPFILE"
