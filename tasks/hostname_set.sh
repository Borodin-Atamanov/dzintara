#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
source "${work_dir}tasks/1.sh"

var_name="${root_vault_preffix}hostname";
show_var "$var_name"
sleep $timeout_0

#echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd i
echo -e "$( get_var "${var_name}" )\n" | tee /etc/hostname
#echo /etc/hostname
#passwd --status  --all
sleep $timeout_0
hostname --all-ip-addresses
sleep $timeout_0
hostname --all-fqdns
sleep $timeout_0
#hostname SET "i-desktop"
