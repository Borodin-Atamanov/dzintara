#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install script to user autorun

source "${work_dir}tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

#TODO create directory for install scripts

#TODO copy scripts to install directory
#TODO add script to crontab or systemd for user i
#TODO add script to crontab or systemd for root
#TODO run script in graphical environment on target computer
#TODO
#TODO

#access control disabled, clients can connect from any host
xhost +

#augeas_file="${work_dir}/tasks/${script_base_name}.txt";
#show_var "augeas_file"

#https://augeas.net/docs/references/1.4.0/lenses/files/sshd-aug.html

#https://www.opennet.ru/man.shtml?topic=sshd_config&category=5&russian=0

#are_you_serious=' --new --root="/dev/shm/augeas-sandbox" '; #kind of dry run mode
#are_you_serious=' --root=/ '; #real business

#augtool ${are_you_serious} --timing --echo --backup --autosave --file "${augeas_file}";

exit 0;

