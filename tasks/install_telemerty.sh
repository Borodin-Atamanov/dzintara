#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install telemetry as system service

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

#create directory for install scripts
show_var telemetry_queue_dir
mkdir -pv "${telemetry_queue_dir}";
chown --verbose --changes --recursive  root:root "${telemetry_queue_dir}";
chmod --verbose 0777 "${telemetry_queue_dir}";
#find "${telemetry_queue_dir}" -type d -exec chmod --verbose 0777 {} \;

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

#start cron on system start
#systemctl enable cron

#add script as autorun service to systemd for root
#create systemd service unit file

telemetry_service_settings=$(cat <<_ENDOFFILE
[Unit]
Description=dzible telemetry service
[Service]
ExecStart=${telemetry_script_file}
[Install]
WantedBy=multi-user.target
_ENDOFFILE
)

show_var telemetry_service_settings
echo "$telemetry_service_settings" > "${telemetry_service_file}";
#show_var telemetry_service_settings

systemctl status dzible_telemetry | tac
systemctl restart dzible_telemetry
systemctl enable dzible_telemetry | tac
systemctl status dzible_telemetry | tac
