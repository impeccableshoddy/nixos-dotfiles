#!/usr/bin/env bash
FILE=$(fd -t f -H -E '.cache' -E '.git' . ~/ | awk -F/ '{print $0 "\t" $NF}' | fuzzel --dmenu -d $'\t' --with-nth 2 | cut -f1)
[ -z "$FILE" ] && exit
EXT=$(echo "${FILE##*.}" | tr '[:upper:]' '[:lower:]')
case "$EXT" in
    pdf|cbz|cbr|cb7) nohup zathura "$FILE" > /dev/null 2>&1 & ;;
    epub) nohup mupdf "$FILE" > /dev/null 2>&1 & ;;
    jpg|jpeg|png|gif|webp|bmp|svg) nohup imv "$FILE" > /dev/null 2>&1 & ;;
    mp4|mkv|webm|avi|mov|mp3|flac|wav|ogg) nohup mpv "$FILE" > /dev/null 2>&1 & ;;
    txt|md|nix|sh|py|rs|js|ts|c|cpp|h|toml|yaml|yml|json|xml|lua|conf|desktop|org) nohup foot -e nvim "$FILE" > /dev/null 2>&1 & ;;
    *) nohup xdg-open "$FILE" > /dev/null 2>&1 & ;;
esac
disown
