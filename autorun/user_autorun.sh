#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode
work_dir="$(realpath "$0")";
work_dir="$(dirname "${work_dir}")";
export work_dir
#declare_and_export work_dir
#work_dir="/home/i/bin/dzible/autorun";

#access control disabled, clients can connect from any host
xhost +


echo "$work_dir";
