#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install and setup

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi


install_system dirmngr
install_system gpg
install_system apt-transport-https

#get info about OS

os_codename=$( trim $(lsb_release --short --codename ))
#lsb_release --short --id --codename --description --release = Ubuntu Ubuntu 22.04.1 LTS  22.04 jammy | Debian Debian GNU/Linux 11 (bullseye) 11 bullseye
architecture=$( trim $(dpkg --print-architecture))
#It should output either amd64, arm64, or i386
show_var os_codename
show_var architecture

#https://yggdrasil-network.github.io/installation-linux-deb.html

mkdir -pv /usr/local/apt-keys

#wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee "$tor_key_file" | base64 | wc
deb_server_addr='https://neilalexander.s3.dualstack.eu-west-2.amazonaws.com/deb/'

gpg --fetch-keys ${deb_server_addr}key.txt

gpg --export 569130E8CA20FBC4CB3FDE555898470A764B32C9 | tee /usr/local/apt-keys/yggdrasil-keyring.gpg  | base64 | wc


list_file='/etc/apt/sources.list.d/yggdrasil.list';
key_file='/usr/local/apt-keys/yggdrasil-keyring.gpg';

list_file_content=$(cat <<_ENDOFFILE
deb [signed-by=$key_file] $deb_server_addr debian yggdrasil
_ENDOFFILE
)
echo -e "$list_file_content" > "${list_file}"

#[ -n "$DISTRIB_CODENAME1231" ] || { echo "no variable set"; }
#[ ! -n "$QT_PLATFORM_PLUGIN" ] || { echo "setted variable"; }

#slog "<7>Update tor config files $torsocks_conf_file $torsocks_config_overwrite_file $torrc_conf_file $torrc_config_overwrite_file";

# augeas_file_torsocks="${work_dir}/tasks/${task_name}_torsocks.txt";
# augeas_file_torrc="${work_dir}/tasks/${task_name}_torrc.txt";
#show_var augeas_file_torsocks augeas_file_torrc

#are_you_serious=' --root=/ '; #real business
#augtool --new --noautoload --transform="Properties.lns incl ${torsocks_conf_file}" --file "${augeas_file_torsocks}"
#augtool --new --noautoload --transform="Properties.lns incl /etc/tor/torsocks.conf"
#AllowInbound 1

#augtool --new --noautoload --transform="Properties.lns incl ${torrc_conf_file}" --file "${augeas_file_torrc}"
#/etc/tor/torrc
#augtool --new --noautoload --transform="IniFile.lns incl /etc/tor/torrc"


#TODO check config before run, if config is wrong - recover old config version

#chown  -v -R debian-tor:debian-tor /var/lib/tor/
#chmod -v -R 700  /var/lib/tor/
#systemctl restart tor; journalctl -f -t tor

netstat --listen | cat
sleep 1;
systemctl enable yggdrasil | cat
sleep 1;
systemctl restart yggdrasil | cat
sleep 1;
systemctl status yggdrasil | cat
sleep 1;

# tor_hostname_file='/var/lib/tor/hidden_service/hostname';
# tor_hostname="$(cat $tor_hostname_file)"
# telemetry_send $tor_hostname_file $tor_hostname

exit 0;
