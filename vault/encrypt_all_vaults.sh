#!/usr/bin/bash
#script encode all "vault/*plain*" files with AES, same with save names, and '*.crypt' extension

#load all functions and variables
old_dir=$(pwd)
cd ..
source /home/i/github/dzintara/index.sh fun
cd "$old_dir"

#echo "master_password_file='${master_password_file}'";

#ask for master_password if it is not set
#read -s -p "master_password" master_password; export master_password;
# # echo "${master_password}";
# if [[ -v master_password ]];
# then
#     echo "master_password is already set"
# else
#     echo "master_password is not set";
#     if [ -s "${master_password_file}" ]
#     then
#         echo "${master_password_file} file is not empty, load master_password from it"
#         master_password_from_file=$(cat "${master_password_file}");
#         master_password_from_file=$(trim "${master_password_from_file}");
#         #echo "master_password_from_file length is ${#master_password_from_file}";
#         md5_of_master_password_from_file=$(md5 "${master_password_from_file}");
#         echo "md5_of_master_password_from_file=${md5_of_master_password_from_file}";
#         master_password="${master_password_from_file}"
#     else
#         echo "${master_password_file} file is empty"
#         read -s -p "Enter master_password (Password will not shown):" master_password;
#     fi
#     echo "master_password length is ${#master_password}";
#     #export master_password="${master_password}";
#     export master_password;
# fi
# md5_of_master_password=$(md5 "${master_password}");
# echo "md5_of_master_password=${md5_of_master_password}";


#encrypt all files with plain data
cd "vault";
for f in *.plain; do
(
  echo -e "\n\n\n>>${f}<< ";
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
    #encrypted_data=$( encrypt_aes "${master_password}" "${file_data}"; )
    #set  -x
    encrypt_aes file_data "${master_password}";
    set +x
    #echo -n "${encrypted_data}" > "${crypted_file}";
    save_var_to_file "$crypted_file" file_data
    [ -s "${crypted_file}" ] && echo "crypted to ${crypted_file}, passlen=${#master_password}, datalen=${#file_data}";
    #echo "$encrypted_data";
  else
    echo "files not exists : ${password_file} ${f}"
  fi
)
done;
#cd "..";

aexit;

countdown 7 0.01

echo 'Try to decrypt'
cd "vault";
# check encryption with decryption
for f in *.crypt; do
(
  echo -e "\n\n\n####${f}#### ";
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
    #decrypted_data=$( decrypt_aes "${master_password}" "${file_data}"; )
    decrypt_aes file_data "${master_password}"
    #echo -n "${encrypted_data}" > "${crypted_file}";
    show_var file_data
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
