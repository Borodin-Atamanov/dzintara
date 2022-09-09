#!/usr/bin/bash

work_dir='/home/i/github/dzible/';
source "${work_dir}tasks/1.sh"

#set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

fname="/home/i/github/dzible/test2delete/change_config_test.txt"
load_file_to_var "$fname" config
#md5sum $fname

echo -n "$config" | xxd

#echo -e "\n\n\n";
#cat $fname | xxd

fname="/home/i/github/dzible/test2delete/change_config_test2.txt"
save_var_to_file "$fname" config
