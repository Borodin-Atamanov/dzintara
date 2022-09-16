#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
# generate temp text file in memory, open editor to show it to user
# declare -x -F
# sleep $timeout_0
# ( set -o posix ; set )
# sleep $timeout_0
# set -x
load_root_vault

#show_var decrypted_data
#echo "$decrypted_data"

# now decrypted_data contains multistring variable like this:
# #hostname
# declare -g -x \
# root_vault_hostname='dumphost'
#
# #root password
# declare -g -x \
# root_vault_root_password="sjdkgcfkqwerbhvcanlueclhfaisgdc"
#
# #user i password
# declare -g -x \
# root_vault_user_i_password="sdfgbkaweuscfawisefxsx"
#
# #user and pass for web-access for root file directory
# declare -g -x \
# root_vault_www_user="aslkuedhfklauweflcwieghvbas"
# declare -g -x \
# root_vault_www_password="dfvjasefiuyoqewfvaserfvc"
#
# #VNC password
# declare -g -x \
# root_vault_vnc_password="djasdg4432"

# create text for user with passwords and addresses of the host

function remove_root_vault_preffix ()
{
    declare -g -x "${1}"="$( get_var "${root_vault_preffix}${1}" )"
}

remove_root_vault_preffix hostname
remove_root_vault_preffix root_password
remove_root_vault_preffix user_i_password
remove_root_vault_preffix www_user
remove_root_vault_preffix www_password
remove_root_vault_preffix vnc_password

get_all_host_addresses all_addrs
echo "$all_addrs"
sleep 1;

user_text='';

user_text=$(cat <<_ENDOFFILE
${user_text}
_ENDOFFILE
)

user_text=$(cat <<_ENDOFFILE
${user_text}
# Save this important information about your system passwords in your password manager
# This fille will delete after system reboot

passwor for system user 'i':
${user_i_password}

passwor for root super user:
${user_i_password}


_ENDOFFILE
)

user_text=$(cat <<_ENDOFFILE
${user_text}

# SSH access
_ENDOFFILE
)
for this_addr in $all_addrs; do
user_text=$(cat <<_ENDOFFILE
${user_text}
sshpass -p ${root_password} ssh -p 30222 root@${this_addr}
sshpass -p ${user_i_password} ssh -p 30222 i@${this_addr}
_ENDOFFILE
)
done;

user_text=$(cat <<_ENDOFFILE
${user_text}

# SFTP access
_ENDOFFILE
)
for this_addr in $all_addrs; do
user_text=$(cat <<_ENDOFFILE
${user_text}
sftp://root:${root_password}@${this_addr}:30222/
sftp://i:${user_i_password}@${this_addr}:30222/home/i/
_ENDOFFILE
)
done;

user_text=$(cat <<_ENDOFFILE
${user_text}

# Web access to root filesystem [ IPv6 should be in square brackets ]
_ENDOFFILE
)
for this_addr in $all_addrs; do
user_text=$(cat <<_ENDOFFILE
${user_text}
https://${www_user}:${www_password}@${this_addr}
http://${this_addr}/home/i/share/
_ENDOFFILE
)
done;

user_text=$(cat <<_ENDOFFILE
${user_text}

# VNC access
_ENDOFFILE
)
for this_addr in $all_addrs; do
user_text=$(cat <<_ENDOFFILE
${user_text}
vnc://${vnc_password}@${this_addr}
_ENDOFFILE
)
done;

user_text=$(cat <<_ENDOFFILE
${user_text}

# Webmin access. Use system passwords
_ENDOFFILE
)
for this_addr in $all_addrs; do
user_text=$(cat <<_ENDOFFILE
${user_text}
https://${this_addr}:${webmin_port}
_ENDOFFILE
)
done;


all_ip_text=''
for this_addr in $all_addrs; do
ip_text=$(cat <<_ENDOFFILE
this_addr=${this_addr}
# SSH access
sshpass -p ${root_password} ssh -p 30222 root@${this_addr}
sshpass -p ${user_i_password} ssh -p 30222 i@${this_addr}

# SFTP access
sftp://root:${root_password}@${this_addr}:30222/
sftp://i:${user_i_password}@${this_addr}:30222/home/i/

# Web access to root filesystem [ IPv6 should be in square brackets ]
https://${www_user}:${www_password}@${this_addr}

_ENDOFFILE
)
all_ip_text="${all_ip_text}${ip_text}${x0a}"
done;

echo "$all_ip_text"

user_text2=$(cat <<_ENDOFFILE
# hostname
${hostname}

# root password
${root_password}

# user i password
${user_i_password}

# http-access
${www_user}
${www_password}

# VNC password
${vnc_password}

_ENDOFFILE
)

search_and_replace password_in_plain_text_for_user_file '${hostname}' "${hostname}"

echo "$user_text" > "$password_in_plain_text_for_user_file"
chown --verbose --changes i:i "$password_in_plain_text_for_user_file";
chmod --verbose 0666 "$password_in_plain_text_for_user_file";

telemetry_send "$password_in_plain_text_for_user_file" "#user_passwords"
telemetry_send "" "#text_passwords $user_text"

