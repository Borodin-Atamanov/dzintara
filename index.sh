#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT

#Script contains 3 parts
#1. function definition
#2. initialisation: set variables, etc
#3. run tasks

#wget -qO - https://raw.githubusercontent.com/Borodin-Atamanov/dzible/main/index.sh | sudo bash
#wget -qO - clck.ru/uRPBG | sudo bash

function run_task ()
{
  export task_name="${1}";
  if [[ "${test_mode}" = "1" ]]; then
    task_script="tasks/${1}.sh";
  else
    task_script="${work_dir}/tasks/${1}.sh";
  fi
  task_script="tasks/${1}.sh";
  if [ -s "${task_script}" ]
  then
    echo "$0 [[${task_script}]]";
    #TODO add arguments to task
    #shift arguments with shift --help

    (
      #run 1.sh before every task. Send full task path as $1 to 1.sh
      source "${work_dir}tasks/1.sh" "${work_dir}${task_script}";
      #run task script
      "${work_dir}${task_script}";
    );
  else
    echo "$0 no task_script file ${task_script}! 🤷‍";
  fi
}

function err()
{
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

function run()
{
  cmd_output=$(eval $1)
  return_value=$?
  if [ "$return_value" != 0 ]; then
    echo "Command $1 failed"
    exit -1
  else
    echo "output: $cmd_output"
    echo "Command succeeded."
  fi
  return $return_value
}

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
  decrypt_aes_error=0;
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

function base64_encode ()
{
  data="${1}"
  echo -n "${data}" | openssl base64 -e -A | tr -d \\n;
}
export -f base64_encode

function base64_decode ()
{
  data="${1}"
  echo -n "${data}" | openssl base64 -d
  decrypt_error=$?;
}
export -f base64_decode

function save_var_in_base64 ()
{
  varname="${1}"
  value="${2}"
  value=$(base64_encode "${value}");
  echo -n 'declare -g -x ';
  echo -n "${varname}";
  echo -n '=$(echo';
  echo -n " '${value}' ";
  echo -n ' | openssl base64 -d );  ';
  #result will be like this "var=$(echo 'dmFyaWFibGUgaXMgaGVyZQ=='  | openssl base64 -d);"
  echo "";
}
export -f save_var_in_base64

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

function declare_and_export ()
{
  varname="${1}"
  value="${2}"
  declare -g "$varname=$value";
  export "$varname=$value";
  #echo "$varname=$value";
  echo "declare [$varname]";
}
export -f declare_and_export

function get_var ()
{
  varname="${1}";
  #declare -g "get_var_last_name=$varname";
  #export "get_var_last_name=$varname";
  #return value of variable with name "$varname"
  echo -n "${!varname}";
}
export -f get_var

function show_var ()
{
  varname="${1}";
  echo -n "$varname=";
  echo '"'$( get_var "${varname}" )'"';
}
export -f show_var

function cvt_xrandr ()
{
  #function add new screen resolution to xrandr  with cvt
  width="${1}";  width=$((width / 8 * 8));
  height="${2}";
  fps="${3}";

  #acitve connected_display (HDMI-1, AVI-1, etc)
  connected_display=$(xrandr | grep " connected " | awk '{ print$1 }')
  mode_line="$(cvt ${width} ${height} ${fps} | grep odeline )"
  #line with target screen mode
  echo "${mode_line}"
  #array with target screen mode
  declare -a mode_arr=(${mode_line})
  echo "${mode_arr[1]}";
  mode_name="${mode_arr[1]}";
  #remove quotes from mode_name with echo and eval
  #mode_name="echo ${mode_name}";
  #mode_name=$(eval ${mode_name})
  #${resolution[@]/Modeline/xrandr --newmode}
  xrandr --newmode $mode_name ${mode_arr[2]} ${mode_arr[3]} ${mode_arr[4]} ${mode_arr[5]} ${mode_arr[6]} ${mode_arr[7]} ${mode_arr[8]} ${mode_arr[9]} ${mode_arr[10]} ${mode_arr[11]} ${mode_arr[12]} ${mode_arr[13]} ${mode_arr[14]}
  xrandr --addmode $connected_display $mode_name
  xrandr --output $connected_display --mode $mode_name
  #fallback to previous mode if new mode is not ok
  xrandr --output $connected_display --auto
}
export -f cvt_xrandr

function awkcalc ()
{
  awk "BEGIN { print $* }"
}
export -f awkcalc

function wait_for ()
{
    #function wait $1 seconds or return if all other arguments return true;
    #any non-empty and none-zero returned value sting is true
    #use:
    #wait_for 12 'echo $((RANDOM % 2));'
    #wait_for 100 "ps -e | grep -c Xorg"
    #if ("$@" &> /dev/null); then echo 1; else echo 0; fi;
    #if [ "$(ps -e | grep -c Xorg)" -ge 1 ]; then echo 111; else echo 000; fi;
    timeout=$1
    shift 1
    #until [ $timeout -le 0 ] || ("$@" &> /dev/null);
    #until [ $timeout -le 0 ] || [ "${returned_value}" ];

    while [ $timeout -ge 0 ]
    do
      #echo "$@";
      #ret_val=$("$@"); #get text value from command
      command="$@";
      ret_val=$(eval "${command}" );
      ret_val=$(trim "$ret_val");
      #returned_value=$?
      #show_var ret_val;
      if [[ "${ret_val}" != "" ]] && [[ "${ret_val}" != 0 ]]  ; then return 1; fi;
      sleep 1;
      timeout=$(( timeout - 1 ))
    done
}
export -f wait_for

function is_process_running
{
  #use: if [ "$(is_process_running Xorg)" -ge 1 ]; then echo 111; else echo 000; fi;
  app="${1}";
  if [ "$(ps -e | grep --ignore-case --count "${app}")" -ge 1 ];
  then
    echo -n 1;
    return 1;
  else
    echo -n "";
    return 0;
  fi;
}
export -f is_process_running

declare_and_export master_password_file 'master_password.txt'
declare_and_export function_loaded "1"
declare_and_export cur_date_time "$(date "+%F-%H-%M-%S")"
declare_and_export install_dir "/home/i/bin/dzible/"
declare_and_export crypted_vault_file 'vault/1.crypt'
declare_and_export computer_name 'pipyau'

#preffix for vault variables names
declare_and_export secrets 'secrets'
#TODO ask target computer name on script start

set +x

if [[ "$1" != "fun" ]]; then
set -x

echo "$0";
if [[ "$0" = "./index.sh" ]]; then
    test_mode=1;
else
    test_mode=0;
fi

if [[ "${test_mode}" = "1" ]]; then
    echo "local test mode on";
else
    echo "local test mode off";
fi

apt-get -y install git
apt-get -y install openssl

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode, so don't clone github";
else
  echo "clone scripts from github";
  work_dir="work_dir-$(date "+%F-%H-%M-%S")";
  mkdir -pv "${work_dir}";
  git clone --verbose --progress --depth 1 https://github.com/Borodin-Atamanov/dzible.git "${work_dir}";
  # try to copy ${master_password_file} from current directory to work_dir
  cp --verbose --update "${master_password_file}" "${work_dir}/"
  cd "${work_dir}";
fi
work_dir="$(realpath "$(pwd)")/";
declare_and_export work_dir "${work_dir}"

# check master_pass value, if not set - ask from user
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
        echo "${master_password_file} file is empty";
        read -s -p "Enter master_password (Password will not shown):" master_password < /dev/tty;
    fi
    echo "master_password length is ${#master_password}";
    declare_and_export master_password "${master_password}"
    #export master_password;
fi
md5_of_master_password=$(md5 "${master_password}");
echo "md5_of_master_password=${md5_of_master_password}";

#dectypt vault file with master password, load all secret variables
encrypted_data=$(cat "${crypted_vault_file}");
#encrypted_data=$( encrypt_aes "${pass}" "${data}"; )
decrypted_data=$(decrypt_aes "${master_password}" "${encrypted_data}")
echo "decrypt_aes_error=${decrypt_aes_error}";
#echo "$decrypted_data";
#load all variables from decrypted vault
eval "${decrypted_data}";
#echo "secrets_pipyau_root_pass=${secrets_pipyau_root_pass}"
echo "secrets_loaded=${secrets_loaded}"
#echo "Original data:"
#md5 "${data}";

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode";
else
  echo 1;
  run_task add_screen_resolution_1280x1024_with_xrandr
fi

# run_task install_console_apps
# run_task sshd_config
# run_task ssh_config
# run_task root_password_set
# run_task user_i_password_set
# run_task root_password_for_sudoers
run_task install_autorun_script


else
    echo 'functions loaded';
fi; #end of fun if

#to delete script_subversion from script use
#cat index.sh | grep -v '^script_subversion' | tee index-new.sh
export \
script_subversion='ekeko-b48c9e0-2022-08-26-20-12-25'; echo "${script_subversion}=script_subversion"; 