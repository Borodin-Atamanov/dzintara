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


echo -e "\n\n";
#set -x
# search_and_replace_hex vari "0a 27" "34"
# search_and_replace_hex vari "0a" "34"
# search_and_replace_hex vari "27" ""
# search_and_replace_hex vari "20" ""
search_and_replace_hex vari "27" "27 22 27 22 27"
#27 ->
set +x

echo "after replace: ";
echo "$vari"

exit 0

#search_and_replace vari "'" '"'"'
echo "Original: ";
echo "$vari"
bin_2_hex vari
echo "bin_2_hex : ";
echo "$vari"
hex_2_bin vari
echo "hex_2_bin : ";
echo "$vari"

