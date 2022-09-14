#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun x11vnc

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzintara.x11vnc';   #for slog systemd logs

#start plus root script
declare_and_export fullpath_bash "$( get_command_fullpath bash )";
#declare_and_export fullpath_terminal_gui_app "$( get_command_fullpath rxvt )";
#declare_and_export fullpath_nohup "$( get_command_fullpath nohup )";

swapon="$( get_command_fullpath swapon )";
swapoff="$( get_command_fullpath swapoff )";
fallocate="$( get_command_fullpath fallocate )";
mkswap="$( get_command_fullpath mkswap )";
chmod="$( get_command_fullpath chmod )";
free="$( get_command_fullpath free )";
bash="$( get_command_fullpath bash )";

#Get total RAM size:
ram_size_in_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo);
show_var ram_size_in_kb
#swap_from_ram_size=$(awkcalc "${ram_size_in_kb}*${swap_max_ram_percents} / 100");
show_var swap_max_ram_percents
swap_from_ram_size=$(( ram_size_in_kb * swap_max_ram_percents / 100 ))
show_var swap_from_ram_size
#echo "mem_size_in_kb = ${mem_size_in_kb}"

free_disk_space_in_kb=$(df -k --local --block-size=1K --output=avail / | tr -d '\n' | sed 's/[^[:digit:]]\+//g')
#free_disk_space_in_kb=1688152
show_var free_disk_space_in_kb
swap_from_free_disk_space=$(( free_disk_space_in_kb * swap_max_disk_free_space_percents / 100 ))
show_var swap_from_free_disk_space

# target swap size is the minimum of this two integers
swap_size_kb=$( min "$swap_from_free_disk_space" "$swap_from_ram_size" )
show_var swap_size_kb

#Calculate new swap size
#swap_size_kb=$(awkcalc ${ram_size_in_kb}+1024*1024*3);
#show_var swap_size_kb

$swapoff -v "${swap_file_path}"
$swapoff --all
sleep $timeout_0
$free -k
sleep $timeout_0
rm -v "${swap_file_path}"
sleep $timeout_0
$swapon --verbose --show
sleep $timeout_0
$fallocate -l ${swap_size_kb}K "${swap_file_path}"
sleep $timeout_0
chmod -v 0600 "${swap_file_path}"
sleep $timeout_0
$mkswap --label swaproot "${swap_file_path}"
sleep $timeout_0
$swapon --verbose --fixpgsz --priority 42 "${swap_file_path}"
sleep $timeout_0
$swapon --verbose --show
sleep $timeout_0
$free -k
sleep $timeout_0

exit 0;
#swapoff -a
#fallocate -l 300m swapfile
#shred --random-source=/dev/zero --iterations=1 --verbose swapfile

#crontab -l
#@reboot sleep 120 && /home/i/bin/swap-start.sh >> /home/i/bin/logs/swap-start.log 2>&1

#slog "<7>eval this  '${eval_this}'"
#eval "${eval_this}";

