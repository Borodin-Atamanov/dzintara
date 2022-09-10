#!/usr/bin/bash
#script generate  "vault" from user input

#load all functions and variables
old_dir=$(pwd)
cd ..
source index.sh fun
cd "$old_dir"

#global var:
#telemetry_vault_file


fname="$(ymdhms)-$(random_str 4)$(random_str 3).txt"
crypted_file="${fname%.*}.crypt";

exit 0
#encrypt all files with plain data
#echo $crypted_file
# load data from file to variable
fname=$(basename $telemetry_original_vault_file)
crypted_file="${fname%.*}.crypt";
file_data=$(cat "public_telemetry_tokens.txt");
#echo  $file_data;
#encrypt data with master_password
encrypted_data=$( encrypt_aes "${telemetry_vault_file}" "${file_data}"; )
echo -n "${encrypted_data}" > "${crypted_file}";
show_var fname crypted_file
cat "${crypted_file}"

echo "";

random_pass=$(random_str 6000)
#random_str 6
echo -e "${random_pass}\n\n\n";
#echo "${preffix}"

data=$(cat $0);
pass='89546324othffqwherqwerhkgfqwlehyqweiurqiweuyrfwiwehfqwhgiqweufvq485763426b5782394hf9823jd9';
encrypted_data=$( encrypt_aes "${pass}" "${data}"; )
decrypted_data=$(decrypt_aes "${pass}" "${encrypted_data}")
echo "decrypt_aes_error=${decrypt_aes_error}";
echo "Original data:"
md5 "${data}";
echo "encrypted_data:"
md5 "${encrypted_data}";
echo "decrypted_data:"
md5 "${decrypted_data}";

exit 111;
