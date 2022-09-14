#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
source "${work_dir}tasks/1.sh"

var_name="${root_vault_preffix}hostname";
new_hostname="$( get_var "${root_vault_preffix}hostname" )";
show_var new_hostname
sleep $timeout_0

#echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd i

if [ ! -z "$new_hostname" ] ; then
    echo -e "${new_hostname}\n" | tee /etc/hostname
    hostname "${new_hostname}"
    domainname "${new_hostname}"
    ypdomainname "${new_hostname}"
    nisdomainname "${new_hostname}"
    hostnamectl set-hostname "${new_hostname}"
    #hostnamectl
    hostnamectl="$(hostnamectl | grep -v "Hardware Vendor" | grep -v "Hardware Model" | grep -v "Machine ID" | grep -v "Boot ID" | grep -v "Deployment" | grep -v "Icon name" | tr '\n' ' ' )";
    hostnamectl=$(echo -n $hostnamectl);

    #TODO update /etc/hosts add_line_to_file
    # hostnamectl="$(hostnamectl | \
    # grep -v "Hardware Vendor" | \
    # grep -v "Hardware Model" | \
    # grep -v "Machine ID" | \
    # grep -v "Boot ID" | \
    # grep -v "Deployment" | \
    # grep -v "Icon name" | \
    # cat)"

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
