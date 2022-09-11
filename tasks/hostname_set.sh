#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
source "${work_dir}tasks/1.sh"

var_name="${root_vault_preffix}hostname";
new_hostname="$( get_var "${var_name}" )";
show_var new_hostname
sleep $timeout_0

#echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd i

if [ ! -z "$new_hostname" ] ; then
    echo -e "${new_hostname}\n" | tee /etc/hostname
    #echo /etc/hostname
    #passwd --status  --all
    #hostname SET "i-desktop"
else
    >&2 echo 'hostname is empty!'
    sleep $timeout_1
fi
sleep $timeout_0
hostname --all-ip-addresses
sleep $timeout_0
hostname --all-fqdns
sleep $timeout_0
