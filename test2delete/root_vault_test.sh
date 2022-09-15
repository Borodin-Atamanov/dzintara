#!/usr/bin/bash
#script generate  "vault" from user input

#load all functions and variables
old_dir=$(pwd)
cd ..
source index.sh fun
cd "$old_dir"

#uses vars:
#"${root_vault_file}"
#"${root_vault_password_file}"

root_vault_file='/tmp/root_vault_file'
root_vault_password_file='/tmp/root_vault_password_file'

false && {
p1='passwd';
d1='data'
encrypt_aes d1 "$p1"
show_var d1

save_var_to_file "$root_vault_password_file" p1
p1hex="$p1"
bin_2_hex p1hex
show_var p1hex p1
load_var_from_file "$root_vault_password_file" p2
trim_var p2
p2hex="$p2"
bin_2_hex p2hex
show_var p2hex p2

decrypt_aes d1 "$p2"
show_var d1

exit
}


rm -v "$root_vault_file"
rm -v "$root_vault_password_file"

generate_and_save_root_vault

show_var root_vault_file root_vault_password_file

cat $root_vault_password_file
echo ''
cat $root_vault_file

load_var_from_file $root_vault_file data2
load_var_from_file $root_vault_password_file pass2
echo ''
show_var pass2 data2

decrypt_aes data2 "$pass2"
# doesnt work!  ^
show_var data2
exit

data="СЕКРЕТИКИ!"
sdata=$data
data_hex="$data"
bin_2_hex data_hex
show_var data_hex data
encrypt_aes data $sdata
set +x
show_var data
decrypt_aes data $sdata
data_hex="$data"
bin_2_hex data_hex
show_var data_hex data
#set -x
#

#save_root_vault

