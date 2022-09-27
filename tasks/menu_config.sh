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
desktop_entry_file="${desktop_dir}dzintara-set-1280x1024_60.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"

config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/invert_active_window.sh
Icon=dzintara
Name=Invert active window
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-invert_active_window.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"


config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/keeweb_start.sh
Icon=dzintara
Name=KeeWeb start in browser
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-keeweb_start.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"


config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=xdg-open "https://notion.so/?from=dzintara"
Icon=dzintara
Name=Notion
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-notion.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"



config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/tor_proxy_chromium.sh
Icon=dzintara
Name=KeeWeb start in browser
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-keeweb_start.desktop";
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











