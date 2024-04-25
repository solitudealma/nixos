#!/usr/bin/env sh

    swaylock  --screenshots \
             --grace-no-mouse \
             --grace-no-touch \
             --indicator \
             --clock \
             --inside-wrong-color f38ba8 \
             --ring-wrong-color 11111b \
             --inside-clear-color a6e3a1 \
             --ring-clear-color 11111b \
             --inside-ver-color 89b4fa \
             --ring-ver-color 11111b \
             --text-color  f5c2e7 \
             --indicator-radius 80 \
             --indicator-thickness 5 \
             --effect-blur 10x7 \
             --effect-vignette 0.2:0.2 \
             --ring-color 11111b \
             --key-hl-color f5c2e7 \
             --line-color 313244 \
             --inside-color 0011111b \
             --separator-color 00000000 \
             --indicator-caps-lock \
             --fade-in 0.1 \
             --daemonize

# lock & turn off monitor after 20 mins, suspend after 30 mins // install swayidle
swayidle -w \
  timeout 1200 'if pgrep -x swaylock; then hyprctl dispatch dpms off resume hyprctl dispatch dpms on timeout 1800 systemctl suspend; else  killall swayidle; fi'


# dunst && dunstctl set-paused true; dunstctl set-paused false &&