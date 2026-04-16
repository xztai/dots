#!/bin/bash

FILE="~/screenshots/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

wayfreeze --after-freeze-cmd 'grim -g "$(slurp)" - | tee '"$FILE"' | wl-copy; killall wayfreeze'
