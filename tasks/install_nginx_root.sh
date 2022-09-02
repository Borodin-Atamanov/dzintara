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


augeas_file="${work_dir}/tasks/${task_name}.txt";
show_var "augeas_file"

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
htpasswd_data="$( htpasswd -nb "$www_user" "$www_password" )"
show_var htpasswd
echo "${htpasswd_data}" > "${nginx_htpasswd_file}"

are_you_serious=' --root=/ '; #real business

augtool ${are_you_serious} --timing --echo --backup --file "${augeas_file}";
#augtool  --timing --echo --backup
#/files/etc/nginx/nginx.conf/user = "root"
#/files/etc/nginx/nginx.conf/http/autoindex = "on"
#user root
#autoindex on
#/etc/nginx/sites-enabled/default
#root /

# server {
#     listen portnumber;
#     server_name ip_address;
# location /
#       {
#         root /
#         var / www / mywebsite.com;
#       index index.html index.htm;
#       auth_basic "Restricted";
#       #For Basic Auth
#       auth_basic_user_file /etc/nginx/.htpasswd
#       #For Basic Auth
#     }
# }

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
