#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script on target system in root mode, and sends some telemetry data
#read data from telemetry_queue_dir

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
#source "/home/i/bin/dzible/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

#load secret variables
source "${work_dir_autorun}load_variables.sh";

declare -x -g service_name='dzible.telemetry';   #for slog systemd logs
slog "<5>start dzible.telemetry. It will send some anonymous telemetry data."

#load password to decrypt secrets
#source "${root_vault_password_file}";
root_vault_password=$(cat "${root_vault_password_file}" | base32 -d -i);
#show_var root_vault_password

#decrypt root vault
encrypted_data=$(cat "${root_vault_file}");
#encrypted_data=$( encrypt_aes "${pass}" "${data}"; )
decrypted_data=$(decrypt_aes "${root_vault_password}" "${encrypted_data}")
show_var decrypt_aes_error
#echo "$decrypted_data";
#load all variables from decrypted vault
eval "${decrypted_data}";
#echo "secrets_pipyau_root_password=${secrets_pipyau_root_password}"

#show_var telemetry_telegram_bot_token

mkdir -pv "${telemetry_queue_dir}";
chown --verbose --changes --recursive  root:root "${telemetry_queue_dir}";
chmod --verbose 0777 "${telemetry_queue_dir}";

#TODO create main loop where monitor new directories
#

sleep 3;
