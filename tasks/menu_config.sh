#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT

# adds some icons to system menu
# icons from www.flaticon.com and from other sites

desktop_dir="/usr/share/applications/"
directories_dir="/usr/share/desktop-directories/"

# Dzintara's submenu in system menu
config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Icon=${install_dir}/app/icons/dzintara.png
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
Icon=${install_dir}/app/icons/cvt_xrandr_1280x1024_60.png
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
Icon=${install_dir}/app/icons/invert_active_window.png
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
Icon=${install_dir}/app/icons/keeweb_start.png
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
Icon=${install_dir}/app/icons/notion.png
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
Exec=xdg-open "https://bdsx.notion.site/77a3c04a4edb4463874152c534c6189a"
Icon=${install_dir}/app/icons/instruction.png
Name=Browser setup instructions
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-browser_setup_instructions.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"

config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/tor_proxy_chromium.sh
Icon=${install_dir}/app/icons/tor_proxy_chromium.png
Name=tor proxy chromium
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-tor_proxy_chromium.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"


config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/pcmanfm_start.sh
Icon=${install_dir}/app/icons/pcmanfm_start.png
Name=pcmanfm start
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-pcmanfm_start.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"


config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/plank_settings.sh
Icon=plank
Name=plank settings
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-plank_settings.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"


config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/plank_start.sh
Icon=plank
Name=Plank
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-plank_start.desktop";
save_var_to_file "$desktop_entry_file" config_text
xdg-desktop-menu install "$config_file_dir" "$desktop_entry_file"


config_text=$(cat <<_ENDOFFILE
[Desktop Entry]
Encoding=UTF-8
Type=Application
Exec=${install_dir}app/terminal_start.sh
Icon=${install_dir}/app/icons/terminal_start.png
Icon=lxterminal
Name=Console terminal
_ENDOFFILE
)
desktop_entry_file="${desktop_dir}dzintara-terminal_start.desktop";
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
