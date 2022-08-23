#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#wget -qO - t.ly/mHc_ | bash

#function yell() { echo "$0: $*" >&2; }
#function die() { yell "$*"; exit 111; }
#function try() { "$@" || die "cannot $*"; }

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

#TODO read password from special file or from input

function run_task ()
{
  if [[ "${test_mode}" = "1" ]]; then
    task_script="tasks/${1}.sh";
  else
    task_script="${temp_dir_for_bin}/tasks/${1}.sh";
  fi
  task_script="tasks/${1}.sh";
  echo "$0 [[${task_script}]]";
  ( exec "${task_script}" );
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


apt-get -y install git
apt-get install openssl

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode, so don't clone github";
else
  echo "clone scripts from github";
  temp_dir_for_bin="temp_dir_for_bin-$(date "+%F-%H-%M-%S")"; \
  mkdir -pv "${temp_dir_for_bin}";
  git clone --verbose --progress --depth 1 https://github.com/Borodin-Atamanov/dzible.git "${temp_dir_for_bin}";
  cd "${temp_dir_for_bin}";
fi


#TODO dectypt master password file, load all secret variables
#TODO check master_pass value, if not set - ask from user

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode";
else
  echo 1;
  run_task "add_screen_resolution_1280x1024_with_xrandr"
fi

#"${temp_dir_for_bin}/tasks/add_screen_resolution_1280x1024_with_xrandr.sh"
#"${temp_dir_for_bin}/tasks/install_console_apps.sh"
run_task "install_console_apps"

run_task new_root_setup
run_task sshd_setup
run_task user_i_setup
run_task
run_task
run_task
run_task
run_task

exit 111;



