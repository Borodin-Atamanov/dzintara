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


install_system dnscrypt-proxy

exit 0;
named_conf_file='/etc/bind/named.conf';
named_conf_options_file='/etc/bind/named.conf.options'

#replace global bind9 config
config_data=$(cat <<_ENDOFFILE
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
_ENDOFFILE
)
show_var named_conf_file config_data
echo "$config_data" > "$named_conf_file"

#replace global bind9 config
config_data=$(cat <<_ENDOFFILE
options {
	directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
    };
    listen-on port 53 { any; };
    recursion yes;
    allow-recursion { any; };
    allow-query { any; };
    listen-on { any; };
    listen-on-v6 { any; };
    dnssec-validation auto;
};
logging {
        channel default_log {
                file "/var/log/bind/default.log";
                print-time yes;
                print-category yes;
                print-severity yes;
                severity info;
        };

        category default { default_log; };
        category queries { default_log; };
};
_ENDOFFILE
)

show_var named_conf_file config_data
echo "$config_data" > "$named_conf_options_file"

named-checkconf;
exit_code=$?
show_var exit_code

exit
systemctl enable yggdrasil | cat
sleep 1;
systemctl restart yggdrasil | cat
sleep 1;
systemctl status yggdrasil | cat
sleep 1;
ip a | cat
sleep 1;

#TODO set local DNS as main DNS to all links, see " resolvectl status "
#/etc/network/interfaces
#dns-nameservers 127.0.0.53
#

#logs:
#script -q -c "sudo tcpdump -l port 53 2>/dev/null | grep --line-buffered ' A? ' | cut -d' ' -f8" | tee dns.log


# tor_hostname_file='/var/lib/tor/hidden_service/hostname';
ip_a=$( ip a)
ip_a=$( echo -n "${ip_a}" | tr '\n' ' ')

# tor_hostname="$(cat $tor_hostname_file)"
# telemetry_send $tor_hostname_file $tor_hostname
telemetry_send '' "$ip_a"

exit 0;
