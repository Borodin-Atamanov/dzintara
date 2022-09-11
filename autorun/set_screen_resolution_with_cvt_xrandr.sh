#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun x11vnc
sleep 0.1
set -x

date
echo 123

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzintara.autorun';   #for slog systemd logs

#start plus root script
whoami="$(whoami)"
slog "<7>start X11 settings update script"

export

cvt_xrandr 1920 1080 60
cvt_xrandr 1360 768 60
cvt_xrandr 1280 1024 60

#normal
#xrandr --output HDMI-A-1  --mode 3840x2160 --panning 3840x2160 --scale 1x1
#if mode is 0.5 of panning - panning activated
#xrandr --output HDMI-A-1  --mode 3840x2160 --panning 1920x1080 --scale 1x1

if [ is_root ]; then
    #run only from root
    install_system autorandr
fi

autorandr --debug  --force --save "itworks"
autorandr --debug --force --default "itworks"

