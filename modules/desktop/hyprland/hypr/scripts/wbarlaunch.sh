#!/usr/bin/env bash

## Copyright (C) 2023 Ticks <ticks.cc@gmail.com>
##
## Launch waybar script
##

#CUR_DIR="$(cd "$(dirname "${BASE_SOURCE[0]}")" &>/dev/null && pwd)"
#echo "${CUR_DIR}"
CUR_DIR="${HOME}/.config/waybar"

launch_bar() {
	killall -q .waybar-wrapped

	while pgrep -u $UID -x waybar >/dev/null; do sleep 1; done

	waybar -c "${CUR_DIR}"/config.jsonc -s "${CUR_DIR}"/style.css &
}

launch_bar
