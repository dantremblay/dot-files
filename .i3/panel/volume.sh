#!/bin/bash

status=$(amixer -c 0 -D pulse get Master | grep "Front Left:" | awk '{print $6}')
vol=$(amixer -c 0 -D pulse get Master -M | grep -oE -m1 "[[:digit:]]*%")

if [ $status == "[on]" ]; then
        if [ $vol == "0%" ]; then
                echo "Muted [$vol]"
        else
                echo "Vol: $vol"
        fi
else
        echo "Muted [$vol]"
fi
