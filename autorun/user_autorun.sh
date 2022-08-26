#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode
source "/home/i/bin/dzible/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzible/"

#access control disabled, clients can connect from any host
# xhost +

echo "$work_dir";

for ((i=142;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 0.42; done;

sleep 35;
