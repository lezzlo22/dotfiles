#!/usr/bin/env bash

options=" Hibernate
 Poweroff
 Reboot
 Lock
 Logout"

op=$(echo -e "$options" \
    | rofi -dmenu -i -p "Power Menu" -theme-str 'window {width: 300px;}' \
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
