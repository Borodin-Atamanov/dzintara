#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install tor

#source "${work_dir}tasks/1.sh"
#get info about OS

os_codename=$( trim $(lsb_release --short --codename ))
#lsb_release --short --id --codename --description --release = Ubuntu Ubuntu 22.04.1 LTS  22.04 jammy | Debian Debian GNU/Linux 11 (bullseye) 11 bullseye
architecture=$( trim $(dpkg --print-architecture))
#It should output either amd64, arm64, or i386
show_var os_codename
show_var architecture

# https://mkvtoolnix.download/downloads.html
mkvtoolnix_list_file='/etc/apt/sources.list.d/mkvtoolnix.list';
mkvtoolnix_key_file='/usr/share/keyrings/gpg-pub-moritzbunkus.gpg';

wget -qO- https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg  | gpg --dearmor | tee "$mkvtoolnix_key_file" | base32 | wc

mkvtoolnix_list_file_content=$(cat <<_ENDOFFILE
deb [signed-by=${mkvtoolnix_key_file}] https://mkvtoolnix.download/debian/ ${os_codename} main
_ENDOFFILE
)
echo -e "$mkvtoolnix_list_file_content" > "${mkvtoolnix_list_file}"

install_system apt-transport-https
install_system update
install_system mkvtoolnix
install_system mkvtoolnix-gui

exit
