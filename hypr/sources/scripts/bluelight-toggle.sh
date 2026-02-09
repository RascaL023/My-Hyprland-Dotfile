#!/usr/bin/env bash

$msg
if pgrep -x hyprsunset >/dev/null; then
  pkill hyprsunset 
  msg="disabled"
else
  hyprsunset  -t 4000 &
  msg="activated"
fi

notify-send \
  -t 3000 \
  -i "$HOME/Pictures/Icons/hyprland.icon" \
  "Hyprsunset" \
  "Blue light filter has been ${msg}!"

