#!/usr/bin/env bash
mode="${1:-save}"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
TMPFILE="/tmp/screenshot-$(date +%s).png"

# Freeze
p=$(mktemp -u).fifo; mkfifo "$p"
wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
read -r < "$p"

# Select: drag = region, click = fullscreen
if grim -g "$(slurp -d)" "$TMPFILE" 2>/dev/null; then
    :
else
    grim "$TMPFILE"
fi

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
