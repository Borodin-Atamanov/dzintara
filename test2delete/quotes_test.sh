#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}tasks/1.sh"

#set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

vari=\
' приветики


'"'"'Yo!'"'"'

'"'"'
Как ты? '"'"'

';

#search_and_replace vari "'" '"'"'
echo "Original: ";
echo "$vari"
bin_2_hex vari
echo "bin_2_hex : ";
echo "$vari"
hex_2_bin vari
echo "hex_2_bin : ";
echo "$vari"
