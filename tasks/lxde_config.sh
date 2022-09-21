#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
# install task script

# TODO check what LXDE is installed on the system

install_system openbox
install_system compton

apt-get --assume-yes purge xcompmgr | cat
rm -f '/etc/xdg/autostart/xcompmgr.desktop'

# https://wiki.archlinux.org/title/xcompmgr
# install_system xcompmgr

# change some values in config

config_file='/etc/lightdm/lightdm.conf';
load_var_from_file "$config_file" config_var
replace_line_by_string config_var "autologin-user" "autologin-user=i" "#"
replace_line_by_string config_var "autologin-user-timeout" "autologin-user-timeout=3" "#"
save_var_to_file "$config_file" config_var

config_file='/etc/xdg/lxsession/LXDE-pi/desktop.conf';
load_var_from_file "$config_file" config_var
replace_line_by_string config_var "window_manager=" "window_manager=openbox" "#"
save_var_to_file "$config_file" config_var

# http://openbox.org/wiki/Help:Actions

dzintara_lxde_rc_config_file="${work_dir}/tasks/lxde_config_rc.xml";

lxde_rc_config_file='/etc/xdg/openbox/rc.xml';
copy_lxde_rc_config_file1='/etc/xdg/openbox/lxde-pi-rc.xml';
copy_lxde_rc_config_file2='/etc/xdg/openbox/LXDE/rc.xml';
copy_lxde_rc_config_file3='/home/i/.config/openbox/rc.xml';
copy_lxde_rc_config_file5='/home/i/.config/openbox/lxde-rc.xml';

# overwrite old config with new file
set -x
rm -v "$lxde_rc_config_file"
cp -v "$dzintara_lxde_rc_config_file" "$lxde_rc_config_file"
# set permissions
chmod --verbose 0644 "$lxde_rc_config_file";
# create HARD links to this file with overwrite original files
rm -v "$copy_lxde_rc_config_file1"
ln --verbose  "$lxde_rc_config_file" "$copy_lxde_rc_config_file1"
rm -v "$copy_lxde_rc_config_file2"
ln --verbose  "$lxde_rc_config_file" "$copy_lxde_rc_config_file2"
rm -v "$copy_lxde_rc_config_file3"
create_dir_for_file "$copy_lxde_rc_config_file3"
ln --verbose  "$lxde_rc_config_file" "$copy_lxde_rc_config_file3"
chown --verbose --changes  i:i "${copy_lxde_rc_config_file3}";
chmod --verbose 0644 "${copy_lxde_rc_config_file3}";
rm -v "${copy_lxde_rc_config_file5}"
ln --verbose  "${copy_lxde_rc_config_file3}" "${copy_lxde_rc_config_file5}"

# copy compton config to $compton_config_file
cp -v "${work_dir}/tasksdata/etc:xgd:compton.conf" "$compton_config_file"
chmod --verbose 0644 "$compton_config_file";

set +x
















