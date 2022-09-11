#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install and setup

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

install_system x11vnc

#systemctl stop x11vnc | cat
#sleep 1;

vnc_password=$( get_var "${root_vault_preffix}vnc_password" )
show_var vnc_password
#x11vnc -storepasswd "$vnc_password" /root/.vnc/passwd
x11vnc -storepasswd "$vnc_password" '/root/.vnc/passwd'

exit 0;
