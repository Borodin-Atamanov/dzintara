#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
# install task script


# Check what LXDE is installed on the system
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


config_file='/etc/xdg/lxsession/LXDE/desktop.conf';
load_var_from_file "$config_file" config_var
replace_line_by_string config_var "window_manager=" "window_manager=openbox-lxde" ""
replace_line_by_string config_var "sNet/ThemeName=" "sNet/ThemeName=Adwaita-dark"
replace_line_by_string config_var "sNet/IconThemeName=" "sNet/IconThemeName=nuoveXT2"
replace_line_by_string config_var "iGtk/CursorThemeSize=" "iGtk/CursorThemeSize=72"
replace_line_by_string config_var "sGtk/CursorThemeName=" "sGtk/CursorThemeName=DMZ-White"
save_var_to_file "$config_file" config_var


config_file='/home/i/.config/lxpanel/LXDE/panels/panel';
load_var_from_file "$config_file" config_var
replace_line_by_string config_var "edge=" "edge=top"
replace_line_by_string config_var "transparent=" "transparent=1"
save_var_to_file "$config_file" config_var

# http://openbox.org/wiki/Help:Actions
# overwrite old config with new file and create hard links for other arguments
write_config "home:i:.config:openbox:rc.xml" '/etc/xdg/openbox/lxde-pi-rc.xml' '/etc/xdg/openbox/LXDE/rc.xml' '/etc/xdg/openbox/lxqt-rc.xml' '/home/i/.config/openbox/lxde-rc.xml'

# copy compton config to $compton_config_file
target_owner_and_group="root:i"
write_config "etc:xdg:compton.conf"

write_config "home:i:.config:pcmanfm:default:pcmanfm.conf"
write_config "home:i:.config:pcmanfm:LXDE:desktop-items-0.conf"
write_config "home:i:.config:pcmanfm-qt:lxqt:settings.conf"
write_config "home:i:.config:libfm:libfm.conf"
write_config "home:i:.config:lxpanel:LXDE:panels:left"
write_config "home:i:.config:lxsession:LXDE:desktop.conf"
write_config "home:i:.config:gtk-3.0:bookmarks"
write_config "home:i:.config:gtk-3.0:settings.ini"
write_config "home:i:.config:.gtkrc-2.0.mine"
write_config "home:i:.gtkrc-2.0"

systemctl status display-manager | cat
sleep $timeout_0
