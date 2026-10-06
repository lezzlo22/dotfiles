#!/bin/sh
LOG="$HOME/.cache/sddm_pywal.log"
WAL_JSON="$HOME/.cache/wal/colors.json"
WAL_COLORS="$HOME/.cache/wal/colors.sh"
THEME_DIR="/usr/share/sddm/themes/sugar-candy"
THEME_BG="$THEME_DIR/Backgrounds/current.jpg"
THEME_CONF="$THEME_DIR/theme.conf"

echo "Running at $(date)" >> "$LOG"

if [ ! -f "$WAL_JSON" ] || [ ! -f "$WAL_COLORS" ]; then
    echo "Missing pywal colors, skipping." >> "$LOG"
    exit 1
fi

. "$WAL_COLORS"
WALLPAPER="$wallpaper"

if [ ! -f "$WALLPAPER" ]; then
    echo "Wallpaper not found: $WALLPAPER" >> "$LOG"
    exit 1
fi

fg=$(jq -r '.special.foreground' "$WAL_JSON")
bg=$(jq -r '.special.background' "$WAL_JSON")
c4=$(jq -r '.colors.color4' "$WAL_JSON")

SCREEN_RES=$(xrandr 2>/dev/null | grep '\*' | awk '{print $1}')
SCREEN_W=$(echo "$SCREEN_RES" | cut -dx -f1)
SCREEN_H=$(echo "$SCREEN_RES" | cut -dx -f2)

magick "$WALLPAPER" \
    -filter point \
    -resize "${SCREEN_W:-1920}x${SCREEN_H:-1080}^" \
    -gravity center \
    -extent "${SCREEN_W:-1920}x${SCREEN_H:-1080}" \
    "$THEME_BG" 2>> "$LOG"

chmod 644 "$THEME_BG"

cat > "$THEME_CONF" << EOF
[General]
Background="Backgrounds/current.jpg"
ScreenWidth="${SCREEN_W:-1920}"
ScreenHeight="${SCREEN_H:-1080}"
FormPosition="center"
MainColor="${fg}"
AccentColor="${c4}"
BackgroundColor="${bg}"
DimBackgroundImage="0.5"
FullBlur="false"
PartialBlur="false"
HaveFormBackground="false"
RoundCorners="10"
Font="JetBrainsMono Nerd Font"
HourFormat="HH:mm"
DateFormat="dddd, d 'of' MMMM"
ForceLastUser="true"
ForcePasswordFocus="true"
HeaderText=""
EOF

echo "Done." >> "$LOG"
