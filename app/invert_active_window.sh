#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script adds invert flag to active window name
# This used for invert window with compton composite manager and LXDE | LXQt keybindings

source "/home/i/bin/dzintara/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzintara/"

window_id=$(xdotool getactivewindow)
window_name=$(xdotool getwindowname $window_id)
invert_flag=' INVERT by dev@Borodin-Atamanov.ru '
regex="(.*)${invert_flag}$"

if  [[ "$window_name" =~ $regex ]]; then
    xdotool set_window --name "${BASH_REMATCH[1]}" $window_id
else
    xdotool set_window --name "${window_name}${invert_flag}" $window_id
fi

# add to compton's config:
# invert-color-include = [
#     "name ~= '<inverted>$'"
# ];
