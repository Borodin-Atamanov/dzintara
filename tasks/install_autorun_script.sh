#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install 4 scripts to autorun on target system

#source "${work_dir}tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

root_autorun_service_file='/etc/systemd/system/dzible.service';
load_variables_file="${install_dir}autorun/load_variables.sh";
root_autorun_file="${install_dir}autorun/root_autorun.sh";

#create directory for install scripts
mkdir -pv "${install_dir}";

#copy scripts to install directory
#cp --dereference --update --verbose --recursive --strip-trailing-slashes "${work_dir}" --target-directory="${install_dir}";
rsync --verbose --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --delete-after --ignore-errors --exclude='.git' --exclude='.git*' --human-readable  --info=progress2 --progress --stats --itemize-changes "${work_dir}/" "${install_dir}/";

show_var load_variables_file

#add variables to 'autorun/load_variables.sh'
#it will look like this "declare -g -x root_password=$(echo 'Z2Ftb25lZml2YQ=='  | openssl base64 -d ); export root_pass;"
#root_pass
#save_var_in_base64 root_password "$( get_var "${secrets}_${computer_name}_root_password" )" >> "${load_variables_file}";

#_user_i_password
#save_var_in_base64 user_i_password "$( get_var "${secrets}_${computer_name}_user_i_password" )" >> "${load_variables_file}";

#save_var_in_base64 script_subversion "$( get_var "script_subversion" )" >> "${load_variables_file}";
#echo 'echo "$script_subversion"; ' >> "${load_variables_file}";

#export >> "${load_variables_file}";
#export all ENV variables, expect some secrets
export | grep  -v 'password' | grep  -v 'secrets' | sort >> "${load_variables_file}";

#TODO disable any resctriction of local connect to X11 with Xorg config files on target system

#if not set DISPLAY - save default value
if [[ "${DISPLAY}" = "" ]]; then
  declare_and_export DISPLAY ':0'
fi

save_var_in_base64 DISPLAY "$DISPLAY" >> "${load_variables_file}";

#get something like this:
#0100 0009 692d6465736b746f70 0001 30 0012 4d49542d4d414749432d434f4f4b49452d31 0010 f5c41915d1cf1b92c8cf0f8fd8167b0f
# xauth_nextract=$( xauth nextract - $DISPLAY );
# save_var_in_base64 xauth_nextract "$xauth_nextract" >> "${load_variables_file}";
# echo 'echo "${xauth_nextract}" | xauth nmerge - ' >> "${load_variables_file}";
# echo 'echo "${xauth_nextract}" | sudo -u i xauth nmerge - ' >> "${load_variables_file}";
# echo 'echo "${xauth_nextract}" | sudo -u root xauth nmerge - ' >> "${load_variables_file}";
#export DISPLAY={Display number stored in the Xauthority file}
declare_and_export XAUTHORITY '/home/i/.Xauthority';
save_var_in_base64 XAUTHORITY "$XAUTHORITY" >> "${load_variables_file}";


echo "cd '${install_dir}';" >> "${load_variables_file}";

chown --verbose --changes --recursive  root:root "${install_dir}";
find "${install_dir}" -type d -exec chmod --verbose 0755 {} \;
find "${install_dir}" -type f -exec chmod --verbose 0755 {} \;
#for dev
find "${install_dir}" -type d -exec chmod --verbose 0777 {} \;
find "${install_dir}" -type f -exec chmod --verbose 0777 {} \;

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
systemctl status dzible | tac
# systemctl start dzible
systemctl enable dzible | tac
systemctl status dzible | tac

#read logs:
#journalctl -b -u dzible

#augeas_file="${work_dir}/tasks/${script_base_name}.txt";
#show_var "augeas_file"

#https://augeas.net/docs/references/1.4.0/lenses/files/sshd-aug.html

#https://www.opennet.ru/man.shtml?topic=sshd_config&category=5&russian=0

#are_you_serious=' --new --root="/dev/shm/augeas-sandbox" '; #kind of dry run mode
#are_you_serious=' --root=/ '; #real business

#augtool ${are_you_serious} --timing --echo --backup --autosave --file "${augeas_file}";
