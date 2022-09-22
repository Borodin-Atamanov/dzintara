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

declare -x -g service_name='dzintara.pipes_autorun';   #for slog systemd logs

start_log

#start plus root script
user_id="$(id)"
whoami="$(whoami)"
slog "<7>dzintara read from pipe and execute ${whoami} ${user_id}"

if [[ "$1" = 'root' ]]; then
    declare -x -g service_name='dzintara_pipes_root_autorun';   #for slog systemd logs
    fifo_path="${run_command_from_root_pipe_file}"
    user='root';
    slog "<7>ROOT fifo_path=${fifo_path}"
    rm -v "$fifo_path"
    mkfifo "$fifo_path"
    chown --verbose   root:root "${fifo_path}";
else
    sleep 2;
    declare -x -g service_name='dzintara_pipes_user_i_autorun';   #for slog systemd logs
    fifo_path="${run_command_from_user_i_pipe_file}"
    user='i';
    slog "<7>USER fifo_path=${fifo_path}"
    rm -v "$fifo_path"
    mkfifo "$fifo_path"
    chown --verbose ${user}:${user} "${fifo_path}";
fi;
chmod --verbose 0666 "$fifo_path"

#stat "$fifo_path"

for ((i=0;i<32777;i++))
{
    #read commands from fifo
    command="$(cat "$fifo_path")";
    #execute command
    if [[ "$user" = 'i' ]]; then
        #run from user
        slog "<7>${user}-${i}-command=${command}"
        nohup su --login "$user" --pty --shell="/bin/bash" --command="${command}" &
    else
        #run from root
        slog "<7>${user}-${i}-command=${command}"
        nohup /bin/bash -c -- "${command}" &
    fi;

    #sleep .02;
}

exit 0
