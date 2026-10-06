#!/bin/sh
source "${HOME}/.cache/wal/colors.sh"

BLANK="$background"
CLEAR="#00000000"
DEFAULT="$color4"
TEXT="$foreground"
WRONG="$color1"
VERIFYING="$color3"

WALLPAPER="${wallpaper:-${HOME}/.cache/wal/wallpaper}"
SCREEN_RES=$(xrandr | grep '*' | awk '{print $1}')

# Resize to screen resolution and keep proportions
magick "$WALLPAPER" -filter point -resize "${SCREEN_RES}^" -gravity center -extent "${SCREEN_RES}" /tmp/lock.png

i3lock \
  --insidever-color=$CLEAR \
  --ringver-color=$VERIFYING \
  --insidewrong-color=$CLEAR \
  --ringwrong-color=$WRONG \
  --inside-color=$BLANK \
  --ring-color=$DEFAULT \
  --line-color=$BLANK \
  --separator-color=$DEFAULT \
  --verif-color=$TEXT \
  --wrong-color=$TEXT \
  --time-color=$TEXT \
  --date-color=$TEXT \
  --layout-color=$TEXT \
  --keyhl-color=$WRONG \
  --bshl-color=$WRONG \
  --screen 1 \
  --clock \
  --indicator \
  --time-str="%H:%M:%S" \
  --date-str="%A, %Y-%m-%d" \
  --keylayout 1 \
  -i /tmp/lock.png
