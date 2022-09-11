#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
source "${work_dir}tasks/1.sh"

var_name="${root_vault_preffix}hostname";
show_var "$var_name"
sleep $timeout_0

#echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd i

if [ ! -z "$var_name" ] ; then
    echo -e "$( get_var "${var_name}" )\n" | tee /etc/hostname
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
