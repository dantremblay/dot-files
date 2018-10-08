#!/usr/bin/env bash

volCmd="pactl list sinks"
muted=$(${volCmd} | awk '/^\s*Mute:/ { print $2 }')
volume=$(${volCmd} | awk '/^\s*Volume:/ { print $5 }')

if [ "$muted" == "no" ]; then
        if [ "$volume" == "0%" ]; then
                echo "Muted"
        else
                echo "Vol: ${volume}"
        fi
else
        echo "Muted [${volume}]"
fi
