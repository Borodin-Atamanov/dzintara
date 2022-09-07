#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun x11vnc

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
#source "/home/i/bin/dzible/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzible.pipes_autorun';   #for slog systemd logs

#start plus root script
user_id="$(id)"
slog "<7>dzible read from pipe and execute ${user_id}"

if [ is_root ]; then
    fifo_path="${run_command_from_root_pipe_file}"
else
    fifo_path="${run_command_from_user_i_pipe_file}"
fi;
slog "<7>fifo_path=${fifo_path}"

rm -v "$fifo_path"
mkfifo "$fifo_path"
#stat "$fifo_path"

for ((i=0;i<32777;i++))
{
    #read commands from fifo
    command="$(cat "$fifo_path")";
    slog "<7>${i}-command=${command}"
    #execute command
    nohup /bin/bash -c -- "${command}" &
    #sleep .02;
}

exit 0
