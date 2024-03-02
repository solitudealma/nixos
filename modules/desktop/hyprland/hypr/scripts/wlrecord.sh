#!/bin/sh
# wf-recorder -f test.gif -c gif -g "$(slurp)"
#active=$(pacmd list-sources | awk 'c&&!--c;/* index*/{c=1}' | awk '{gsub(/<|>/,"",$0); print $NF}')
active=$(pactl list sources | grep Name)

filename=$(date +%F_%T.mkv)

echo active sink: $active 
echo $filename

if [ -z $(pgrep wf-recorder) ];
	then notify-send "Recording Started ($active)"
	if [ "$1" == "-s" ]
		then wf-recorder -f $HOME/Videos/wf-recorder/$filename -a "$active" -g "$(slurp -c "#FFFFFF")" >/dev/null 2>&1 &
			sleep 2 
			while [ ! -z $(pgrep -x slurp) ]; do wait; done
			pkill -RTMIN+8 waybar
	else if [ "$1" == "-w" ] 
		then wf-recorder -f $HOME/Videos/wf-recorder/$filename -a "$active" -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp -c "#FFFFFF" )" >/dev/null 2>&1 &
			 sleep 2
			 while [ ! -z $(pgrep -x slurp) ]; do wait; done
			 pkill -RTMIN+8 waybar
	else if [ "$1" == "-a"]
		wf-recorder -f $HOME/Videos/wf-recorder/$filename -a "$active" >/dev/null 2>&1 &
		pkill -RTMIN+8 waybar
	fi
fi
else
	killall -s SIGINT wf-recorder
	notify-send "Recording Complete"
	while [ ! -z $(pgrep -x wf-recorder) ]; do wait; done
	pkill -RTMIN+8 waybar
	name="$(zenity --entry --text "enter a filename")"
	perl-rename "s/\.(mkv|mp4)$/ $name $&/" $(ls -d $HOME/Videos/wf-recorder/* -t | head -n1)
fi
