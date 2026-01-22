#!/usr/bin/env bash

if pgrep rofi > /dev/null; then
    pkill rofi
else
		rofi -show drun \
      -theme "$HOME/.config/rofi/themes/apps.rasi"
fi
