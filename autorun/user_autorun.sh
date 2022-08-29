#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode, before GUI starts.

source "/home/i/bin/dzible/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzible/"
declare -x -g service_name='dzible.user_autorun';   #for slog systemd logs

#access control disabled, clients can connect from any host
# xhost +

#if you need sudo su as root, you can do the following
#echo secret_root_password | sudo -S echo -n 2>/dev/random 1>/dev/random

slog "<7>start"
slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"
slog "<7>end"


#read

#sleep 35;
