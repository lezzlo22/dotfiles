#!/usr/bin/env bash
# keep_steam_games_on_top.sh

while sleep 1; do
    # get currently active window
    focused=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
    [[ -z "$focused" ]] && continue

    class=$(xprop -id "$focused" WM_CLASS 2>/dev/null)
    title=$(xprop -id "$focused" WM_NAME 2>/dev/null)

    # if Steam Big Picture itself -> force fullscreen
    if [[ $class =~ Steam && $title =~ "Big Picture Mode" ]]; then
        i3-msg '[class="^Steam$" title=".*Big Picture Mode.*"] fullscreen enable' >/dev/null
    fi

    # if game window launched by Steam -> float + focus + above Steam
    if [[ $class =~ Steam || $class =~ proton || $title =~ "Steam" ]]; then
        # Ignore Big Picture itself
        if [[ ! $title =~ "Big Picture Mode" ]]; then
            i3-msg '[class="^(?!Steam$).*"] floating enable, focus, move position center' >/dev/null
        fi
    fi
done
