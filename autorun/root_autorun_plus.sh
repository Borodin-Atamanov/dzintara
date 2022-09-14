#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode

#source "/home/i/bin/dzible/autorun/load_variables.sh"
#declare_and_export work_dir "/home/i/bin/dzible/"
declare -x -g service_name='dzible.root_autorun_plus';   #for slog systemd logs

#access control disabled, clients can connect from any host
# xhost +

#if you need sudo su as root, you can do the following
#echo secret_root_password | sudo -S echo -n 2>/dev/random 1>/dev/random

slog "<5>start"
#slog "<7>$(show_var EUID)"
#whoami="$(whoami)"
#slog "<7>$(show_var whoami)"

#swap_autorun.sh

( /home/i/bin/dzintara/autorun/swap_autorun.sh )

slog "<7>end"

random_wait

slog "<5>finish $0"
