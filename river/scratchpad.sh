#!/bin/sh

special_tag=$((1 << 20))
state_file="/tmp/telegram_scratchpad_state"

if [ -f "$state_file" ]; then
    # If the file exists, the scratchpad is OPEN. 
    # Toggle the tag to hide it, and remove the file.
    riverctl toggle-focused-tags $special_tag
    rm "$state_file"
else
    # If the file doesn't exist, the scratchpad is HIDDEN.
    # Toggle the tag to show it, wait a millisecond, force focus, and create the file.
    riverctl toggle-focused-tags $special_tag
    sleep 0.01
    wlrctl window focus org.telegram.desktop
    touch "$state_file"
fi
