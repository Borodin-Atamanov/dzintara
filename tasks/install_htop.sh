#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install tor

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi
install_system htop

write_config "home:i:.config:htop:htoprc" '/root/.config/htop/htoprc'
