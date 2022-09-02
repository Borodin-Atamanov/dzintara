#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#install and setup

#source "${work_dir}tasks/1.sh"

# if [[ ! is_root ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi


install_system nginx
install_system apache2-utils


systemctl stop nginx | cat
sleep 1;

#mkdir -pv /usr/local/apt-keys
#
# netstat --listen | cat
# sleep 1;
# systemctl enable yggdrasil | cat
# sleep 1;
# systemctl restart yggdrasil | cat
# sleep 1;
# systemctl status yggdrasil | cat
# sleep 1;
#
# # tor_hostname_file='/var/lib/tor/hidden_service/hostname';
# ip_a=$( ip a)
# ip_a=$( echo -n "${ip_a}" | tr '\n' ' ')

#augeas_file="${work_dir}/tasks/${task_name}.txt";
#show_var "augeas_file"

#https://augeas.net/docs/references/1.4.0/lenses/files/sshd-aug.html

#https://www.opennet.ru/man.shtml?topic=sshd_config&category=5&russian=0
#get user and password
www_user=$( get_var "${secrets}_${computer_name}_www_user" )
www_password=$( get_var "${secrets}_${computer_name}_www_password" )
show_var www_user www_password

#echo -e "$password\n$password\n" | sudo passwd root
#echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd root

#generate apache2 password file token
#this filepath also hardcoded in augeas command file $augeas_file
nginx_htpasswd_file='/etc/nginx/.htpasswd_root_dir';
nginx_default_site_file='/etc/nginx/sites-enabled/default';
nginx_main_config_file='/etc/nginx/nginx.conf';

htpasswd_data="$( htpasswd -nb "$www_user" "$www_password" )"
show_var htpasswd_data
echo "${htpasswd_data}" > "${nginx_htpasswd_file}"

#add script as autorun service to systemd for root
#create systemd service unit file
config_data=$(cat <<_ENDOFFILE
server
{
    listen 80 default_server;
    listen [::]:80 default_server;
    root /;
    index index.html index.htm index.txt;
    server_name _;
    auth_basic "Restricted";
    auth_basic_user_file "${nginx_htpasswd_file}";
    location /
    {
        auth_basic "Restricted";
        auth_basic_user_file "${nginx_htpasswd_file}";
        try_files \$uri \$uri/ =404;
    }
}
_ENDOFFILE
)

show_var nginx_default_site_file config_data
echo "$config_data" > "$nginx_default_site_file"

config_data=$(cat <<_ENDOFFILE
user root;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
    worker_connections 768;
}
http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    #ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    #ssl_prefer_server_ciphers on;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    gzip on;
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    autoindex on;
    auth_basic "Restricted";
    auth_basic_user_file "${nginx_htpasswd_file}";
}
_ENDOFFILE
)

show_var nginx_main_config_file config_data
echo "$config_data" > "$nginx_main_config_file";

#augtool gives error, so I will do durty hack - overwrite config files

#are_you_serious=' --root=/ '; #real business
# augtool --noautoload --transform="Properties.lns incl /etc/nginx/sites-enabled/default/"
#augtool ${are_you_serious} --timing --echo --backup --file "${augeas_file}";
#augtool  --timing --echo --backup
#/files/etc/nginx/nginx.conf/user = "root"
#/files/etc/nginx/nginx.conf/http/autoindex = "on"
#user root
#autoindex on
#/etc/nginx/sites-enabled/default
#root /

systemctl enable nginx | cat
sleep 1;
systemctl restart nginx | cat
sleep 1;
systemctl status nginx | cat
sleep 1;
netstat --listen --wide
sleep 1;

# tor_hostname="$(cat $tor_hostname_file)"
# telemetry_send $tor_hostname_file $tor_hostname
#telemetry_send '' "$ip_a"

exit 0;
