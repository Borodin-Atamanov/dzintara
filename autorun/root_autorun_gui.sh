#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode after GUI starts. If no GUI in computer - this script will never run

#load variables
source "/home/i/bin/dzintara/autorun/load_variables.sh"
declare -x -g service_name='dzintara.root_autorun_gui';   #for slog systemd logs

slog "<5>start"

bash="$( get_command_fullpath bash )";
numlockx="$( get_command_fullpath numlockx )";
xset="$( get_command_fullpath xset )";
setxkbmap="$( get_command_fullpath setxkbmap )";
gxkb="$( get_command_fullpath gxkb )";
nohup="$( get_command_fullpath nohup )";
compton="$( get_command_fullpath compton )";

$nohup $bash -c "${source_load_variables}; while : ; do $compton --config $compton_config_file --backend glx --paint-on-overlay --vsync opengl-swc --shadow-radius=5 --menu-opacity=0.87 --no-dock-shadow --inactive-opacity=0.87 --frame-opacity=0.84; sleep $timeout_2; done; " &

$nohup $bash -c "${source_load_variables}; while : ; do sleep $timeout_1; timeout --kill-after=$timeout_2 $timeout_5 $gxkb; done; " &

$nohup $bash -c "${source_load_variables}; while : ; do sleep $timeout_1; ${xselection_archivist_script_file}; done; " &

# sleep $timeout_1

$nohup $numlockx on &

$nohup $xset led 3 &

$nohup $setxkbmap -layout "us,ru" -option "" -option "grp:shift_caps_switch" -option "grp_led:scroll" -option "grp_led:caps" -option "compose:sclk" &

$nohup  /home/i/bin/dzintara/autorun/x11vnc_autorun.sh &

# random_wait

slog "<5>finish $0"
