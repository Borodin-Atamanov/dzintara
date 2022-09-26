#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT

# adds some icons to system menu

desktop_dir="/usr/share/applications/"
directories_dir="/usr/share/desktop-directories/"


# Dzintara's submenu in system menu
config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Icon=dzintara
Name=Dzintara
Type=Directory
_ENDOFFILE
)
# echo "$config_text"
config_file_dir="${directories_dir}dzintara-test.directory";
save_var_to_file "$config_file_dir" config_text

# user's entry to start some code
config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/cvt_xrandr_1280x1024_60.sh
Icon=dzintara
Name=1280x1024@60Hz
_ENDOFFILE
)
# echo "$config_text"
desktop_entry_file="${desktop_dir}dzintara-set-1280x1024_60.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"

# config_file="${menu_sysconfdir}/menus/dzintara.menu";
# config_text=$(cat <<_ENDOFFILE
# <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
# "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
# <Menu>
# 	<Name>Applications</Name>
# 	<Menu>
# 	<Name>Dzintara</Name>
# 	<Directory>dzintara_test.directory</Directory>
# 	<Include>
# 		<Filename>dzintara_test.desktop</Filename>
# 		<Filename>dzintara_test.desktop</Filename>
# 	</Include>
# </Menu>
# _ENDOFFILE
# )
# # echo "$config_text"
# #create_dir_for_file "$config_file"
# #save_var_to_file "$config_file" config_text

exit
this_is_LXDE=0
if [ ! -z "$(printenv | grep -i "LXQT")" ]; then this_is_LXDE=1; fi
if [ ! -z "$(printenv | grep -i "LXDE")" ]; then this_is_LXDE=1; fi

show_var this_is_LXDE
if [[ "$this_is_LXDE" != 1 ]]; then echo "this is NOT LXDE!"; sleep $timeout_1; exit; fi

# show all alternatives with:
#	update-alternatives --verbose --debug --get-selections
# x-window-manager
# --verbose --debug --set

install_system openbox
install_system compton

# /usr/bin/openbox
command_path="$( get_command_fullpath openbox )";
if [[ -e "$command_path" ]] ; then update-alternatives --verbose --debug --set x-window-manager $command_path; fi

# /usr/bin/lxterminal
command_path="$( get_command_fullpath lxterminal )";
if [[ -e "$command_path" ]] ; then update-alternatives --verbose --debug --set x-terminal-emulator $command_path; fi

apt-get --assume-yes purge xcompmgr | cat
rm -f '/etc/xdg/autostart/xcompmgr.desktop'

# https://wiki.archlinux.org/title/xcompmgr
# install_system xcompmgr

# change some values in configs
config_file='/etc/lightdm/lightdm.conf';
load_var_from_file "$config_file" config_var
replace_line_by_string config_var "autologin-user-timeout" "autologin-user-timeout=3" ""
replace_line_by_string config_var "autologin-user" "autologin-user=i" ""
save_var_to_file "$config_file" config_var

config_file='/etc/sddm.conf.d/autologin';
load_var_from_file "$config_file" config_var
replace_line_by_string config_var "User=" "User=i" ""
replace_line_by_string config_var "Session=" "Session=lxqt.desktop" ""
replace_line_by_string config_var "Relogin=" "Relogin=" ""
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
#set -x
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

systemctl status display-manager | cat
sleep $timeout_0















