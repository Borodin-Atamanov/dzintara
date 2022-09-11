#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
source "${work_dir}tasks/1.sh"

var_name="${root_vault_preffix}user_i_password";
show_var "$var_name"

if [[ $EUID -ne 0 ]]; then
   echo "Must be run as root! $0"
   exit 1
fi

echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd i

passwd --status  --all
