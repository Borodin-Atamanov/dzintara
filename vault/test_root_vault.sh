#!/usr/bin/bash
#script test encoding files with AES

#load all functions and variables
old_dir=$(pwd)
cd ..
source index.sh fun
cd "$old_dir"

  if [ -s "${root_vault_file}" ] && [ -s "${root_vault_password_file}" ]

load_root_vault
save_root_vault
exit 0

#encrypt all files with plain data
cd "vault";
for f in *.plain; do
(
  echo ">>${f}<< ";
  #echo "${f%.*.*}";
  crypted_file="${f%.*}.crypt";
  password_file="${f%.*}.password";
  # if files exists:
  if [ -s "${password_file}" ] && [ -s "${f}" ]; then
    #echo $crypted_file
    # load data from file to variable
    #file_data=$(cat "${f}");
    load_var_from_file "${f}" file_data
    load_var_from_file "${password_file}" master_password
    #echo "password_from_file length is ${#master_password}";
    #echo  $file_data;
    #encrypt data with master_password
    encrypted_data=$( encrypt_aes "${master_password}" "${file_data}"; )
    #echo -n "${encrypted_data}" > "${crypted_file}";
    save_var_to_file "$crypted_file" encrypted_data
    [ -s "${crypted_file}" ] && echo "crypted to ${crypted_file}, passlen=${#master_password}";
    #echo "$encrypted_data";
  else
    echo "files not exists : ${password_file} ${f}"
  fi
)
done;
#cd "..";

countdown 77 0.01

echo 'Try to decrypt'
cd "vault";
# check encryption with decryption
for f in *.crypt; do
(
  echo "####${f}#### ";
  #echo "${f%.*.*}";
  crypted_file="${f%.*}.crypt";
  password_file="${f%.*}.password";
  # if files exists:
  if [ -s "${password_file}" ] && [ -s "${crypted_file}" ]; then
    #echo $crypted_file
    # load data from file to variable
    #file_data=$(cat "${f}");
    load_var_from_file "${f}" file_data
    load_var_from_file "${password_file}" master_password
    #echo "password_from_file length is ${#master_password}";
    #echo  $file_data;
    #encrypt data with master_password
    decrypted_data=$( decrypt_aes "${master_password}" "${file_data}"; )
    #echo -n "${encrypted_data}" > "${crypted_file}";
    show_var decrypted_data
    #save_var_to_file "$crypted_file" encrypted_data
    #[ -s "${crypted_file}" ] && echo "crypted to ${crypted_file}, passlen=${#master_password}";
    #echo "$encrypted_data";
  else
    echo "files not exists : ${password_file} ${crypted_file}"
  fi
)
done;

exit 0;


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
