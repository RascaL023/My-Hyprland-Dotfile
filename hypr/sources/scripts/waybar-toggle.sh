#!/usr/bin/env bash

if pgrep waybar > /dev/null; then
    pkill waybar
else
    # waybar -c ~/.dotfiles/themes/deploy/waybar/live/config.jsonc \
    #        -s ~/.dotfiles/themes/deploy/waybar/live/style.css & disown
    waybar
fi
