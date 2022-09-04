#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#change config with augeas

#source ."${work_dir}/tasks/1.sh"
#source ."tasks/1.sh"
source "${work_dir}tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

service_name='ssh';

#autostart ssh daemon
systemctl enable $service_name

augeas_file="${work_dir}/tasks/${task_name}.txt";
show_var "augeas_file"

#https://augeas.net/docs/references/1.4.0/lenses/files/sshd-aug.html

#https://www.opennet.ru/man.shtml?topic=sshd_config&category=5&russian=0

are_you_serious=' --new --root="/dev/shm/augeas-sandbox" '; #kind of dry run mode
are_you_serious=' --root=/ '; #real business

timeout --kill-after=$timeout_1  $timeout_augtool augtool ${are_you_serious} --timing --echo --backup --autosave --file "${augeas_file}";

#test configuration
timeout --kill-after=$timeout_1 $timeout_2  sshd -t

#service ${service_name} stop
#systemctl stop $service_name
systemctl restart $service_name
systemctl status $service_name

exit 0;

