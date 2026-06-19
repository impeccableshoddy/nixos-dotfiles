#!/bin/sh
wpctl set-mute @DEFAULT_SOURCE@ toggle
if wpctl get-volume @DEFAULT_SOURCE@ | grep -q MUTED; then
    notify-send -r 9993 "󰍭 Microphone" "Muted" -h int:value:0
else
    notify-send -r 9993 "󰍬 Microphone" "Active" -h int:value:100
fi
