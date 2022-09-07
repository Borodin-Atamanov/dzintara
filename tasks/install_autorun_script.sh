#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install 4 scripts to autorun on target system

#source "${work_dir}tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi


#create directory for install scripts
rm -rvf "${install_dir}";
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
#export | grep  -v 'password' | grep  -v 'secrets'  | grep  -v 'work_dir' | sort >> "${load_variables_file}";

#TODO disable any resctriction of local connect to X11 with Xorg config files on target system

#if not set DISPLAY - save default value
if [[ "${DISPLAY}" = "" ]]; then
  declare_and_export DISPLAY ':0'
fi
declare_and_export XAUTHORITY '/home/i/.Xauthority';

save_var_in_text work_dir "${install_dir}" >> "${load_variables_file}";
save_var_in_base32 work_dir "${install_dir}" >> "${load_variables_file}";

echo 'cd "${work_dir}";' >> "${load_variables_file}";
#echo "cd '${install_dir}';" >> "${load_variables_file}";

echo 'source "${work_dir}/index.sh" fun' >> "${load_variables_file}";
#source "/home/i/bin/dzible/index.sh" fun

save_var_in_text DISPLAY "$DISPLAY" >> "${load_variables_file}";
save_var_in_base32 DISPLAY "$DISPLAY" >> "${load_variables_file}";

save_var_in_text XAUTHORITY "$XAUTHORITY" >> "${load_variables_file}";
save_var_in_base32 XAUTHORITY "$XAUTHORITY" >> "${load_variables_file}";
#save_var_in_text XAUTHORITY "$XAUTHORITY" >> "${load_variables_file}";
#save_var_in_text work_dir "${install_dir}" >> "${load_variables_file}";

#add dzible functions and variables to shell autorun
#TODO check what string is not in file
echo  "source ${load_variables_file}" >> "/home/i/.bash_profile"
echo  "source ${load_variables_file}" >> "/home/i/.bashrc"
echo  "source ${load_variables_file}" >> "/home/i/.profile"

#install_system stterm

#add script as autorun service to systemd for root
#create systemd service unit file
dzible_service_settings=$(cat <<_ENDOFFILE
[Unit]
Description=dzible autorun service
[Service]
ExecStart=${root_autorun_file}
[Install]
WantedBy=multi-user.target
_ENDOFFILE
)

show_var dzible_service_settings
echo "$dzible_service_settings" > "${root_autorun_service_file}";

systemctl daemon-reload
systemctl restart dzible| cat
systemctl enable dzible | cat
systemctl status dzible | cat

#add script and systemd service, timer to change x11 settings
# xkeyboard_autorun_script_file
# xkeyboard_autorun_service_file
# xkeyboard_autorun_timer_file

#create systemd service unit file
service_unit=$(cat <<_ENDOFFILE
[Unit]
Description=dzible autorun service
[Service]
ExecStart=${xkeyboard_autorun_script_file}
Restart=always
[Install]
WantedBy=multi-user.target
_ENDOFFILE
)

show_var service_unit
echo "$service_unit" > "${xkeyboard_autorun_service_file}";

systemctl daemon-reload
systemctl restart dzible_xkeyboard_autorun| cat
systemctl enable dzible_xkeyboard_autorun | cat
systemctl status dzible_xkeyboard_autorun | cat


#create systemd service unit file
#this service will read from fifo pipe and run commands as root
service_unit=$(cat <<_ENDOFFILE
[Unit]
Description=dzible run commands from named fifo pipe as root

[Service]
ExecStart=${run_command_from_pipes_script_file}
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
_ENDOFFILE
)
show_var service_unit
echo "$service_unit" > "${run_command_from_root_pipes_service_file}";

#create systemd service unit file
#this service will read from fifo pipe and run commands as user i
service_unit=$(cat <<_ENDOFFILE
[Unit]
Description=dzible run commands from named fifo pipe as user i

[Service]
ExecStart=${run_command_from_pipes_script_file}
Restart=always
User=i
Group=i

[Install]
WantedBy=multi-user.target
_ENDOFFILE
)
show_var service_unit
echo "$service_unit" > "${run_command_from_user_i_pipes_service_file}";

rm -v "$run_command_from_root_pipe_file"
rm -v "$run_command_from_user_i_pipe_file"

systemctl daemon-reload
systemctl restart dzible_pipes_user_i_autorun| cat
systemctl enable dzible_pipes_user_i_autorun | cat
systemctl status dzible_pipes_user_i_autorun | cat

systemctl restart dzible_pipes_root_autorun| cat
systemctl enable dzible_pipes_root_autorun | cat
systemctl status dzible_pipes_root_autorun | cat

chown --verbose --changes --recursive  i:i "${install_dir}";
find "${install_dir}" -type d -exec chmod --verbose 0755 {} \;
find "${install_dir}" -type f -exec chmod --verbose 0755 {} \;
#for dev
find "${install_dir}" -type d -exec chmod --verbose 0777 {} \;
find "${install_dir}" -type f -exec chmod --verbose 0777 {} \;
#TODO set different rights to files. Some files must be secret for regular user


#read logs:
#journalctl -b -u dzible_telemetry

