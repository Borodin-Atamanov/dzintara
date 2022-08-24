#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#change config with augeas

source ."${work_dir}/tasks/1.sh"

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

script_base_name=$(basename "${0}");
script_base_name="${script_base_name%.*}";
echo $script_base_name;
augeas_file="tasks/${script_base_name}.txt";
show_var "augeas_file"
cat $augeas_file;

exit 111;

dry_run=" ";
dry_run=" --new  ";

augtool ${dry_run} --timing --echo --backup  --root="/dev/shm/augeas-sandbox" --file "${augeas_file}";


