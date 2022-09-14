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
nproc="$( get_command_fullpath nproc )";
nproc_int="$( $nproc )" # get CPUs numbers

#Get total RAM size:
ram_size_in_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo);
show_var ram_size_in_kb
#swap_from_ram_size=$(awkcalc "${ram_size_in_kb}*${swap_max_ram_percents} / 100");
show_var swap_max_ram_percents
swap_from_ram_size=$(( ram_size_in_kb * swap_max_ram_percents / 100 ))
show_var swap_from_ram_size
#echo "mem_size_in_kb = ${mem_size_in_kb}"
zram_from_ram_size=$(( ram_size_in_kb * zram_in_ram_percents / 100 ))
show_var zram_from_ram_size
zram_per_core_in_bytes=$(( zram_from_ram_size * 1024 / nproc_int))
show_var zram_per_core_in_kb

free_disk_space_in_kb=$(df -k --local --block-size=1K --output=avail / | tr -d '\n' | sed 's/[^[:digit:]]\+//g')
#free_disk_space_in_kb=1688152
show_var free_disk_space_in_kb
swap_from_free_disk_space=$(( free_disk_space_in_kb * swap_max_disk_free_space_percents / 100 ))
show_var swap_from_free_disk_space

# target swap size is the minimum of this two integers
swap_size_kb=$( min "$swap_from_free_disk_space" "$swap_from_ram_size" )
show_var swap_size_kb

sleep $timeout_0

#Calculate new swap size
#swap_size_kb=$(awkcalc ${ram_size_in_kb}+1024*1024*3);
#show_var swap_size_kb

set -x
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

# setup zram

fname='/etc/default/zramswap'
set +x
load_var_from_file "$fname" config_al2f
#show_var changed fname
#echo "$config_al2f"

# all supported compression algorithms here:       cat /sys/block/zram0/comp_algorithm
# speed: lz4 > zstd > lzo
# compression: zstd > lzo > lz4
config_al2f=$( replace_line_by_string "$config_al2f" "ALGO="  "ALGO=${zram_algo}" "#" )
#add_line_to_file '/etc/default/zramswap' "ALGO=${zram_algo}"

#amount of RAM that should be used for zram
#add_line_to_file '/etc/default/zramswap' "PERCENT=${zram_in_ram_percents}"
config_al2f=$( replace_line_by_string "$config_al2f"  "PERCENT=" "PERCENT=${zram_in_ram_percents}" "#" )

save_var_to_file "$fname" config_al2f

cat $fname

set -x

modprobe zram num_devices=${nproc_int}

#set paramaters for every block of zram
for ((zr=$nproc_int;zr>=0;zr--)); do
    #echo -ne "${backspaces}${i}  ";
    sleep "${timeout_0}";
    echo $zram_per_core_in_bytes >  "/sys/block/zram${zr}/disksize"
    #/sys/block/zram0/comp_algorithm
    $mkswap "/dev/zram${zr}"
    $swapon "/dev/zram${zr}" -p 146
done;

# mkswap /dev/zram0
# mkswap /dev/zram1
# mkswap /dev/zram2
# mkswap /dev/zram3
#
# swapon /dev/zram0 -p 10
# swapon /dev/zram1 -p 10
# swapon /dev/zram2 -p 10
# swapon /dev/zram3 -p 10

set +x

exit 0;
#zramctl --reset --algorithm zstd --streams $nproc_int
# cat /usr/sbin/zramswap


#Specifies the priority for the swap devices, see swapon(2)
#This should probably be higher than hdd/ssd swaps.add_line_to_file '/etc/default/zramswap' 'PRIORITY=146'

#swapoff -a
#fallocate -l 300m swapfile
#shred --random-source=/dev/zero --iterations=1 --verbose swapfile

#crontab -l
#@reboot sleep 120 && /home/i/bin/swap-start.sh >> /home/i/bin/logs/swap-start.log 2>&1

#slog "<7>eval this  '${eval_this}'"
#eval "${eval_this}";

