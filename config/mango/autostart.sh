waybar -c ~/.config/mango/config.jsonc -s ~/.config/mango/style.css >/dev/null 2>&1 &
swaybg -i ~/nixos-dotfiles/wallpapers/bg.jpg -m fill >/dev/null 2>&1 &
dunst >/dev/null 2>&1 &

nm-applet --indicator >/dev/null 2>&1 &
blueman-applet >/dev/null 2>&1 &

