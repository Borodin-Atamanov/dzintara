#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode, before GUI starts.

source "/home/i/bin/dzible/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzible/"

#access control disabled, clients can connect from any host
# xhost +

#if you need sudo su as root, you can do the following
#echo secret_root_password | sudo -S echo -n 2>/dev/random 1>/dev/random

{ ymdhms; echo "run $0"; } | tee --append "${logs}";
show_var EUID
whoami="$(get_command_fullpath whoami)"
show_var whoami
countdown 250 0.1
{ ymdhms; echo "end $0"; } | tee --append "${logs}";


#read

#sleep 35;
