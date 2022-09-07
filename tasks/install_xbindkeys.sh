#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT

#source "${work_dir}tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

install_system xbindkeys

xbindkeysrc_config_file="${work_dir}/tasks/${task_name}.txt";
xbindkeysrc_config_file_path="/home/i/.xbindkeysrc";

cp -v "$xbindkeysrc_config_file" "$xbindkeysrc_config_file_path"

chown --verbose --changes --recursive  i:i "${xbindkeysrc_config_file_path}";
chmod --verbose 0666 "${xbindkeysrc_config_file_path}";
