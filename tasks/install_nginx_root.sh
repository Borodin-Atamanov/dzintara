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
#${secrets}${root_vault_preffix}
#www_user=$( get_var "www_user" )
www_user=$( get_var "${root_vault_preffix}www_user" )
www_password=$( get_var "${root_vault_preffix}www_password" )
hostname=$( get_var "${root_vault_preffix}hostname" );
show_var www_user www_password
sleep $timeout_0

#echo -e "$password\n$password\n" | sudo passwd root
#echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd root

#generate apache2 password file token
#this filepath also hardcoded in augeas command file $augeas_file
nginx_default_site_file='/etc/nginx/sites-enabled/default';
nginx_main_config_file='/etc/nginx/nginx.conf';
nginx_htpasswd_file='/etc/nginx/.htpasswd_root_dir';
html_header_file='/etc/nginx/.html_header';
html_footer_file='/etc/nginx/.html_footer';

htpasswd_data="$( htpasswd -nb "$www_user" "$www_password" )"
show_var htpasswd_data
echo "${htpasswd_data}" > "${nginx_htpasswd_file}"

#add some html before and after page https://abhij.it/58-2/
html_header_data=$(cat <<_ENDOFFILE
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Directory Listing</title>
    <meta charset="utf-8" />
    <!-- Styles -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/dark.min.css">-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/dark.min.css">
</head>
<body>
  <div id="title">
      <span>Directory Listing</span>
      <span class="stats" id='file-stats'></span>
      <span class="stats" id='dir-stats'></span>
  </div>
  <div id='listing'>
      <div>
_ENDOFFILE
)
echo "$html_header_data" > "$html_header_file"

html_footer_data=$(cat <<_ENDOFFILE
    </div>
  </div>
</body>
    <!-- Script -->
    <script type="text/javascript">
      var pathElement = document.querySelector('#listing h1');
      pathElement.className = 'listing';

      var pathName = pathElement.innerHTML;
      pathName = pathName.replace('Index of ', '');
      pathElement.innerHTML = pathName;

      var fileCount = 0
        ,dirCount = 0
        ,dirStatElem = document.getElementById('dir-stats')
        ,fileStatElem = document.getElementById('file-stats')
      ;

      var allLinks = document.getElementsByTagName('a');
      for (let item of allLinks){
        if (item.innerHTML != "../"){
          if (item.innerHTML.endsWith('/')){
            dirCount += 1;
          }
          else {
            fileCount += 1;
          }
        }
        item.className = "link-icon";
      }

      var parentFolderElement = document.querySelector("a[href='../']");
      parentFolderElement.className = "folderup";
      parentFolderElement.innerHTML = "&#8682; Up";

      if (dirCount == 1){
        dirStatElem.innerHTML = dirCount + " directory";
      }
      else {
        dirStatElem.innerHTML = dirCount + " directories";
      }

      if (fileCount == 1){
        fileStatElem.innerHTML = fileCount + " file";
      }
      else {
        fileStatElem.innerHTML = fileCount + " files";
      }

    </script>
</html>
_ENDOFFILE
)
echo "$html_footer_data" > "$html_footer_file"

#add script as autorun service to systemd for root
#create systemd service unit file
config_data=$(cat <<_ENDOFFILE
server
{
    # listen 80 default_server;
    # listen [::]:80 default_server;
    listen 80;
    listen [::]:80 ipv6only=on;
    listen 443 ssl;
    listen [::]:443 ipv6only=on ssl;

    # Enable SSL
    ssl_certificate ${nginx_self_signed_public_cert_file};
    ssl_certificate_key ${nginx_self_signed_private_key_file};
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv3:+EXP;
    ssl_prefer_server_ciphers on;

    root /;
    index index.html index.htm index.txt;
    server_name "${hostname}_";
    auth_basic "${hostname}: ACCESS DENIED";
    auth_basic_user_file "${nginx_htpasswd_file}";

    location "${nginx_shared_dir}"
    {
        auth_basic "off";
        # this directory is shared
    }

    location @error401
    {
        return 302 "${nginx_shared_dir}";
    }

    location /
    {
        auth_basic "${hostname}: ACCESS DENIED!";
        auth_basic_user_file "${nginx_htpasswd_file}";
        try_files \$uri \$uri/ =404;
        #error_page 401 = @error401;
        # if user didnt enter correct login and password - redirect him/her to page without auth_basic
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
    #default_type application/octet-stream;
    default_type text/plain;
    #ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    #ssl_prefer_server_ciphers on;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    gzip on;
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    autoindex on;
    autoindex_localtime on;
    index       nothing_will_match_this_string;
    add_before_body        "$html_header_file";
    add_after_body         "$html_footer_file";
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

# generate self signed cert.
#declare_and_export nginx_self_signed_private_key_file '/etc/ssl/private/nginx-selfsigned.key'; # private self-signed key for https
#declare_and_export nginx_self_signed_public_cert_file '/etc/ssl/certs/nginx-selfsigned.crt'; # public self-signed key for https

#openssl req -x509 -out localhost.cert -keyout localhost.key -newkey rsa:2048 -nodes -sha256 -subj '/CN=localhost' -extensions EXT -config <( \ printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

#openssl req -x509 -nodes -days 111111 -newkey rsa:2048 -keyout "$nginx_self_signed_private_key_file" -out "$nginx_self_signed_public_cert_file" -config "$temp_config_file"
openssl req -x509 -nodes -days 111111 -newkey rsa:2048 -keyout "$nginx_self_signed_private_key_file" -out "$nginx_self_signed_public_cert_file" -subj "/C=GB/ST=London/L=London/O=Dzintara/OU=Dzintara/CN=Dzintara.com"


#Enable nginx  only if password and user name are not empty
if [ ! -z "$www_user" ] &&  [ ! -z "$www_password" ] ; then
  systemctl enable nginx | cat
  sleep 1;
fi;

systemctl restart nginx | cat
sleep 1;
systemctl status nginx | cat
sleep 1;
netstat -tulpn
sleep 1;

#create shared without auth directory
mkdir -pv "${nginx_shared_dir}"
chown --verbose --changes root:root "${nginx_shared_dir}";
chmod --verbose 0777 "${nginx_shared_dir}";
touch "${nginx_shared_dir}/share.txt"
chown --verbose --changes root:root "${nginx_shared_dir}/share.txt";
chmod --verbose 0644 "${nginx_shared_dir}/share.txt";

# tor_hostname="$(cat $tor_hostname_file)"
# telemetry_send $tor_hostname_file $tor_hostname
#telemetry_send '' "$ip_a"

exit 0;
