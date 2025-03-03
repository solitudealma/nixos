#! /usr/bin/env bash

close_music() {
    ncmpcpp_pid=$(ps -u "$USER" -o pid,comm | rg 'ncmpcpp' | awk '{print $1}')
    mpd_pid=$(ps -u "$USER" -o pid,comm | rg 'mpd' | awk '{print $1}')
    cava_pid=$(ps -u "$USER" -o pid,comm | rg 'cava' | awk '{print $1}')
    killed=1
    if [ "$ncmpcpp_pid" ]; then
        kill -9 "$ncmpcpp_pid"
        killed=0
    fi
    if [ "$mpd_pid" ]; then
        mpc pause
    fi
    if [ "$cava_pid" ]; then
        kill -9 "$cava_pid"
        killed=0
    fi
    return "$killed"
}

open_music() {
    st -t st_ncmpcpp -c St_FN -A 0.7 -e ncmpcpp &
    st -t st_cava -c St_FN -A 0.7 -e cava &
}

close_music || open_music
