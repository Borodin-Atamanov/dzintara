#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install and setup

# declare -g -x work_dir='/home/i/github/dzible/'
# source "/home/i/github/dzible/tasks/1.sh" #for development

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

#apt-get purge openresolv
#system_install resolvconf

config_file='/etc/systemd/resolved.conf';
config_data=$(cat <<_ENDOFFILE

[Resolve]
#DNS=1.1.1.1:53 9.9.9.11:53 8.8.8.8:53 77.88.8.8:53 208.67.222.222:53 8.8.4.4:53 149.112.112.112:53 9.9.9.9:53 208.67.222.222:53 77.88.8.1:53 208.67.220.220:53 1.0.0.1:53 208.67.220.220:53 2a02:6b8::feed:0ff:53 2606:4700:4700::1111:53 2a02:6b8:0:1::feed:0ff:53 2606:4700:4700::1001:53

DNS=1.1.1.1  9.9.9.11 127.0.0.1 ::1 8.8.8.8   8.26.56.26     208.67.222.222  8.8.4.4  8.20.247.20 149.112.112.112  9.9.9.9       1.0.0.1  208.67.220.220 77.88.8.8  77.88.8.1 2a02:6b8::feed:0ff  2606:4700:4700::1111  2a02:6b8:0:1::feed:0ff  2606:4700:4700::1001

FallbackDNS=77.88.8.8 8.8.8.8 1.1.1.1
#DNSSEC=allow-downgrade
DNSSEC=true
DNSOverTLS=yes
Cache=yes
Domains=~.
LLMNR=no
MulticastDNS=no
DNSStubListener=no
_ENDOFFILE
)
#systemd-resolve --set-dnssec=yes --set-dns=1.1.1.1 --set-dnsovertls=yes --interface=wlan0
echo "$config_data" > "$config_file"
#rm -v "$config_file"
mkdir -pv '/etc/systemd/resolved.conf.d'
cp "$config_file" '/etc/systemd/resolved.conf.d/dzible.conf'

echo "nohook resolv.conf" >> '/etc/dhcpcd.conf'

config_file='/etc/resolv.conf';
config_data=$(cat <<_ENDOFFILE
nameserver 127.0.0.53
nameserver 127.0.0.1:5353
_ENDOFFILE
)
#systemd-resolve --set-dnssec=yes --set-dns=1.1.1.1 --set-dnsovertls=yes --interface=wlan0

echo "$config_data" > "$config_file"

#systemctl stop systemd-resolved | cat
sleep 1.1;

com="systemctl restart systemd-resolved"
show_var com
$com | cat;
sleep 1.1;

com="systemctl enable systemd-resolved"
show_var com
$com | cat;

com="systemctl status systemd-resolved"
show_var com
$com | cat;

#systemctl disable systemd-resolved | cat

#netstat --listen | cat
com="resolvectl status"
show_var com
$com | cat;
sleep 1.1;

com="dig facebook.com"
show_var com
$com | cat;
sleep 1.1;

#systemctl disable --now avahi-daemon.service
#systemctl disable --now avahi-daemon.socket
exit 0;

#script -q -c "sudo tcpdump -l port 53 2>/dev/null | grep --line-buffered ' A? ' | cut -d' ' -f8" | tee dns.log
# tcpdump -l port 53 2>/dev/null | grep --line-buffered ' A? ' | cut -d' ' -f8

# tor_hostname_file='/var/lib/tor/hidden_service/hostname';
ip_a=$( ip a)
ip_a=$( echo -n "${ip_a}" | tr '\n' ' ')

# tor_hostname="$(cat $tor_hostname_file)"
# telemetry_send $tor_hostname_file $tor_hostname
telemetry_send '' "$ip_a"

exit 0;
