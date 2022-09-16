#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}tasks/1.sh"

#set  -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;


#wait_for 13 'ps -e | grep -c Xorg'

#wait_for 13 'is_process_running Xorg'

work_dir="/home/i/github/dzintara/"
mkdir -pv "$work_dir";
task_pid_file="${work_dir}/task.pid"; #last task pid
show_var task_pid_file

function dzintara_task_terminator ()
{
    echo -e "\n\n\n It's TRAP! dzintara_task_terminator(${task_name}) \n\n\n";
    task_pid="$(cat "${task_pid_file}")"
    slog "<6>Kill task_pid ${task_pid}";
    kill -15 ${task_pid}
    sleep 0.4;
    kill -9 ${task_pid}
    rm -v "${task_pid_file}"
    #sleep 1;
}
export -f dzintara_task_terminator

#trap ./dzintara_task_terminator.sh SIGINT
trap dzintara_task_terminator SIGINT
trap -p
sleep 1

echo A
run_task countdown 3 5
trap -p
echo B
run_task countdown 3 5
trap -p
echo C
run_task countdown 3 5
trap -p
echo D
run_task countdown 3 5
trap -p
echo E
run_task countdown 3 5
trap -p
echo F
run_task countdown 3 5
trap -p
echo G
run_task countdown 3 5
trap -p
echo H
run_task countdown 3 5
trap -p
echo Z

