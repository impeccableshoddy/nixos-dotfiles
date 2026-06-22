#!/usr/bin/env bash
mode="${1:-save}"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
TMPFILE="/tmp/screenshot-$(date +%s).png"

# Freeze
p=$(mktemp -u).fifo; mkfifo "$p"
wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
read -t 5 -r < "$p"

# -o adds output rects so click = select output (monitor), drag = region, Escape = cancel
GEOM=$(slurp -o -d)
SLURP_STATUS=$?

if [ "$SLURP_STATUS" -ne 0 ] || [ -z "$GEOM" ]; then
    kill "$wp" 2>/dev/null; rm -f "$p"
    rm -f "$TMPFILE"
    exit 0
fi

grim -g "$GEOM" "$TMPFILE"
kill "$wp" 2>/dev/null; rm -f "$p"

if [ "$mode" = "save" ]; then
    FILENAME="${SCREENSHOT_DIR}/$(date +%Y-%m-%d_%H-%M-%S).png"
    swappy -f "$TMPFILE" -o "$FILENAME"
    if [ -f "$FILENAME" ]; then
        wl-copy < "$FILENAME"
        notify-send -i "$FILENAME" "󰄄 Screenshot" "Saved as $(basename "$FILENAME")"
    fi
else
    CLIPFILE="/tmp/screenshot-clip-$(date +%s).png"
    swappy -f "$TMPFILE" -o "$CLIPFILE"
    if [ -f "$CLIPFILE" ]; then
        wl-copy < "$CLIPFILE"
        notify-send -r 9996 "󰄄 Screenshot" "Copied to clipboard"
        rm -f "$CLIPFILE"
    fi
fi

rm -f "$TMPFILE"
