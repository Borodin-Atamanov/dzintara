#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install and setup

declare -g -x work_dir='/home/i/github/dzible/'
source "/home/i/github/dzible/tasks/1.sh" #for development

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

#apt-get purge dnscrypt-proxy --yes | cat

#install_system dnscrypt-proxy

config_file='/etc/dnscrypt-proxy/dnscrypt-proxy.toml';
# /lib/systemd/system/dnscrypt-proxy.socket

#https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
#replace global config
config_data=$(cat <<_ENDOFFILE
#listen_addresses = [    '[::]:35353', '0.0.0.0:35353', '127.0.0.53:35353'          ]
max_clients = 1021
user_name = 'root'

# Use servers reachable over IPv4
ipv4_servers = true

# Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
ipv6_servers = true

# Use servers implementing the DNSCrypt protocol
dnscrypt_servers = true

# Use servers implementing the DNS-over-HTTPS protocol
doh_servers = true

# Server must support DNS security extensions (DNSSEC)
require_dnssec = false

# Server must not log user queries (declarative)
require_nolog = false

# Server must not enforce its own blocklist (for parental control, ads blocking...)
require_nofilter = false

# Log level (0-6, default: 2 - 0 is very verbose, 6 only contains fatal errors)
log_level = 0

use_syslog = true

#bootstrap_resolvers = ['9.9.9.11:53', '8.8.8.8:53', '77.88.8.8:53', '1.1.1.1:53', '208.67.222.222:53', '8.8.4.4:53', '149.112.112.112:53', '9.9.9.9:53', '208.67.222.222:53', '77.88.8.1:53', '208.67.220.220:53', '1.0.0.1:53', '208.67.220.220:53', '2a02:6b8::feed:0ff:53', '2606:4700:4700::1111:53', '2a02:6b8:0:1::feed:0ff:53', '2606:4700:4700::1001:53']
#cat << qqqqqq | uniq | sort --random-sort

server_names = ['cloudflare']

[query_log]
file = '/var/log/dnscrypt-proxy/query.log'

[nx_log]
file = '/var/log/dnscrypt-proxy/nx.log'

[sources]

[sources.'public-resolvers']
url = 'https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md'
cache_file = '/var/cache/dnscrypt-proxy/public-resolvers.md'
minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
refresh_delay = 72
prefix = ''
_ENDOFFILE
)
show_var named_conf_file config_data
#echo "$config_data" > "$config_file"

config_file='/etc/systemd/resolved.conf';
config_data=$(cat <<_ENDOFFILE

[Resolve]
#DNS=1.1.1.1:53 9.9.9.11:53 8.8.8.8:53 77.88.8.8:53 208.67.222.222:53 8.8.4.4:53 149.112.112.112:53 9.9.9.9:53 208.67.222.222:53 77.88.8.1:53 208.67.220.220:53 1.0.0.1:53 208.67.220.220:53 2a02:6b8::feed:0ff:53 2606:4700:4700::1111:53 2a02:6b8:0:1::feed:0ff:53 2606:4700:4700::1001:53

DNS=127.0.0.1 ::1 8.8.8.8  1.1.1.1  9.9.9.11 8.26.56.26     208.67.222.222  8.8.4.4  8.20.247.20 149.112.112.112  9.9.9.9       1.0.0.1  208.67.220.220 77.88.8.8  77.88.8.1 2a02:6b8::feed:0ff  2606:4700:4700::1111  2a02:6b8:0:1::feed:0ff  2606:4700:4700::1001

FallbackDNS=77.88.8.8 8.8.8.8 1.1.1.1
DNSSEC=allow-downgrade
DNSSEC=true
DNSOverTLS=yes
Cache=yes
Domains=~.

#FallbackDNS=
#Domains=~.
#LLMNR=no
#MulticastDNS=no
#DNSSEC=no
#DNSOverTLS=opportunistic
#DNSStubListener=yes
_ENDOFFILE
)
echo "$config_data" > "$config_file"
#rm -v "$config_file"

#systemctl stop systemd-resolved | cat
sleep 1.1;

com="systemctl restart systemd-resolved"
show_var com
$com | cat;
sleep 1.1;

com="systemctl status systemd-resolved"
show_var com
$com | cat;

#systemctl disable systemd-resolved | cat

com="systemctl stop dnscrypt-proxy.socket"
show_var com
$com | cat;

sleep 1.1;
com="systemctl stop dnscrypt-proxy"
show_var com
$com | cat;

sleep 1.1;
com="/usr/sbin/dnscrypt-proxy -config $config_file -check"
show_var com
#$com | cat;
sleep 1.1;

com="systemctl start dnscrypt-proxy"
show_var com
#$com | cat;
sleep 1.1;

com="systemctl status dnscrypt-proxy"
show_var com
#$com | cat;
sleep 1.1;

#netstat --listen | cat
com="resolvectl status"
show_var com
$com | cat;


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
