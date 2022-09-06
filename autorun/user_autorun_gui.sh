#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode after GUI starts. It will never starts in pure console computers, f.e. servers
source "/home/i/bin/dzible/autorun/load_variables.sh"
declare -x -g service_name='dzible.user_autorun_gui';   #for slog systemd logs

#access control disabled, clients can connect from any host
# xhost +

#if you need sudo su as root, you can do the following
#echo secret_root_password | sudo -S echo -n 2>/dev/random 1>/dev/random

slog "<5>start $0"

slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"

xset led 3;
/usr/bin/numlockx on
nohup setxkbmap -layout "us,ru" &
nohup setxkbmap -option "grp:shift_caps_switch,grp_led:scroll" &
nohup telegram-desktop &

random_wait

run_task show_script_subversion
#run_task add_screen_resolution_with_cvt_xrandr

#cvt_xrandr 1280 1024 60

#cvt_xrandr 1920 1080 60
#cvt_xrandr 1360 768 60

autorandr --debug --change
autorandr --debug --load itworks
autorandr --debug horizontal


#read

slog "<5>finish $0"

