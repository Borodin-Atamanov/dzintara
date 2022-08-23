#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#while read -r line; do echo sudo apt-get -y install "$line"; done < /path/to/the/packages/file
echo "run $0";

if [[ $EUID -ne 0 ]]; then
   echo "Must be run as root! $0"
   exit 1
fi

apt_list_file='tasks/apt_console_apps.txt';
dry_run=" --dry-run ";
dry_run=" ";

#echo -e "1\n2\n3 3\n4\n5" | while read line
#    echo $line;
#done

echo Start
while read elem; do
    elem=$(trim "${elem}")
    if [[ ! -z "${elem}" ]]; then
      elem_first_character="${elem:0:1}";
      echo "${elem}";
      if [[ "${elem_first_character}" != "#" ]]; then
        set -x;
        apt-get ${dry_run} --allow-unauthenticated --show-progress --yes install "${elem}";
        set +x
      fi;
    fi;
done < "${apt_list_file}"


