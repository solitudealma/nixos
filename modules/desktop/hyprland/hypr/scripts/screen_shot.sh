#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

ScrDir=`dirname "$(realpath "$0")"`
swpy_dir="${XDG_CONFIG_HOME:-$HOME/.config}/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/screenshots}"
save_file=$(date +'%Y-%m-%d-%H-%M-%S-screenshot.png')
temp_screenshot="$save_dir/$save_file"

mkdir -p $save_dir
mkdir -p $swpy_dir
echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config

function print_error
{
cat << "EOF"
    ./screenshot.sh <action>
    ...valid actions are...
        p : print all screens
        s : snip current screen
        sf : snip current screen (frozen)
        m : print focused monitor
EOF
}

case $1 in
p)  # print all outputs
    grimblast copysave screen $temp_screenshot && swappy -f $temp_screenshot ;;
s)  # drag to manually snip an area / click on a window to print it
    grimblast copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
sf)  # frozen screen, drag to manually snip an area / click on a window to print it
    grimblast --freeze copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
m)  # print focused monitor
    grimblast copysave output $temp_screenshot && swappy -f $temp_screenshot ;;
*)  # invalid option
    print_error ;;
esac

if [ -f "$save_dir/$save_file" ] ; then
    dunstify "t1" -a "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi
