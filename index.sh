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
  shift 1
  #function will send other arguments to executed task as parameters
  #add arguments to task
  arguments="$@";

  if [[ "${test_mode}" = "1" ]]; then
    task_script="tasks/${task_name}.sh";
  else
    task_script="${work_dir}/tasks/${task_name}.sh";
  fi

  echo "████ task ${task_name} ${arguments}████";
  slog "<6>run_task ${task_name} ${arguments}";
  slog "<7>$(show_var task_script) $(show_var task_name) $(show_var arguments)";
  if [ -s "${task_script}" ];  then
    (
      #create countdown process, it show count down before task end by timeout
      countdown_command="timeout --kill-after=2 "${task_max_timeout}" ${work_dir}/tasks/countdown.sh ${task_max_timeout} 0.97 & "
      eval $countdown_command;
      countdown_pid=$!
      slog "<7>countdown_pid=${countdown_pid}";
      #exec -a "${work_dir}${task_script}"
      #run 1.sh before every task. Send full task path as $1 to 1.sh
      source "${work_dir}tasks/1.sh" "${task_script}";
      #run task script
      #add timeout to subshell
      timeout --kill-after=77 "${task_max_timeout}" "${task_script}" ${arguments};
      kill -- -$countdown_pid;
    );
    #kill counter process
    #kill -9 $countdown_pid;
    #killall --verbose "countdown.sh";
    echo -e "----------------------------------------------------------------------- task ${task_name} ${arguments} ended \n\n\n";
  else
    slog "<4>no task_script file ${task_script}! 🤷‍":
  fi
}

function encrypt_aes ()
{
  passkey="${1}"
  data="${2}"
  #openssl enc -in PrimaryDataFile -out EncryptedDataFile -e -aes256 -pass "${passkey}" -pbkdf2
  echo -n "${data}" | openssl enc -e -aes-256-cbc -pbkdf2  -pass "pass:${passkey}" | openssl base64 -e;
  exit_code=$?
}
export -f encrypt_aes

function decrypt_aes ()
{
  passkey="${1}"
  data="${2}"
  echo -n "${data}" | openssl base64 -d | openssl enc -d -aes-256-cbc -pbkdf2  -pass "pass:${passkey}";
  exit_code=$?
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
  varname=$(trim "${varname}");
  value="${2}"
  value=$(base64_encode "${value}");
  openssl_fullpath="$( get_command_fullpath openssl )";
  echo -n 'declare -g -x ';
  echo -n "${varname}";
  echo -n '=$(echo -n';
  echo -n " '${value}' | ${openssl_fullpath} base64 -d ); ";
  #result will be like this "var=$(echo 'dmFyaWFibGUgaXMgaGVyZQ=='  | openssl base64 -d);"
  echo "";
}
export -f save_var_in_base64


function save_var_in_base32 ()
{
  varname="${1}"
  varname=$(trim "${varname}");
  value="${2}"
  value=$(echo -n "${value}" | base32 --wrap=0);
  echo -n 'declare -g -x ';
  echo -n "${varname}";
  echo -n '=$(echo -n';
  echo -n " '${value}' | base32  -d -i ); ";
  #result will be like this "var=$(echo -n 'F5UG63LFF5US6LSYMF2XI2DPOJUXI6I='  | base32 -id);"
  echo "";
}
export -f save_var_in_base32

function save_var_in_text ()
{
  varname="${1}"
  varname=$(trim "${varname}");
  value="${2}"
  echo -n 'declare -g -x ';
  echo -n "${varname}";
  echo -n '=';
  echo -n "\"${value}\"; ";
  #result will be like this 'declare -g -x var="value";'
  echo "";
}
export -f save_var_in_text

function random_str ()
{
    len="${1}";
    vowels="euioa";
    consonants="rtpsdfgklzxcvbnm";
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
  declare -g -x "$varname=$value";
  export "$varname=$value";
  #echo "$varname=$value";
  echo "declare [$varname]";
}
export -f declare_and_export

function get_command_fullpath ()
{
  command="${1}";
  command=$(trim "$command");
  fullpath_maybe=$(type -p "$command");
  fullpath_maybe=$(trim "$fullpath_maybe");
  if [[ "${fullpath_maybe}" = "" ]] ; then
    fullpath_maybe="$command";
  fi;
  echo -n "${fullpath_maybe}";
}
export -f get_command_fullpath


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
  #show variables and it values, not only one
  for varname in "$@"
  do
      echo -n "$varname=";
      echo -n '"'$( get_var "${varname}" )'" ';
  done
  echo "";
  #   varname="${1}";
  #   echo -n "$varname=";
  #   echo '"'$( get_var "${varname}" )'"';
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
  #One can remove triple quotes from mode_name with echo and eval
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

function wait_for_exit_code ()
{
    #function wait $2 seconds or return if all other arguments return exit code $1;
    #examples:
    #wait_for_exit_code 42 31337 ' exit 1 ' - wait for exit code=42 for 31337 seconds.
    #wait_for_exit_code 5 31337 ' exit 5 ' - wait for exit code=5 for 31337 seconds. (but it exits immediately, because exit code equal)
    timeout=$2
    exit_code_to_check=$1
    shift 2
    #all other aruments become to executed command
    command="$@";

    while [ $timeout -ge 0 ]
    do
      ( $command ) 1> /dev/null 2> /dev/null
      exit_code="$?";
      #if [[ "${exit_code}" = "${exit_code_to_check}" ]] ;
      if [ $exit_code -eq $exit_code_to_check ] ;
      then
        return 0; #none zero exit code means error in the bash, and here I don't want to break the rules ) So, zero means YES in bash
      fi;
      #       ret_val=$(eval "${command}" );
      #       ret_val=$(trim "$ret_val");
      #       #returned_value=$?
      #       #show_var ret_val;
      #       if [[ "${ret_val}" != "" ]] && [[ "${ret_val}" != 0 ]]  ; then return 1; fi;
      sleep 1;
      timeout=$(( timeout - 1 ))
    done
    return 1; #exit code = One means error in bash
}
export -f wait_for_exit_code

function is_process_return_this_code
{
  # if given command returns exit code equals to $1 - this function will return 1 as exit code, otherwise - return exit code 0
  #use: if is_process_return_this_code 0 'xprop -root' ; then echo 111; else echo 000; fi;
  #if is_process_return_this_code 15 'exit 15' ; then echo "equal"; else echo "NOT equal"; fi;
  exit_code_to_check="${1}";
  shift 1
  command="$@";
  #returned_text="$( ( $command ) >/dev/null )"
  #returned_text="$( $command )"
  ( $command ) 1> /dev/null 2> /dev/null
  exit_code="$?";
  #if [[ "${exit_code}" = "${exit_code_to_check}" ]] ;
  if [ $exit_code -eq $exit_code_to_check ] ;
  then
    return 0; #none zero exit code means error in the bash, and here I don't want to break the rules ) So, zero means YES in bash
  else
    return 1; #One means NO in bash
  fi;
}
export -f is_process_return_this_code

function is_process_running
{
  #use: if [ "$(is_process_running Xorg)" -ge 1 ]; then echo 111; else echo 000; fi;
  app="${1}";
  if [ "$(ps -e | grep --ignore-case --count "${app}")" -ge 1 ];
  then
    return 0; #none zero exit code means error in the bash, and here I don't want to break the rules )
  else
    return 1;
  fi;
}
export -f is_process_running

function ymdhms ()
{
  echo -n "$(date "+%F-%H-%M-%S-%N")";
}
export -f ymdhms

function is_root ()
{
  #return 0 if current user is root. return 1 if not root
  if [ $EUID -eq 0 ] || [[ "$(get_command_fullpath whoami)" = 'root' ]]; then
    return 0; #root!
  fi
  return 1; #not root
}
export -f is_root

function install_system ()
{
  app="${1}";
  shift 1
  arguments="$@";
  if [[ "${app}" = 'update' ]] ; then
    timeout --kill-after=77 77777  apt-get --yes update;
    slog "<6>apt-get update"
    declare -g -x install_system_updated=1;
    return 0;
  fi
  if [[ "${install_system_updated}" = "" ]] || [[ "${install_system_updated}" = 0 ]]  ; then
    timeout --kill-after=77 77777  apt-get --yes update;
    slog "<6>apt-get update"
    declare -g -x install_system_updated=1;
  fi;
  timeout --kill-after=77 77777 apt-get ${dry_run} --allow-unauthenticated --yes install "${app}" $@;
  slog "<7>apt-get install ${app}"
}
export -f install_system

function countdown ()
{
  local count="$1";
  count=${count#-} #must not negative
  local interval="$2";
  interval=${interval#-} #must not negative
  if [[ "${interval}" = "" ]] || [[ "${interval}" = 0 ]]  ; then
    interval=0.1;
  fi;
  if [[ "${count}" = "" ]] || [[ "${count}" = 0 ]]  ; then
    count=42;
  fi;

  local backspaces="\b\b\b\b\b\b\b\b";
  local i=1;
  for ((i=$count;i>=0;i--)); do
    echo -ne "${backspaces}${i}  ";
    sleep "${interval}";
  done;
  echo -ne "${backspaces}";
}
export -f countdown

function random_wait ()
{
  return 0;
  local x
  for ((x=42;x>=0;x--)); do
      #echo -ne "\b\b\b\b\b\b\b\b $x  ";
      slog "<7>$(show_var x) $whoami $EUID"
      sleep "$(( RANDOM % 4 + 1)).$(( RANDOM % 99 + 11))";
  done;
}
export -f random_wait

function slog ()
{
  #add message to systemd log
  #examples:
  #slog "<7>debug message from dzible"
  #slog "<4>warning message from dzible"
  #view logs with:
  # journalctl --all --reverse --priority=7 -t dzible -t dzible.root_autorun -t dzible.root_autorun_plus -t dzible.root_autorun_gui -t dzible.user_autorun -t dzible.user_autorun_gui
  # journalctl --all --follow --priority=7 -t dzible -t dzible.root_autorun -t dzible.root_autorun_plus -t dzible.root_autorun_gui -t dzible.user_autorun -t dzible.user_autorun_gui
  #tail -f /var/log/syslog | grep dzible;
  # <0>emerg: the system is unusable.
  # <1>alert: action must be taken immediately.
  # <2>crit: critical conditions.
  # <3>err: error conditions.
  # <4>warning: warning conditions.
  # <5>notice: normal, but significant condition.
  # <6>info: informational message.
  # <7>debug: messages that are useful for debugging.
  message="$1";
  if [[ "${service_name}" = "" ]]  ; then
    declare -x -g service_name='dzible';
  fi;
  echo -n "${message}" | systemd-cat --identifier="${service_name}";
  return_code=$?
  declare -g slog_mes="${message}";
  echo "${message}";
  return $return_code;
}
export -f slog

function telemetry_send ()
{
  #function save data in {$telemetry_queue_dir}
  #required dzible.telemetry systemd service
  local file="$1"; #file
  local message="$2"; #message
  random_dir_name="${telemetry_queue_dir}$( ymdhms )-$( random_str 5; )-$RANDOM";
  mkdir -pv "${random_dir_name}";
  text_filename="${random_dir_name}/text.txt";
  file_filename="${random_dir_name}/file.txt";
  send_filename="${random_dir_name}/send.txt";
  filename_realpath_to_send="$(realpath --quiet "$file")"; #get full path to file
  #write filename to file
  if [[ "$file" != "" ]]; then
    echo -n "${filename_realpath_to_send}" >"${file_filename}";
  fi;
  #write message to file
  echo -n "${message}" >"${text_filename}";
  #write ready-to-send flag to file
  echo -n "if this file exists - message must be send by dzible.telemetry service" >"${send_filename}";
  slog "<7>telemetry_send ${filename_realpath_to_send} $message"
}
export -f telemetry_send

function max ()
{
  echo -n $(( $2  > $1 ? $2 : $1 ))
}
export -f max

function min ()
{
  echo -n $(( $2 < $1 ? $2 : $1 ))
}
export -f min

declare_and_export dzible_function_loaded "1"  #flag. Means what dzible functions loaded
declare_and_export install_dir "/home/i/bin/dzible/"  #dzible will install himself to this directory
declare_and_export cur_date_time "$(ymdhms)"
declare_and_export crypted_vault_file 'vault/1.crypt' #path for vault
declare_and_export master_password_file 'master_password.txt' #path to file with password to decrypt vault file
declare_and_export task_max_timeout 777  #maximum life time for every task
declare_and_export service_name 'dzible';   #for slog systemd logs
declare_and_export dzible_github_url 'https://github.com/Borodin-Atamanov/dzible.git';

declare_and_export root_autorun_service_file '/etc/systemd/system/dzible.service'; #dzible autorun service, what run on system boot
declare_and_export load_variables_file "${install_dir}autorun/load_variables.sh"; #variables in this file load in every dzible-script after system install
declare_and_export root_autorun_file "${install_dir}autorun/root_autorun.sh"; #will run in every boot with root rights
declare_and_export telemetry_queue_dir '/var/spool/dzible_telemetry_queue/'  #directory, what used to save and send telemetry data
declare_and_export telemetry_service_file '/etc/systemd/system/dzible_telemetry.service'  #dzible telemetry service, what run on system boot
declare_and_export telemetry_script_file "${install_dir}autorun/dzible_telemetry.sh"; #will run in every boot with root rights
declare_and_export root_vault_file "${install_dir}autorun/root_vault"; #file with encrypted root secret variables
declare_and_export root_vault_password_file "${install_dir}autorun/root_vault_password";  #file with password to decrypt encrypted root secret variables

#TODO ask target computer name on script start

set +x

if [[ "$1" != "fun" ]]; then
set -x

declare_and_export computer_name 'pipyau'
declare_and_export secrets 'secrets' #preffix for vault variables names

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

install_system git
install_system openssl

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode, so don't clone github";
else
  work_dir="${TMPDIR:-/tmp}/dzible_work_dir-$(date "+%F-%H-%M-%S")";
  slog "<7>$(show_var work_dir)";
  mkdir -pv "${work_dir}";
  echo "clone scripts from github";
  slog "<7>$(show_var work_dir)";
  slog "<7>$(show_var dzible_github_url)";
  git clone --verbose --progress --depth 1 "${dzible_github_url}" "${work_dir}";
  # try to copy ${master_password_file} from current directory to work_dir
  cp --verbose --update "${master_password_file}" "${work_dir}/"
  cd "${work_dir}";
fi
work_dir="$(realpath "$(pwd)")/";
declare_and_export work_dir "${work_dir}"
slog "<7>$(show_var work_dir)";

# temp_script_subversion=$( cat "${work_dir}index.sh" | grep '^script_subversion' );
# echo "$temp_script_subversion";
# temp_script_subversion=$( eval "${temp_script_subversion}" );
# echo "●●● $temp_script_subversion ●●●";
# sleep 2.42;

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
#echo "secrets_pipyau_root_password=${secrets_pipyau_root_password}"
echo "secrets_loaded=${secrets_loaded}"
#echo "Original data:"
#md5 "${data}";

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode";
else
  echo 1;
  #run_task add_screen_resolution_with_cvt_xrandr
fi

run_task show_script_subversion
#run_task sleep 4
#run_task timezone_set
run_task install_autorun_script
#run_task install_console_apps
#run_task install_gui_apps
#run_task add_screen_resolution_with_cvt_xrandr
# run_task root_password_set
# run_task user_i_password_set
# run_task root_password_for_sudoers
# run_task sshd_config
# run_task ssh_config
run_task install_telemetry
run_task install_tor
run_task show_script_subversion
run_task sleep 11

#IDEA: generate new passwords, and show it to user after script end his work

else
    echo 'functions loaded';
fi; #end of fun if

#find . -type f -name '*.*' -print0 | xargs -0 sed --debug -i 's/_root_password/_root_passwordword/g'
#find . -type f -name '*.*' -print0 | xargs -0 sed  -i 's/_root_password/_root_passwordword/g'

#to delete script_subversion from script use
#cat index.sh | grep -v '^script_subversion' | tee index-new.sh
export script_subversion='takas-424d24d-2022-09-02-15-04-16'; echo "${script_subversion}=script_subversion"; 