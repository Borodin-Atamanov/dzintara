#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script on target system in root mode, and sends some telemetry data
#read data from telemetry_queue_dir

#view logs:
#journalctl --all --follow --priority=7 -t dzible_telemetry
#tail -f /var/log/syslog | grep dzible;

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

function telemetry_get_next_message_dir ()
{
    #get next directory with message
    OLD_DIR=$(pwd);
    cd "${telemetry_queue_dir}";
    export TAB=$'\t';
    #TAB=$'\t'; find . -type f -print0 | xargs -0 /bin/busybox stat -c "%y${TAB}%n" | sort -n | cut -f2- | head -n 3 | xargs -r rm -v
    #find "${telemetry_queue_dir}" -type d -print0 | xargs -0 /usr/bin/stat -c "%y${TAB}%n"
    #find . -type d -print0 | xargs -0 /usr/bin/stat -c "%y${TAB}%n" | sort -n | cut -f2- | head -n 1 | xargs -r echo $0
    next_dir=$(find "${telemetry_queue_dir}" -maxdepth 1 -mindepth 1  -type d -print0 | xargs -0 stat -c "%y${TAB}%n" | sort -n | cut -f2- | head -n 1 );
    next_dir=$( realpath "${next_dir}" );
    echo -n "${next_dir}";
    cd "${OLD_DIR}";
}
export function telemetry_get_next_message_dir

next_dir="$(telemetry_get_next_message_dir)"
show_var next_dir


while 1 ; do
    #countdown 15 0.1
    countdown
    echo 1;
    sleep 1;
done;
#
# time for dir in */ ;
# do echo "$dir";
#     cd "$dir";
#     : ;
#     cd "${BDIR}";
# done;

sleep 3;
