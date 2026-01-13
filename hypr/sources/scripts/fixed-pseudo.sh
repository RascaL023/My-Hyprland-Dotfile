#!/usr/bin/env bash

WIN_ID=$(hyprctl activewindow -j | jq -r '.class')

# Aktifkan pseudo floating
hyprctl keyword window:$WIN_ID pseudo on
# hyprctl keyword class:foot pseudo on

# Atur ukuran & posisi
hyprctl keyword window:$WIN_ID geometry 800x600+300+200
