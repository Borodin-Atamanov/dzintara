#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun from systemd when network connects.

#This script calls another scripts

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzible.root_autorun_network';   #for slog systemd logs

#path to scripts, what we will start
start_1_file="${work_dir_autorun}root_autorun_on_network_connect_telemetry_send.sh"

declare_and_export fullpath_bash "$( get_command_fullpath bash )";
declare_and_export fullpath_nohup "$( get_command_fullpath nohup )";

#start plus root script
slog "<5>start root console script after network connect. It will start other scripts."
slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"

eval_this="su --login root --shell='${fullpath_bash}' --command='${source_load_variables}; ${fullpath_nohup} ${start_1_file} & ' ";
slog "<7>eval this '${eval_this}'"
eval "${eval_this}";

#slog "<5>finish $0"
