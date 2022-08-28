#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode after GUI starts. It will never starts in pure console computers, f.e. servers
source "/home/i/bin/dzible/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzible/"
declare -x -g service_name='dzible.user_autorun_gui';   #for slog systemd logs

#access control disabled, clients can connect from any host
# xhost +

#if you need sudo su as root, you can do the following
#echo secret_root_password | sudo -S echo -n 2>/dev/random 1>/dev/random


slog "<7>start"
slog "<7>$(show_var EUID)":
whoami="$(whoami)"
slog "<7>$(show_var whoami)":
xset led 3;
slog "<7>end1"



#export


countdown 250 0.1

run_task show_script_subversion
#run_task add_screen_resolution_with_cvt_xrandr

#cvt_xrandr 1280 1024 60

#cvt_xrandr 1920 1080 60
cvt_xrandr 1360 768 60

run_task countdown 555 0.1
run_task sleep 15

#read

sleep 35;

slog "<5>end2"
