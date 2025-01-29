#!/usr/bin/env bash

if [[ -f $HOME/.cache/city ]]; then

    city=$(cat "$HOME"/.cache/city)
    
    if [[ -z $city ]]; then
        msg="$HOME/.cache/city is empty, write the city name to it"
        notify-send -u low -r 20 "$msg"
        echo "$msg"
    else
        curl v2.wttr.in/"$city"
    fi
else
    msg="$HOME/.cache/city does not exist, write the city name to it"
    notify-send -u low -r 20 "$msg"
    echo "$msg"
fi

