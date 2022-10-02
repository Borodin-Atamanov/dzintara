#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script adds invert flag to active window name
# This used for minimize all windows

source "/home/i/bin/dzintara/autorun/load_variables.sh"
#declare_and_export work_dir "/home/i/bin/dzintara/"
# TODO loop while 1200 milliseconds
for i in {1..50}; do WID=$(xdotool getactivewindow); echo $WID; xdotool windowminimize $WID; sleep 0.015; done;
