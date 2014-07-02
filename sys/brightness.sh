#!/usr/bin/env bash

usage(){
    echo "brightness.sh [up | down]"
    exit 1
}

if [ $# != 1 ]; then
    usage
fi

current=`cat /sys/class/backlight/intel_backlight/brightness`
max=`cat /sys/class/backlight/intel_backlight/max_brightness`
delta=$(python -c "print $max / 20")

case "$1" in
    up)
        change=$(( current+delta ))
    ;;
    down)
        
        change=$(( current-delta ))
    ;;
esac

if [ -n "$change" ]; then
    echo "Change from $current to $change"
    # exec i3-nagbar -m "Changing brightness from $current to $change" -t "warning" -b "brightness $1"
fi

