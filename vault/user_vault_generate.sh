#!/usr/bin/bash
#script generate  "vault" from user input

#load all functions and variables
old_dir=$(pwd)
cd ..
source index.sh fun
cd "$old_dir"

#global var:
#telemetry_vault_file


plain_data="some data to encrypt_aes"
password="some pass"
declare -g -x password
read_var password "Enter password to encrypt data: "

encrypted_data=$( encrypt_aes "${password}" "${plain_data}"; )

fname="$(ymdhms)-$(random_str 4)$(random_str 3).txt"
crypted_file="${fname%.*}.crypt";

echo -n "${encrypted_data}" > "${crypted_file}";
show_var crypted_file

load_var_from_file "${crypted_file}" encrypted_data2

show_var encrypted_data2

decrypted_data=$( decrypt_aes "${password}" "${encrypted_data2}")
show_var decrypted_data

exit 0
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
