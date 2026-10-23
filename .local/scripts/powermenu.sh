#!/usr/bin/env bash

THEME="$HOME/.config/rofi-spotlight/spotlight.rasi"

options="   Hibernate
   Poweroff
   Reboot
   Lock
   Logout"

op=$(echo -e "$options" \
    | rofi -no-config -dmenu -i -p "Power" -theme "$THEME" \
        -theme-str '* { font: "JetBrainsMono Nerd Font 13"; } window { width: 420px; } listview { lines: 5; } entry { placeholder: "Power menu"; }' \
    | awk '{print tolower($NF)}')

case $op in
    poweroff|reboot|hibernate)
        systemctl "$op"
        ;;
    lock)
        exec ~/.local/scripts/lock.sh
        ;;
    logout)
        i3-msg exit
        ;;
esac
