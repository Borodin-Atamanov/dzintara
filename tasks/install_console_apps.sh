#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#while read -r line; do echo sudo apt-get -y install "$line"; done < /path/to/the/packages/file
echo "run $0";
#echo -e "1\n2\n3 3\n4\n5" | while read line
#    echo $line;
#done
pwd;
echo "${temp_dir_for_bin}";
apt_list_file='tasks/apt_console_apps.txt';
echo Start
while read elem; do 
    if [[ ! -z "${elem}" ]]; then
      echo "${elem}";
      apt-get --dry-run --allow-unauthenticated --show-progress --yes install "${elem}";
    fi;
done < "${apt_list_file}"


