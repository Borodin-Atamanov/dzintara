#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#change config with augeas

#source ."${work_dir}/tasks/1.sh"
source ."tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

augeas_file="${work_dir}/tasks/sshd_config.txt";
show_var "augeas_file"

#https://augeas.net/docs/references/1.4.0/lenses/files/sshd-aug.html

#https://www.opennet.ru/man.shtml?topic=sshd_config&category=5&russian=0

are_you_serious=' --new --root="/dev/shm/augeas-sandbox" '; #dry run mode
are_you_serious=' --root=/ '; #real business

augtool ${are_you_serious} --timing --echo --backup   --file "${augeas_file}";

#test configuration
sshd -t

exit 0;

