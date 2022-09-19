#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
# script run on target system in root mode, and log local dns queries

#view logs:
# journalctl --all --follow --priority=7 -t dzintara_telemetry
# tail -f /var/log/syslog | grep dzintara;

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dns archivist dzintara';   #for slog systemd logs
slog "<5>start dns archivist dzintara. It will log dns requests."

