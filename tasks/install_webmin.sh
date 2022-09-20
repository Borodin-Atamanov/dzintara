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



install_system apt-transport-https
install_system update
install_system webmin

systemctl stop webmin

#change config
fname='/etc/webmin/miniserv.conf';
load_var_from_file "$fname" config
replace_line_by_string config "port=" "port=${webmin_port}" "#"
replace_line_by_string config "listen=" "listen=${webmin_port}" "#"
#TODO add miltiline listen here to listen ipv6 too
replace_line_by_string config "ssl=" "ssl=1" "#"
replace_line_by_string config "ipv6=" "ipv6=1" "#"
replace_line_by_string config "blockhost_failures=" "blockhost_failures=11" "#"
replace_line_by_string config "blockhost_time=" "blockhost_time=77" "#"
save_var_to_file "$fname" config


# to redirect from ipv6 to ipv4 use :
# For TCP: echo -n 80 443 25 3389| xargs -d ' ' -I% bash -c 'socat TCP4-LISTEN:%,fork TCP6:[IP6HERE]:% &'
# For UDP: echo -n 9987 8443| xargs -d ' ' -I% bash -c 'socat UDP4-LISTEN:%,fork UDP6:[IP6HERE]:% &'



# listen x.x.x.x;
# listen [x:x:x:x:x:x:x:x];
# listen x.x.x.x:443 ssl;
# listen [x:x:x:x:x:x:x:x]:443 ssl;
# ssl_certificate /var/www/vhosts/testvps/ssl.cert;
# ssl_certificate_key /var/www/vhosts/testvps/ssl.key;


#[ -n "$DISTRIB_CODENAME1231" ] || { echo "no variable set"; }
#[ ! -n "$QT_PLATFORM_PLUGIN" ] || { echo "setted variable"; }

systemctl restart webmin | cat
systemctl status webmin | cat
sleep $timeout_1

exit 0;
