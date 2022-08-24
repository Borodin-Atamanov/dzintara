#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
source "${work_dir}/tasks/1.sh"

if [[ $EUID -ne 0 ]]; then
   echo "Must be run as root! $0"
   exit 1
fi

#apt_list_file='tasks/apt_console_apps.txt';
apt_list_file="${work_dir}/tasks/${script_base_name}.txt";
dry_run=" --dry-run ";
dry_run=" ";

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


