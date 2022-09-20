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
rm -rf "${install_dir}";
mkdir -pv "${install_dir}";

#copy scripts to install directory
#cp --dereference --update --verbose --recursive --strip-trailing-slashes "${work_dir}" --target-directory="${install_dir}";
rsync --verbose --recursive --update --mkpath --copy-links --executability  --sparse --whole-file --delete-after --ignore-errors --exclude='.git' --exclude='.git*' --human-readable  --info=progress2 --progress --stats --itemize-changes "${work_dir}/" "${install_dir}/"  | tr -d '\n'

show_var load_variables_file

#add variables to 'autorun/load_variables.sh'
#it will look like this "declare -g -x root_password=$(echo 'Z2Ftb25lZml2YQ=='  | openssl base64 -d ); export root_pass;"
#root_pass
#save_var_in_base64 root_password "$( get_var "${root_vault_preffix}root_password" )" >> "${load_variables_file}";

#_user_i_password
#save_var_in_base64 user_i_password "$( get_var "${root_vault_preffix}user_i_password" )" >> "${load_variables_file}";

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

# try to load XDG variables. This variables generates by user_autorun_gui script
echo "source ${ipc_dir_xdg_var_file};" >> "${load_variables_file}";

save_var_in_text work_dir "${install_dir}" >> "${load_variables_file}";
save_var_in_base32 work_dir "${install_dir}" >> "${load_variables_file}";

echo 'if [[ "$1" != "nocd" ]]; then ' >> "${load_variables_file}";
echo 'cd "${work_dir}";' >> "${load_variables_file}";
echo 'fi' >> "${load_variables_file}";
#echo "cd '${install_dir}';" >> "${load_variables_file}";

echo 'source "${work_dir}/index.sh" fun' >> "${load_variables_file}";
#source "/home/i/bin/dzintara/index.sh" fun

save_var_in_text DISPLAY "$DISPLAY" >> "${load_variables_file}";
save_var_in_base32 DISPLAY "$DISPLAY" >> "${load_variables_file}";

save_var_in_text XAUTHORITY "$XAUTHORITY" >> "${load_variables_file}";
save_var_in_base32 XAUTHORITY "$XAUTHORITY" >> "${load_variables_file}";
#save_var_in_text XAUTHORITY "$XAUTHORITY" >> "${load_variables_file}";
#save_var_in_text work_dir "${install_dir}" >> "${load_variables_file}";

#add dzintara functions and variables to shell autorun
line_to_add="source ${load_variables_file} nocd"
add_line_to_file "/home/i/.bash_profile" "$line_to_add"
add_line_to_file "/home/i/.bashrc" "$line_to_add"
add_line_to_file "/home/i/.profile" "$line_to_add"

add_line_to_file "/root/.bash_profile" "$line_to_add"
add_line_to_file "/root/.bashrc" "$line_to_add"
add_line_to_file "/root/.profile" "$line_to_add"

#add script as autorun service to systemd for root
#create systemd service unit file
dzintara_service_settings=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara autorun service
[Service]
ExecStart=${root_autorun_file}
[Install]
WantedBy=multi-user.target
_ENDOFFILE
)

show_var dzintara_service_settings
echo "$dzintara_service_settings" > "${root_autorun_service_file}";

systemctl daemon-reload
#systemctl restart dzintara| cat
systemctl enable dzintara | cat
systemctl status dzintara | cat

sleep $timeout_0

#add script and systemd service, timer to change x11 settings
# xkeyboard_autorun_script_file
# xkeyboard_autorun_service_file
# xkeyboard_autorun_timer_file

#create systemd service unit file
service_unit=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara xkeyboard autorun service
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
#systemctl restart dzintara_xkeyboard_autorun| cat
systemctl enable dzintara_xkeyboard_autorun | cat
systemctl status dzintara_xkeyboard_autorun | cat
sleep $timeout_0


#create systemd service unit file
#this service will read from fifo pipe and run commands as root
service_unit=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara run commands from named fifo pipe as root

[Service]
ExecStart=${run_command_from_pipes_script_file} root
Restart=always

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
Description=dzintara run commands from named fifo pipe as user i

[Service]
ExecStart=${run_command_from_pipes_script_file} i
Restart=always

[Install]
WantedBy=multi-user.target
_ENDOFFILE
)
show_var service_unit
echo "$service_unit" > "${run_command_from_user_i_pipes_service_file}";

rm -v "$run_command_from_root_pipe_file"
rm -v "$run_command_from_user_i_pipe_file"
sleep $timeout_0

systemctl daemon-reload
systemctl restart dzintara_pipes_user_i_autorun | cat
systemctl enable dzintara_pipes_user_i_autorun | cat
systemctl status dzintara_pipes_user_i_autorun | cat
sleep $timeout_0

systemctl restart dzintara_pipes_root_autorun| cat
systemctl enable dzintara_pipes_root_autorun | cat
systemctl status dzintara_pipes_root_autorun | cat
sleep $timeout_0

#read logs:
#journalctl -b -u dzintara_telemetry

chown  --changes --recursive  root:root "${install_dir}";
find "${install_dir}" -type d -exec chmod 0755 {} \;
find "${install_dir}" -type f -exec chmod 0755 {} \;

# set different rights to files. Some files must be secret for regular user
find "${install_dir}" -type f -not -name "*.sh" -exec chmod 0644 {} \;
find "${install_dir}" -type f -name "*.sh" -exec chmod 0755 {} \;

find "${install_dir}autorun" -type f -name "*user*.sh" -exec chown  --changes --recursive  i:i {} \;

chmod  0600 "${root_vault_file}"
chmod  0600 "${root_vault_password_file}"
chown  --changes root:root "${root_vault_file}"
chown  --changes root:root "${root_vault_password_file}"

# TODO delete after development:
find "${install_dir}" -type d -exec chmod 0777 {} \;
find "${install_dir}" -type f -exec chmod 0777 {} \;
