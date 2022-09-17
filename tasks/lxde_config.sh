#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
# install task script

# TODO check what LXDE is installed on the system

install_system openbox

# https://wiki.archlinux.org/title/xcompmgr
install_system xcompmgr

# change some values in config
config_file='/etc/xdg/lxsession/LXDE-pi/desktop.conf';
load_var_from_file "$config_file" config_var
replace_line_by_string config "window_manager=" "window_manager=openbox" "#"
save_var_to_file "$config_file" config_var

#cp -v "$config_file"

