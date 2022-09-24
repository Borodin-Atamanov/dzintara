#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT

# delete empty dirs from $HOME dir
find '/home/i/' -maxdepth 1  -empty -type d -exec rmdir -v '{}' \;

config_file='/home/i/.config/user-dirs.dirs';
config_text=$(cat <<_ENDOFFILE
XDG_DESKTOP_DIR="\$HOME/desktop"
XDG_PUBLICSHARE_DIR="${nginx_shared_dir}"
XDG_DOCUMENTS_DIR="\$HOME/downloads"
XDG_DOWNLOAD_DIR="\$HOME/downloads"
XDG_MUSIC_DIR="\$HOME/downloads"
XDG_PICTURES_DIR="\$HOME/downloads"
XDG_TEMPLATES_DIR="\$HOME/downloads"
XDG_VIDEOS_DIR="\$HOME/downloads"
_ENDOFFILE
)
# echo "$config_text"
save_var_to_file "$config_file" config_text

new_dir="/home/i/downloads/"
mkdir -pv "$new_dir"; chown --verbose --changes  i:i "$new_dir"; chmod --verbose 0755 "$new_dir";
new_dir="${nginx_shared_dir}/"
mkdir -pv "$new_dir"; chown --verbose --changes  i:i "$new_dir"; chmod --verbose 0755 "$new_dir";
new_dir="/home/i/desktop/"
mkdir -pv "$new_dir"; chown --verbose --changes  i:i "$new_dir"; chmod --verbose 0755 "$new_dir";

echo 'en_US' > '/home/i/.config/user-dirs.locale'

config_file='/etc/xdg/user-dirs.defaults';
config_text=$(cat <<_ENDOFFILE
# Default settings for user directories
DESKTOP=downloads
DOWNLOAD=downloads
TEMPLATES=downloads
PUBLICSHARE=public
DOCUMENTS=downloads
MUSIC=downloads
PICTURES=downloads
VIDEOS=downloads
_ENDOFFILE
)
save_var_to_file "$config_file" config_text

