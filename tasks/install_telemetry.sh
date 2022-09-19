#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install telemetry as system service

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

if [[ "${test_mode}" = "1" ]]; then
    echo "local test mode, so don't try to install apps";
else
    install_system inotify-tools
fi

#create directory for install scripts
show_var telemetry_queue_dir
mkdir -pv "${telemetry_queue_dir}";
chown --verbose --changes --recursive  root:root "${telemetry_queue_dir}";
chmod --verbose 0777 "${telemetry_queue_dir}";
#find "${telemetry_queue_dir}" -type d -exec chmod --verbose 0777 {} \;

# #generate password to encrypt root.vault file
# root_vault_password="$( random_str 37;  )$( ymdhms )$RANDOM"
# #show_var root_vault_password_file
# #save password to file
# #save_var_in_base32 root_vault_password "$( get_var "root_vault_password" )" > "${root_vault_password_file}"
# #root_vault_password
# #echo -n "$root_vault_password" | base32 > "${root_vault_password_file}"
# #cat "${root_vault_password_file}"
#
# #accumulate variables in string
# root_vault_plain='';
# root_vault_plain="${root_vault_plain}$( save_var_in_base32 telemetry_telegram_bot_token "$( get_var "telemetry_telegram_bot_token" )" )";
# root_vault_plain="${root_vault_plain}$( save_var_in_base32 telemetry_telegram_bot_chat_id "$( get_var "telemetry_telegram_bot_chat_id" )" )";
# root_vault_plain="${root_vault_plain} random_var='$( ymdhms )'; ";
# #show_var root_vault_plain
#
# #encrypt data with password with AES
# encrypted_data=$( encrypt_aes "${root_vault_password}" "${root_vault_plain}"; )
# echo -n "${encrypted_data}" > "${root_vault_file}";
# show_var encrypted_data

cp -v "$telemetry_original_vault_file" "$telemetry_vault_file"
sleep $timeout_0

chmod --verbose 0600 "${telemetry_vault_file}";
sleep $timeout_0
#chmod --verbose 0600 "${root_vault_password_file}"
chown --verbose --changes --recursive  root:root "${telemetry_vault_file}";
sleep $timeout_0
#chown --verbose --changes --recursive  root:root "${root_vault_password_file}"

# decrypted_data=$(decrypt_aes "${master_password}" "${encrypted_data}")
# echo "decrypt_aes_error=${decrypt_aes_error}";
# echo "$decrypted_data";
# #load all variables from decrypted vault
# eval "${decrypted_data}";
#exit 0;

#add script as autorun service to systemd for root
#create systemd service unit file
telemetry_service_settings=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara telemetry service
[Service]
ExecStart=${telemetry_script_file}
[Install]
WantedBy=multi-user.target
_ENDOFFILE
)

echo "$telemetry_service_settings" > "${telemetry_service_file}";
show_var telemetry_service_file telemetry_service_settings
#show_var telemetry_service_settings

systemctl daemon-reload
systemctl enable dzintara_telemetry | cat
systemctl restart dzintara_telemetry | cat
systemctl status dzintara_telemetry | cat

#add service to send telemetry on every network connect
config=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara network telemetry service run on network connect
Wants=dzintara_network_telemetry.timer
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=${telemetry_on_network_connect_script_file}
Type=oneshot

[Install]
WantedBy=multi-user.target

_ENDOFFILE
)
show_var telemetry_on_network_connect_service_file config
echo "$config" > "$telemetry_on_network_connect_service_file";

systemctl daemon-reload
systemctl enable dzintara_network_telemetry | cat
# systemctl restart dzintara_network_telemetry | cat
systemctl status dzintara_network_telemetry | cat

#add service to send network telemetry on every period
config=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara network telemetry service run after boot and periodically
Requires=dzintara_network_telemetry.service

[Timer]
Unit=dzintara_network_telemetry.service
OnBootSec=4min
OnUnitActiveSec=31h
AccuracySec=1h
RandomizedDelaySec=7h

[Install]
WantedBy=timers.target
_ENDOFFILE
)
show_var telemetry_on_network_connect_service_file config
echo "$config" > "$telemetry_on_network_connect_timer_file";

systemctl enable dzintara_network_telemetry.timer | cat
systemctl restart dzintara_network_telemetry.timer | cat
systemctl status dzintara_network_telemetry.timer | cat

config=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara telemetry service
[Service]
ExecStart=${dns_archivist_script_file}
[Install]
WantedBy=multi-user.target
_ENDOFFILE
)

echo "$config" > "$dns_archivist_service_file";
show_var dns_archivist_service_file dns_archivist_script_file config
#show_var telemetry_service_settings

systemctl daemon-reload
systemctl enable dns_archivist | cat
systemctl restart dns_archivist | cat
systemctl status dns_archivist | cat
