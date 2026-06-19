#!/bin/sh
wpctl set-mute @DEFAULT_SINK@ toggle
V=$(wpctl get-volume @DEFAULT_SINK@)
if echo "$V" | grep -q MUTED; then
    notify-send -r 9991 "󰖁 Volume" "Muted" -h int:value:0
else
    VOL=$(echo "$V" | grep -oP "[0-9]+\.[0-9]+" | awk '{printf "%d", $1*100}')
    notify-send -r 9991 "󰕾 Volume" "${VOL}%" -h int:value:$VOL
fi
