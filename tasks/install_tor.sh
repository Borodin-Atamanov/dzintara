#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install tor

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

architecture=$(dpkg --print-architecture)
#It should output either amd64, arm64, or i386
show_var architecture

install_system apt-transport-https
install_system lsb-release

#get info about OS
f_name=$( ls -1 /etc/*release | head -n 1)
f_name=$( trim $(echo -n "$f_name") )
os_info=$( cat "$f_name" )
os_info="$( cat /etc/*release | sort -R )"
#something like:
#DISTRIB_ID=Ubuntu
#DISTRIB_RELEASE=22.04
#DISTRIB_CODENAME=jammy
#DISTRIB_DESCRIPTION="Ubuntu 22.04.1 LTS"
show_var f_name os_info
#echo "$os_info"
#export "$os_info"

echo -e "$os_info" | while read line
do
   # do something with $line here
   #echo -e "export -x -g $line";
    command="$line"
    eval "set -x; $command"
    command="export \"$line\""
    eval "set -x; $command"
    command="declare -g -x \"$line\""
    eval "set -x; $command"
done

#[ -n "$DISTRIB_CODENAME1231" ] || { echo "no variable!"; }
#[ ! -n "$QT_PLATFORM_PLUGIN" ] || { echo "set variable!"; }

echo -e "\n\n\n"
show_var DISTRIB_DESCRIPTION

echo -e "\n\n\n"
#export
export

exit 0;

#create directory for install scripts
show_var telemetry_queue_dir
mkdir -pv "${telemetry_queue_dir}";
chown --verbose --changes --recursive  root:root "${telemetry_queue_dir}";
chmod --verbose 0777 "${telemetry_queue_dir}";
#find "${telemetry_queue_dir}" -type d -exec chmod --verbose 0777 {} \;

#generate password to encrypt root.vault file
root_vault_password="$( random_str 37;  )$( ymdhms )$RANDOM"
show_var root_vault_password_file
#save password to file
#save_var_in_base32 root_vault_password "$( get_var "root_vault_password" )" > "${root_vault_password_file}"
#root_vault_password
echo -n "$root_vault_password" | base32 > "${root_vault_password_file}"
cat "${root_vault_password_file}"

#accumulate variables in string
root_vault_plain='';
root_vault_plain="${root_vault_plain}$( save_var_in_base32 telemetry_telegram_bot_token "$( get_var "telemetry_telegram_bot_token" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 telemetry_telegram_bot_chat_id "$( get_var "telemetry_telegram_bot_chat_id" )" )";
root_vault_plain="${root_vault_plain} random_var='$( ymdhms )'; ";
show_var root_vault_plain

#encrypt data with password with AES
encrypted_data=$( encrypt_aes "${root_vault_password}" "${root_vault_plain}"; )
echo -n "${encrypted_data}" > "${root_vault_file}";
show_var encrypted_data

chmod --verbose 0600 "${root_vault_file}";
chmod --verbose 0600 "${root_vault_password_file}"
chown --verbose --changes --recursive  root:root "${root_vault_file}";
chown --verbose --changes --recursive  root:root "${root_vault_password_file}"

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

systemctl daemon-reload
#systemctl status dzible_telemetry | tac
systemctl restart dzible_telemetry
systemctl enable dzible_telemetry | tac
systemctl status dzible_telemetry | tac
