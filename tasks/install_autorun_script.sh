#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install script to user autorun

#source "${work_dir}tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

#TODO create directory for install scripts
mkdir -pv "${install_dir}";

#TODO copy scripts to install directory
#cp --dereference --update --verbose --recursive --strip-trailing-slashes "${work_dir}" --target-directory="${install_dir}";
rsync --verbose --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --delete-after --ignore-errors --exclude='.git' --exclude='.git*' --human-readable  --info=progress2 --progress --stats --itemize-changes "${work_dir}/" "${install_dir}/";

#TODO add variables to 'autorun/load_variables.sh'
load_variables_file="${install_dir}/autorun/load_variables.sh";

show_var load_variables_file

#it will look like this "declare -g -x root_pass=$(echo 'Z2Ftb25lZml2YQ=='  | openssl base64 -d ); export root_pass;"
#root_pass
save_var_in_base64 root_pass "$( get_var "${secrets}_${computer_name}_root_pass" )" \
>> "${load_variables_file}";
#_user_i_pass
save_var_in_base64 user_i_pass "$( get_var "${secrets}_${computer_name}_user_i_pass" )" \
>> "${load_variables_file}";
#DISPLAY
save_var_in_base64 DISPLAY "$DISPLAY" \
>> "${load_variables_file}";

echo -e "\n\n";

#TODO add script to crontab or systemd for user i
#TODO add script to crontab or systemd for root
#TODO run script in graphical environment on target computer


#TODO
set -x

#augeas_file="${work_dir}/tasks/${script_base_name}.txt";
#show_var "augeas_file"

#https://augeas.net/docs/references/1.4.0/lenses/files/sshd-aug.html

#https://www.opennet.ru/man.shtml?topic=sshd_config&category=5&russian=0

#are_you_serious=' --new --root="/dev/shm/augeas-sandbox" '; #kind of dry run mode
#are_you_serious=' --root=/ '; #real business

#augtool ${are_you_serious} --timing --echo --backup --autosave --file "${augeas_file}";

exit 0;

