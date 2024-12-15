#!/bin/bash

while true; do
    # Use xev to capture mouse wheel events (button 4 = up, button 5 = down)
    EVENT=$(xev -root -event mouse | grep -E 'button (4|5)' | tail -n 1)
    if [[ $EVENT =~ "button 4" ]]; then
        # Simulate Arrow Up (scroll up)
        xdotool key Up
    elif [[ $EVENT =~ "button 5" ]]; then
        # Simulate Arrow Down (scroll down)
        xdotool key Down
    fi
    sleep 0.1
done
