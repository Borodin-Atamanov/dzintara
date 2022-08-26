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


echo "$work_dir" | tee -a "${work_dir}autorun/logs.root";



