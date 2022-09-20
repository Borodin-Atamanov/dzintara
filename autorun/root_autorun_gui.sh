#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode after GUI starts. If no GUI in computer - this script will never run

#load variables
source '/home/i/bin/dzintara/autorun/load_variables.sh'
declare -x -g service_name='dzintara.root_autorun_gui';   #for slog systemd logs

slog '<5>start'

run_background_command_with_logs compton '--config $compton_config_file'
# $nohup $bash -c '${source_load_variables}; while : ; do $compton --config $compton_config_file; sleep $timeout_2; done; > ${dzintara_log_dir}compton.log >>file1 2>>file2 ' &
sleep $timeout_0

run_background_command_with_logs gxkb
#$nohup $bash -c '${source_load_variables}; while : ; do sleep $timeout_1; timeout --kill-after=$timeout_2 $timeout_5 $gxkb; done; ' &
sleep $timeout_0

run_background_command_with_logs "${xselection_archivist_script_file}"
#$nohup $bash -c '${source_load_variables}; while : ; do sleep $timeout_1; ${xselection_archivist_script_file}; done; ' &
sleep $timeout_0

# sleep $timeout_1

run_background_command_with_logs numlockx on
sleep $timeout_0

run_background_command_with_logs xset 'led 3'
sleep $timeout_0

run_background_command_with_logs setxkbmap " -layout 'us,ru' -option '' -option 'grp:shift_caps_switch' -option 'grp_led:scroll' -option 'grp_led:caps' -option 'compose:sclk' "
sleep $timeout_0

run_background_command_with_logs x11vnc " -6 -reopen -scale 0.75 -shared -forever -loop7777 -capslock -clear_all -fixscreen V=111,C=121,X=137 -ping 1 -rfbauth /root/.vnc/passwd "
sleep $timeout_0

# random_wait

slog '<5>finish $0'
