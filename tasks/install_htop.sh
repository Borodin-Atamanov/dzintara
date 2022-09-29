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

config_source="${work_dir}tasksdata/root:.config:htop:htoprc"

config_target1='/home/i/.config/htop/htoprc'
config_target2='/root/.config/htop/htoprc'

rm -v "$config_target1"
rm -v "$config_target2"
create_dir_for_file "$config_target1"
create_dir_for_file "$config_target2"
cp -v "$config_source" "$config_target1"
ln --verbose  "$config_target1" "$config_target2"
chown --verbose --changes  i:i "$config_target1";
chmod --verbose 0644 "$config_target1";

# timeout --kill-after=5 3 htop | cat

