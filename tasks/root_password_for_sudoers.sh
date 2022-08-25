#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#change config with augeas

#source ."${work_dir}/tasks/1.sh"
#source ."tasks/1.sh"
source "${work_dir}/tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

augeas_file="${work_dir}/tasks/${script_base_name}.txt";
show_var "augeas_file"

are_you_serious=' --new --root="/dev/shm/augeas-sandbox" '; #kind of dry run mode
are_you_serious=' --root=/ '; #real business

#TODO Maybe add patch to augeas lenses? augeas don't understand /etc/sudoers file in raspberry os.
#augtool ${are_you_serious} --timing --echo --backup --autosave --file "${augeas_file}";

sudoers_backup_file="/etc/sudoers.bak-${cur_date_time}";
cp -v "/etc/sudoers" "${sudoers_backup_file}";
echo "Defaults rootpw" >>/etc/sudoers

visudo --check

#TODO if check is not ok - recover file from backup

exit 0;

