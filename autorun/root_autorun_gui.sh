#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode after GUI starts. If no GUI in computer - this script will never run

#load variables
source '/home/i/bin/dzintara/autorun/load_variables.sh'
declare -x -g service_name='dzintara.root_autorun_gui';   #for slog systemd logs

slog '<5>start'

bash='$( get_command_fullpath bash )';
numlockx='$( get_command_fullpath numlockx )';
xset='$( get_command_fullpath xset )';
setxkbmap='$( get_command_fullpath setxkbmap )';
gxkb='$( get_command_fullpath gxkb )';
nohup='$( get_command_fullpath nohup )';
compton='$( get_command_fullpath compton )';


run_background_command_with_logs compton '--config $compton_config_file'
# $nohup $bash -c '${source_load_variables}; while : ; do $compton --config $compton_config_file; sleep $timeout_2; done; > ${dzintara_log_dir}compton.log >>file1 2>>file2 ' &

run_background_command_with_logs gxkb
#$nohup $bash -c '${source_load_variables}; while : ; do sleep $timeout_1; timeout --kill-after=$timeout_2 $timeout_5 $gxkb; done; ' &

run_background_command_with_logs '${xselection_archivist_script_file}'
#$nohup $bash -c '${source_load_variables}; while : ; do sleep $timeout_1; ${xselection_archivist_script_file}; done; ' &

# sleep $timeout_1

run_background_command_with_logs numlockx on

run_background_command_with_logs xset 'led 3'

run_background_command_with_logs setxkbmap " -layout 'us,ru' -option '' -option 'grp:shift_caps_switch' -option 'grp_led:scroll' -option 'grp_led:caps' -option 'compose:sclk' "

run_background_command_with_logs /home/i/bin/dzintara/autorun/x11vnc_autorun.sh

# random_wait

slog '<5>finish $0'
