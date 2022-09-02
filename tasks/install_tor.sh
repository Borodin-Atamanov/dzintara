#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install tor

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi


install_system apt-transport-https
install_system lsb-release

#get info about OS

os_codename=$( trim $(lsb_release --short --codename ))
#lsb_release --short --id --codename --description --release = Ubuntu Ubuntu 22.04.1 LTS  22.04 jammy | Debian Debian GNU/Linux 11 (bullseye) 11 bullseye
architecture=$( trim $(dpkg --print-architecture))
#It should output either amd64, arm64, or i386
show_var os_codename
show_var architecture



tor_list_file='/etc/apt/sources.list.d/tor.list';
tor_key_file='/usr/share/keyrings/tor-archive-keyring.gpg';

wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee "$tor_key_file" | base64 | wc

tor_list_file_content=$(cat <<_ENDOFFILE
deb     [signed-by=${tor_key_file}] https://deb.torproject.org/torproject.org ${os_codename} main
deb-src [signed-by=${tor_key_file}] https://deb.torproject.org/torproject.org ${os_codename} main

_ENDOFFILE
)
echo -e "$tor_list_file_content" > "${tor_list_file}"

install_system update
install_system tor deb.torproject.org-keyring

#[ -n "$DISTRIB_CODENAME1231" ] || { echo "no variable set"; }
#[ ! -n "$QT_PLATFORM_PLUGIN" ] || { echo "setted variable"; }


torsocks_conf_file='/etc/tor/torsocks.conf';
torrc_conf_file='/etc/tor/torrc';

torsocks_config_overwrite_file="${work_dir}/tasks/${task_name}_owerwrite_torsocks.txt";
torrc_config_overwrite_file="${work_dir}/tasks/${task_name}_overwrite_torrc.txt";

slog "<7>Update tor config files $torsocks_conf_file $torsocks_config_overwrite_file $torrc_conf_file $torrc_config_overwrite_file";

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

#Durty hack: just append config files, because its hard to use augtool in this case
echo $( ymdhms ) > "$torrc_conf_file"
echo $( ymdhms ) > "$torsocks_conf_file"
cat "$torrc_config_overwrite_file" >> "$torrc_conf_file"
cat "$torsocks_config_overwrite_file" >> "$torsocks_conf_file"

#TODO check config before run, if config is wrong - recover old config version

netstat --listen | cat
systemctl enable tor | cat
systemctl restart tor | cat
systemctl status tor | cat
systemctl restart tor@default.service | cat
systemctl status tor@default.service | cat

exit 0;
