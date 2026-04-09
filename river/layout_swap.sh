#!/bin/sh

STATE_FILE="/tmp/river_layout_state"

if [ ! -f "$STATE_FILE" ] || [ "$(cat $STATE_FILE)" = "us" ]; then
    riverctl input "type:keyboard" xkb_layout "ru"
    echo "ru" > "$STATE_FILE"
else
    riverctl input "type:keyboard" xkb_layout "us"
    echo "us" > "$STATE_FILE"
fi
