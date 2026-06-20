#!/usr/bin/env bash

mkdir -p "$HOME/Videos/Recordings/"

if pgrep -x wf-recorder > /dev/null; then
    pkill -INT wf-recorder
    notify-send -r 9995 "󰑊 Recording" "Saved"
else
    wf-recorder -f "$HOME/Videos/Recordings/recording-$(date +%Y-%m-%d_%H-%M-%S).mp4" >/dev/null 2>&1 &
    disown
fi
