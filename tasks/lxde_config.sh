#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
# install task script

# TODO check what LXDE is installed on the system

install_system openbox
install_system compton

# https://wiki.archlinux.org/title/xcompmgr
# install_system xcompmgr

# change some values in config

config_file='/etc/xdg/lxsession/LXDE-pi/desktop.conf';
load_var_from_file "$config_file" config_var
replace_line_by_string config "window_manager=" "window_manager=openbox" "#"
save_var_to_file "$config_file" config_var

# http://openbox.org/wiki/Help:Actions

dzintara_lxde_rc_config_file="${work_dir}/tasks/lxde_config_rc.xml";

lxde_rc_config_file='/etc/xdg/openbox/rc.xml';

copy_lxde_rc_config_file1='/etc/xdg/openbox/lxde-pi-rc.xml';
copy_lxde_rc_config_file2='/etc/xdg/openbox/LXDE/rc.xml';
copy_lxde_rc_config_file3='/home/i/.config/openbox/rc.xml';

# overwrite old config with new file
set -x
rm -v "$lxde_rc_config_file"
cp -v "$dzintara_lxde_rc_config_file" "$lxde_rc_config_file"
# set permissions
chmod --verbose 0644 "$lxde_rc_config_file";
# create HARD links to this file with overwrite original files
rm -v "$copy_lxde_rc_config_file1"
ln --verbose --force "$lxde_rc_config_file" "$copy_lxde_rc_config_file1"
rm -v "$copy_lxde_rc_config_file2"
ln --verbose --force "$lxde_rc_config_file" "$copy_lxde_rc_config_file2"
rm -v "$copy_lxde_rc_config_file3"
create_dir_for_file "$copy_lxde_rc_config_file3"
ln --verbose --force "$lxde_rc_config_file" "$copy_lxde_rc_config_file3"
chown --verbose --changes  i:i "${copy_lxde_rc_config_file3}";
chmod --verbose 0644 "${copy_lxde_rc_config_file3}";

set +x
















