#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode
source "/home/i/bin/dzible/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzible/"

#access control disabled, clients can connect from any host
# xhost +

#if you need sudo su as root, you can do the following
#echo secret_root_password | sudo -S echo -n 2>/dev/random 1>/dev/random

echo "$work_dir";

xset led 3;

cvt_xrandr 1280 1024 60

cvt_xrandr 1920 1080 60

for ((i=142;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 0.42; done;

#read

#sleep 35;
