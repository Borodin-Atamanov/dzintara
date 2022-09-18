#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script adds invert flag to active window name
# This used for invert window with compton composite manager and LXDE | LXQt keybindings

#source "/home/i/bin/dzintara/autorun/load_variables.sh"
#declare_and_export work_dir "/home/i/bin/dzintara/"

# window_name=$(xdotool getwindowname $(xdotool getactivewindow) )
window_id=$(xdotool getactivewindow)
window_name=$(xdotool getwindowname $window_id)
invert_flag=' 31337'
regex="(.*)${invert_flag}$"
# TODO add toggle icon name, not only title of the window

# convert integer window id to 0xHEX format window id
hex_window_id="0x$(echo "obase=16; ${window_id}" | bc)"
#show_var hex_window_id

# get X11 window property of active window
TAG_INVERT="$(xprop -id "$hex_window_id" 8c TAG_INVERT | cut -d " " -f 3)";
[[ "$TAG_INVERT" = "0" ]] && status=0 || status=1;
# set X11 window property to this window
xprop -id "$hex_window_id" -format TAG_INVERT 8c -set TAG_INVERT "$status"

echo "hex_window_id=$hex_window_id window_id=$window_id TAG_INVERT='$TAG_INVERT"

exit

if  [[ "$window_name" =~ $regex ]]; then
    # window wal already inverted. Revert its previous title
    xdotool set_window --name "${BASH_REMATCH[1]}" $window_id
else
    xdotool set_window --name "${window_name}${invert_flag}" $window_id
    #xdotool set_window --icon-name "${invert_flag}" $window_id
    #xdotool set_window --urgency 1 $window_id
    # WM_ICON_NAME
fi

#window="$(bspc query -n focused -T | cut -d ',' -f 1 | sed 's/\{"id"://g')";


# add to compton's config:
# invert-color-include = [
#     "name ~= 'iNvRt$'"
# ];
