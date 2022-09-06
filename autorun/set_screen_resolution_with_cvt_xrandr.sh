#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun x11vnc

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
#source "/home/i/bin/dzible/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzible.autorun';   #for slog systemd logs

#start plus root script
whoami="$(whoami)"
slog "<7>start X11 settings update script"

cvt_xrandr 1920 1080 60
cvt_xrandr 1360 768 60
cvt_xrandr 1280 1024 60

if [ is_root ]; then
    #run only from root
    install_system autorandr
fi

autorandr --debug  --force --save "itworks"
autorandr --debug --force --default "itworks"

