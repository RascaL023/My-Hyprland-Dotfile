#!/usr/bin/env bash

if pgrep wlogout > /dev/null; then
    pkill wlogout
else
		wlogout
fi
