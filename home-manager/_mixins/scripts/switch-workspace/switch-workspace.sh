#! /usr/bin/env bash

declare -A workspaces=(
	["terminal"]="st"
	["video"]="obs"
	["browser"]="firefox"
	["music"]="spotify"
	["chat"]="qq"
	["game"]="steam"
)

target_workspace="$1"
target_window_app_id="$2"

if [ -z "$target_workspace" ]; then
	echo "please input args"
	exit 0
fi

if [ -z "$target_window_app_id" ]; then
	niri msg action focus-worspace "$target_workspace"
else
	json_data=$(niri msg -j windows)

	declare -A window_info=(
		["id"]=""
		["title"]=""
		["app_id"]=""
		["pid"]=""
		["workspace_id"]=""
		["is_focused"]=""
		["is_floating"]=""
	)

	result=$(echo "$json_data" | jq --arg target_app_id "$target_window_app_id" '.[] | select(.app_id == $target_app_id)')

	# 将结果转换为键值对，并存储到关联数组中
	while IFS=$'\n' read -r line; do
		id=$(echo "$line" | jq -r '.id')
		title=$(echo "$line" | jq -r '.title')
		app_id=$(echo "$line" | jq -r '.app_id')
		pid=$(echo "$line" | jq -r '.pid')
		workspace_id=$(echo "$line" | jq -r '.workspace_id')
		is_focused=$(echo "$line" | jq -r '.is_focused')
		is_floating=$(echo "$line" | jq -r '.is_floating')

		# 存储到关联数组
		window_info["id"]="$id"
		window_info["title"]="$title"
		window_info["app_id"]="$app_id"
		window_info["pid"]="$pid"
		window_info["workspace_id"]="$workspace_id"
		window_info["is_focused"]="$is_focused"
		window_info["is_floating"]="$is_floating"
	done < <(echo "$result" | jq -c '.')

	if [ "${window_info["app_id"]}" != "$target_window_app_id" ]; then
		niri msg action focus-workspace "$target_workspace" && "${workspaces["$target_workspace"]}"
	else
		if [ "${window_info["app_id"]}" == "St" ]; then
			niri msg action focus-workspace "$target_workspace"
		else
			niri msg action focus-window --id "${window_info["id"]}"
		fi
	fi
fi
