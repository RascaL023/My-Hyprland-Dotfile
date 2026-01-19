#!/usr/bin/env bash

$msg
if pgrep -x hypridle >/dev/null; then
  pkill hypridle
  msg="activated"
else
  hypridle &
  msg="disabled"
fi

notify-send \
  -t 3000 \
  -i "$HOME/Pictures/Icons/hyprland.icon" \
  "Hypridle" \
  "Idle mode has been ${msg}!"

