#!/usr/bin/env bash

if pgrep rofi > /dev/null; then
    pkill rofi
else
		rofi -show drun 
fi
