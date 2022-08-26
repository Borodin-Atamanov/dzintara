#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode

source "/home/i/bin/dzible/index.sh" fun
declare_and_export work_dir "/home/i/bin/dzible/"
#load variables
source "${work_dir}autorun/load_variables.sh"

#declare_and_export work_dir
#work_dir="/home/i/bin/dzible/autorun";

#access control disabled, clients can connect from any host
#xhost +

#for ((i=12;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;

#wait untill x server starts (or if waiting time is over)
echo "wait for X" >> "${work_dir}autorun/logs.root";
date >> "${work_dir}autorun/logs.root";


wait_for 133 'is_process_running Xorg'

cvt_xrandr 1280 1024 60

su i --preserve-environment --pty --command "source /home/i/bin/dzible/autorun/load_variables.sh; time chromium-browser; ";

echo "X is here!" >> "${work_dir}autorun/logs.root";
date >> "${work_dir}autorun/logs.root";

#TODO run user_autorun.sh script in graphical environment on target computer


