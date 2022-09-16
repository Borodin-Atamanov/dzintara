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

get_all_host_addresses all_ip
echo "$all_ip"
sleep 1;

declare -g -x user_text=$(cat <<_ENDOFFILE
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

echo "$user_text"
