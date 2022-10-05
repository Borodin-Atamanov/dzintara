#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode after GUI starts. If no GUI in computer - this script will never run

#load variables
source '/home/i/bin/dzintara/autorun/load_variables.sh'
declare -x -g service_name='dzintara.root_autorun_gui';   #for slog systemd logs

slog '<5>start'

start_log

echo -e "\n\n"

run_counts="$timeout_5"
run_background_command_with_logs compton '--config $compton_config_file'
echo -e "\n\n"

run_counts="$timeout_5"
run_background_command_with_logs $xselection_archivist_script_file
echo -e "\n\n"

run_counts="$timeout_5"
run_background_command_with_logs $wmctrl_archivist_script_file
echo -e "\n\n"

run_counts="$timeout_5"
run_sleep="$timeout_1"
run_background_command_with_logs numlockx on
echo -e "\n\n"

run_counts="$timeout_1"
run_sleep="$timeout_4"
run_background_command_with_logs xset 'led 3'
echo -e "\n\n"

run_counts="$timeout_5"
run_background_command_with_logs gxkb
echo -e "\n\n"

run_counts=2
run_sleep="$timeout_2"
run_background_command_with_logs setxkbmap " -layout 'us,ru' -option '' -option 'grp:shift_caps_switch' -option 'grp_led:scroll' -option 'grp_led:caps' -option 'compose:sclk' "
echo -e "\n\n"

run_counts="$timeout_2"
run_sleep="$timeout_2"
run_background_command_with_logs x11vnc " -6 -reopen -scale 0.75 -shared -forever -loop7777 -capslock -clear_all -fixscreen V=111,C=121,X=137 -ping 1 -rfbauth /root/.vnc/passwd "
echo -e "\n\n"

# run_sleep="$timeout_2"
# run_background_command_with_logs unclutter " -idle 17 "
# echo -e "\n\n"



# random_wait

slog '<5>finish $0'
