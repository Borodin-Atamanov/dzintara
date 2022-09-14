#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install tor

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi


#install_system apt-transport-https
#install_system lsb-release

#install_system update

#get info about OS

os_codename=$( trim $(lsb_release --short --codename ))
#lsb_release --short --id --codename --description --release = Ubuntu Ubuntu 22.04.1 LTS  22.04 jammy | Debian Debian GNU/Linux 11 (bullseye) 11 bullseye
architecture=$( trim $(dpkg --print-architecture))
#It should output either amd64, arm64, or i386
show_var os_codename
show_var architecture

#apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python unzip shared-mime-info

webmin_list_file='/etc/apt/sources.list.d/webmin.list';
webmin_key_file='/usr/share/keyrings/jcameron-key.gpg';

wget -qO- https://download.webmin.com/jcameron-key.asc  | gpg --dearmor | tee "$webmin_key_file" | base64 | wc

webmin_list_file_content=$(cat <<_ENDOFFILE
deb [signed-by=/usr/share/keyrings/jcameron-key.gpg] https://download.webmin.com/download/repository sarge contrib
_ENDOFFILE
)
echo -e "$webmin_list_file_content" > "${webmin_list_file}"

install_system  apt-transport-https
install_system update
install_system webmin

#[ -n "$DISTRIB_CODENAME1231" ] || { echo "no variable set"; }
#[ ! -n "$QT_PLATFORM_PLUGIN" ] || { echo "setted variable"; }

exit 0;
