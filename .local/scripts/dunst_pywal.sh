#!/bin/sh
LOG="$HOME/.cache/dunst_pywal.log"
WAL_JSON="$HOME/.cache/wal/colors.json"
DUNST_TEMPLATE="$HOME/.config/dunst/dunstrc.template"
DUNST_CONF="$HOME/.config/dunst/dunstrc"

echo "Running at $(date)" >> "$LOG"

if [ -f "$WAL_JSON" ]; then
    bg=$(jq -r '.special.background' "$WAL_JSON")
    fg=$(jq -r '.special.foreground' "$WAL_JSON")
    c1=$(jq -r '.colors.color1' "$WAL_JSON")
    c2=$(jq -r '.colors.color2' "$WAL_JSON")
    c3=$(jq -r '.colors.color3' "$WAL_JSON")

    # wrap with quotes to prevent dunst parsing errors
    bg="\"$bg\""
    fg="\"$fg\""
    c1="\"$c1\""
    c2="\"$c2\""
    c3="\"$c3\""

    # create config from template safely
    sed \
        -e "s|{{background}}|$bg|g" \
        -e "s|{{foreground}}|$fg|g" \
        -e "s|{{color1}}|$c1|g" \
        -e "s|{{color2}}|$c2|g" \
        -e "s|{{color3}}|$c3|g" \
        "$DUNST_TEMPLATE" > "$DUNST_CONF"

    echo "Generated $DUNST_CONF with quoted colors." >> "$LOG"
else
    echo "colors.json not found!" >> "$LOG"
fi

echo "Restarting dunst..." >> "$LOG"

pkill -u "$USER" -x dunst
sleep 0.5
nohup dunst --config "$DUNST_CONF" >/dev/null 2>&1 &
