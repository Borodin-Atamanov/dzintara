#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}tasks/1.sh"

#set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

#export

xgd=XDG;
root_vault_plain='';
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
root_vault_plain="${root_vault_plain}$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" )";
echo "${root_vault_plain}";

exit

#vvv=;
#show_var vvv
varia=$( save_var_in_base32 user_i_password "$( get_var "${xgd}_DATA_DIRS" )" );
#varia=$( save_var_in_base32 user_i_password "${vvv}" );
show_var varia


telemetry_service_settings=$(cat <<_ENDOFFILE
[Unit]
Description=dzintara telemetry service
[Service]
ExecStart=${telemetry_script_file}
[Install]
WantedBy=multi-user.target
# whoami $varia
_ENDOFFILE
)

echo "$telemetry_service_settings";
