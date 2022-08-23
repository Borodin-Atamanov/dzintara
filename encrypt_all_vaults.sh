#!/usr/bin/bash
master_password_file='master_password.txt';

function encrypt_aes ()
{
  passkey="${1}"
  data="${2}"
  #openssl enc -in PrimaryDataFile -out EncryptedDataFile -e -aes256 -pass "${passkey}" -pbkdf2
  echo -n "${data}" | openssl enc -e -aes-256-cbc -pbkdf2  -pass "pass:${passkey}" | openssl base64 -e;
}
export -f encrypt_aes

function decrypt_aes ()
{
  decrypt_error=0;
  passkey="${1}"
  data="${2}"
  echo -n "${data}" | openssl base64 -d | openssl enc -d -aes-256-cbc -pbkdf2  -pass "pass:${passkey}";
  decrypt_aes_error=$?
}
export -f decrypt_aes

function md5 ()
{
    echo   -n "${1}" | md5sum | awk '{print $1}'
}
export -f md5

function random_str ()
{
    len="${1}";
    vowels="euioa";
    consonants="rtpsdfgklzxvbnm";
    random_str=;
    for y in `seq 1 ${len}`; do
        for x in `seq 1 2`; do
            random_str="${random_str}${consonants:$(( RANDOM % ${#consonants} )):1}${vowels:$(( RANDOM % ${#vowels} )):1}";
        done;
    done;
    random_str="${random_str:$(($RANDOM % 2)):${len}}";
    echo -n "${random_str}";
}
export -f random_str

function trim()
{
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    printf '%s' "$var"
}
export -f trim

#ask for master_password if it is not set
#read -s -p "master_password" master_password; export master_password;
# echo "${master_password}";
if [[ -v master_password ]];
then
    echo "master_password is already set"
else
    echo "master_password is not set";
    if [ -s "${master_password_file}" ]
    then
        echo "${master_password_file} file is not empty, load master_password from it"
        master_password_from_file=$(cat "${master_password_file}");
        master_password_from_file=$(trim "${master_password_from_file}");
        #echo "master_password_from_file length is ${#master_password_from_file}";
        md5_of_master_password_from_file=$(md5 "${master_password_from_file}");
        echo "md5_of_master_password_from_file=${md5_of_master_password_from_file}";
        master_password="${master_password_from_file}"
    else
        echo "${master_password_file} file is empty"
        read -s -p "Enter master_password (Password will not shown):" master_password;
    fi
    echo "master_password length is ${#master_password}";
    #export master_password="${master_password}";
    export master_password;
fi
md5_of_master_password=$(md5 "${master_password}");
echo "md5_of_master_password=${md5_of_master_password}";

#encrypt all files with plain data
cd "vault";
for f in *plain*; do
(
  echo $f;
  #echo "${f%.*.*}";
  crypted_file="${f%.*}.crypt";
  #echo $crypted_file
  # load data from file to variable
  file_data=$(cat "${f}");
  #echo  $file_data;
  #encrypt data with master_password
  encrypted_data=$( encrypt_aes "${master_password}" "${file_data}"; )
  echo -n "${encrypted_data}" > "${crypted_file}";
  #echo "$encrypted_data";
)
done;
cd "..";

exit 111;

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
