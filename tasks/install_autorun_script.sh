#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install script to user autorun

#source "${work_dir}tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

root_autorun_service_file='/etc/systemd/system/dzible_autorun.service';
load_variables_file="${install_dir}autorun/load_variables.sh";
root_autorun_file="${install_dir}autorun/root_autorun.sh";

#create directory for install scripts
mkdir -pv "${install_dir}";

#TODO copy scripts to install directory
#cp --dereference --update --verbose --recursive --strip-trailing-slashes "${work_dir}" --target-directory="${install_dir}";
rsync --verbose --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --delete-after --ignore-errors --exclude='.git' --exclude='.git*' --human-readable  --info=progress2 --progress --stats --itemize-changes "${work_dir}/" "${install_dir}/";

show_var load_variables_file

#add variables to 'autorun/load_variables.sh'
#it will look like this "declare -g -x root_pass=$(echo 'Z2Ftb25lZml2YQ=='  | openssl base64 -d ); export root_pass;"
#root_pass
#save_var_in_base64 root_pass "$( get_var "${secrets}_${computer_name}_root_pass" )" >> "${load_variables_file}";

#_user_i_pass
#save_var_in_base64 user_i_pass "$( get_var "${secrets}_${computer_name}_user_i_pass" )" >> "${load_variables_file}";

save_var_in_base64 script_subversion "$( get_var "script_subversion" )" >> "${load_variables_file}";
echo 'echo "$script_subversion"; ' >> "${load_variables_file}";

#if not set DISPLAY - save default value
if [[ "${DISPLAY}" = "" ]]; then
  declare_and_export DISPLAY ":0"
fi

save_var_in_base64 DISPLAY "$DISPLAY" >> "${load_variables_file}";

echo "cd '${install_dir}';" >> "${load_variables_file}";

echo -e "\n\n";

chown --verbose --changes --recursive  root:root "${install_dir}";
find "${install_dir}" -type d -exec chmod --verbose 0755 {} \;
find "${install_dir}" -type f -exec chmod --verbose 0755 {} \;

apt-get install -y stterm

#start cron on system start
#systemctl enable cron

#add script as autorun service to systemd for root
#create systemd service autorun unit file
echo -n "" > "${root_autorun_service_file}";
echo '[Unit]' \
>> "${root_autorun_service_file}";
echo 'Description=dzible autorun service' \
>> "${root_autorun_service_file}";
echo '[Service]' \
>> "${root_autorun_service_file}";
echo "ExecStart=${root_autorun_file}" \
>> "${root_autorun_service_file}";
echo '[Install]' \
>> "${root_autorun_service_file}";
echo 'WantedBy=multi-user.target' \
>> "${root_autorun_service_file}";

systemctl daemon-reload | tac
systemctl status dzible_autorun | tac
# systemctl start dzible_autorun
systemctl enable dzible_autorun | tac
systemctl status dzible_autorun | tac

#TODO

#augeas_file="${work_dir}/tasks/${script_base_name}.txt";
#show_var "augeas_file"

#https://augeas.net/docs/references/1.4.0/lenses/files/sshd-aug.html

#https://www.opennet.ru/man.shtml?topic=sshd_config&category=5&russian=0

#are_you_serious=' --new --root="/dev/shm/augeas-sandbox" '; #kind of dry run mode
#are_you_serious=' --root=/ '; #real business

#augtool ${are_you_serious} --timing --echo --backup --autosave --file "${augeas_file}";
