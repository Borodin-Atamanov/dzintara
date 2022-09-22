#!/usr/bin/bash
# Dzintara
# Open source app for setup debian-like systems
# https://github.com/Borodin-Atamanov/dzintara
# Author dev@Borodin-Atamanov.ru
#License: MIT

#Script contains 3 parts
#1. function definition
#2. initialisation: set variables, etc
#3. run tasks

# wget -qO - https://raw.githubusercontent.com/Borodin-Atamanov/dzintara/main/index.sh | sudo bash
# wget -qO - clck.ru/z34AD | sudo bash |  tee log

# arguments
# wget -qO - clck.ru/z34AD | sudo bash -s - tasks="countdown:150:0.1 show_script_subversion:arg1:arg2 install_nginx " | tee log
# ./index.sh tasks="install_autorun_script install_telemetry countdown:150:0.1 show_script_subversion:arg1:arg2 "
# ./index.sh tasks="install_autorun_script install_telemetry countdown:150:0.1 show_script_subversion:arg1:arg2 install_nginx_root"

declare -g -x script_version='kilesd-857-2209221829'; 

function run_task ()
{
  declare -g -x task_name="${1}";
  shift 1
  #function will send other arguments to executed task as parameters
  #add arguments to task
  arguments="$@";

  if [[ "${test_mode}" = "1" ]]; then
    task_script="tasks/${task_name}.sh";
  else
    task_script="${work_dir}/tasks/${task_name}.sh";
  fi

  echo "████ task ${task_name} ${arguments}████ ${script_version}";
  slog "<6>run_task ${task_name} ${arguments}";
  slog "<7>$(show_var task_script) $(show_var task_name) $(show_var arguments)";
  #if user press CTRL+C - we will exit from task with exit code 87
  #trap dzintara_task_terminator SIGINT
  if [ -s "${task_script}" ];  then
    (
      #create countdown process, it show count down before task end by timeout
      countdown_command="timeout --kill-after=2 "${timeout_task}" ${work_dir}/tasks/countdown.sh ${timeout_task} 0.97 & "
      eval $countdown_command;
      countdown_pid=$!
      slog "<7>countdown_pid=${countdown_pid}";
      #task_pid="$$"; slog "<7>task_pid ${task_pid}"; echo -n "$task_pid" > "${task_pid_file}" #save current task PID to file
      #exec -a "${work_dir}${task_script}"
      #run 1.sh before every task. Send full task path as $1 to 1.sh
      source "${work_dir}tasks/1.sh" "${task_script}";
      #run task script
      #add timeout to subshell
      timeout --kill-after=77 "${timeout_task}" "${task_script}" ${arguments};
      kill -- -$countdown_pid;
    );
    #kill counter process
    #kill -9 $countdown_pid;
    #killall --verbose "countdown.sh";
    echo -e "----------------------------------------------------------------------- task ${task_name} ${arguments} ended  ${script_version} \n\n\n";
  else
    slog "<4>no task_script file ${task_script}! 🤷‍":
  fi
  sleep $timeout_0;
}

function encrypt_aes ()
{
  #function encrypt data with password using AES.
  # $1 is variable name with data (not the data itself!) result will be save to variable with name from $1
  local var_name="${1}"
  local data="${!var_name}"
  # $2 is the password string
  passkey="${2}"
  trim_var passkey
  #openssl enc -in PrimaryDataFile -out EncryptedDataFile -e -aes256 -pass "${passkey}" -pbkdf2
  data="$( echo -n "${data}" | openssl enc -e -aes-256-cbc -pbkdf2  -pass "pass:${passkey}" | base32 --wrap=0 )"
  #declare -g aes_error=$?
  declare -g ${var_name}="$data";
}
export -f encrypt_aes

function decrypt_aes ()
{
  #function decrypt data with password using AES.
  # $1 is variable name with data (not the data itself!) result will be save to variable with name from $1
  local var_name="${1}"
  local data="${!var_name}"
  # $2 is the password string
  passkey="${2}"
  trim_var passkey
  passkey_hex="${passkey}"
  >&2 bin_2_hex passkey_hex
  show_var passkey_hex passkey
  data="$( echo -n "${data}" | base32 -i -d | openssl enc -d -aes-256-cbc -pbkdf2  -pass "pass:${passkey}"; )"
  aes_error=$?; declare -g -x aes_error;
  # aes_error always empty ?
  declare -g ${var_name}="$data";
  return $aes_error
}
export -f decrypt_aes

function md5 ()
{
    if test -n "$1"; then
        #echo "Read from positional argument $1";
        echo   -n "${1}" | md5sum | awk '{print $1}'
    elif test ! -t 0; then
        # >&2 echo "md5() Reads from stdin"
        cat /dev/stdin | md5sum | awk '{print $1}'
    else
        >&2 echo "No input for md5()"
    fi
}
export -f md5

function base64_encode ()
{
  local data="${1}"
  local base64="$( get_command_fullpath base64 )";
  echo -n "${data}" | $base64 -e -A | tr -d \\n;
}
export -f base64_encode

function base64_decode ()
{
  local data="${1}"
  base64="$( get_command_fullpath base64 )";
  echo -n "${data}" | $base64 -d -i
  decrypt_error=$?;
}
export -f base64_decode

function save_var_in_base64 ()
{
  local varname="${1}"
  varname=$(trim "${varname}");
  value="${2}"
  value=$(base64_encode "${value}");
  base64="$( get_command_fullpath base64 )";
  echo -n 'declare -g -x ';
  echo -n "${varname}";
  echo -n '=$(echo -n';
  echo -n " '${value}' | $base64 -d -i ); ";
  #result will be like this "var=$(echo 'dmFyaWFibGUgaXMgaGVyZQ=='  | openssl base64 -d);"
  echo "";
}
export -f save_var_in_base64

function save_var_in_base32 ()
{
  local varname="${1}"
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
  local varname="${1}"
  varname=$(trim "${varname}");
  local value="${2}"
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
    local len="${1}";
    local vowels="euioa";
    local consonants="rtpsdfgklzxcvbnm";
    local random_str=;
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

function trim_var()
{
    local var_name="${1}"
    local val="${!var_name}"
    # remove leading whitespace characters
    val="${val#"${val%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    val="${val%"${val##*[![:space:]]}"}"

    # new line
    # remove leading
    #value="${value#"${value%%$'\n'*}"}"
    # remove trailing
    #value="${value%"${value##*$'\n'}"}"
    #value=${value%$'\n'} # remove
    declare -g -x "$var_name=$val";
}
export -f trim_var

function declare_and_export ()
{
  local varname="${1}"
  local value="${2}"
  declare -g -x "$varname=$value";
  export "$varname=$value";
  #echo "$varname=$value";
  #echo "declare [$varname]";
}
export -f declare_and_export

function get_command_fullpath ()
{
  local command="${1}";
  command=$(trim "$command");
  local fullpath_maybe=$(type -p "$command");
  fullpath_maybe=$(trim "$fullpath_maybe");
  if [[ "${fullpath_maybe}" = "" ]] ; then
    fullpath_maybe="$command";
  fi;
  echo -n "${fullpath_maybe}";
}
export -f get_command_fullpath

function generate_and_save_root_vault ()
{
  #function generate new root vault with passwords, save it.
  #uses vars:
  #"${root_vault_file}"
  #"${root_vault_password_file}"

  #if files non empty - dont overwrite it, return
  #[ -s "${root_vault_file}" ] && return 1;
  #[ -s "${root_vault_password_file}" ] && return 1;

  declare -g local ymdhms=$(ymdhms)
  declare -g local hostname="$(random_str 5; random_str 3; )";
  declare -g local root_password="$(random_str 5; random_str 3; random_str 5; random_str 3; random_str 5; random_str 3;)";
  declare -g local user_i_password="$(random_str 5; random_str 3; random_str 5; random_str 3; random_str 5;)";
  declare -g local www_user="$(random_str 5; random_str 3; random_str 5;)";
  declare -g local www_password="$(random_str 5; random_str 5; random_str 5; )";
  declare -g local vnc_password="$(random_str 4; random_str 4; )";

  save_root_vault

  #return 0

  # TODO check what passwords in file, and we can decrypt it
  load_var_from_file "${root_vault_file}" root_vault_encypted2
  load_var_from_file "${root_vault_password_file}" master_password2
  #decrypted_data=$( decrypt_aes "${master_password2}" "${root_vault_encypted2}"; )
  decrypted_data="${root_vault_encypted2}"
  decrypt_aes decrypted_data "${master_password2}"
  #show_var decrypted_data

  #TODO generate text message to human with passwords in last task
  #declare -g -x root_vault_plain_human="${root_vault_plain}"
  sleep $timeout_0
  eval "${decrypted_data}";
}
export -f generate_and_save_root_vault

function load_root_vault ()
{
  if [ -s "${root_vault_file}" ] && [ -s "${root_vault_password_file}" ]
  then
    echo "root_vault_file=${root_vault_file} and root_vault_password_file=${root_vault_password_file} files are not empty, load passwords from it"

    # TODO check what passwords in file, and we can decrypt it
    load_var_from_file "${root_vault_file}" root_vault_encypted2
    #show_var root_vault_encypted2
    load_var_from_file "${root_vault_password_file}" master_password2
    #show_var master_password2
    if [[ "${root_vault_encypted2}" == "" ]] || [[ "${master_password2}" == "" ]]; then
      >&2 echo "root_vault_file=${root_vault_file} or root_vault_password_file=${root_vault_password_file} gives empty result. Maybe permissions is not enough? Are you root?"
      return -1;
    fi
    #decrypted_data=$( decrypt_aes "${master_password2}" "${root_vault_encypted2}"; )
    decrypted_data="${root_vault_encypted2}"
    #trim_var master_password2
    decrypt_aes decrypted_data "${master_password2}"
    #show_var decrypted_data

    #TODO generate text message to human with passwords in last task
    #declare -g -x root_vault_plain_human="${root_vault_plain}"
    eval "${decrypted_data}";
    sleep $timeout_0
    return 0
  else
    >&2 echo "root_vault_file=${root_vault_file} and root_vault_password_file=${root_vault_password_file} files are empty, can't load passwords from it!"
    return -1
  fi;
}
export -f load_root_vault

function save_root_vault  ()
{

local declare_g_x_nl_sl='declare -g -x \';  #

declare -g -x root_vault_plain=$(cat <<_ENDOFFILE
# hostname
${declare_g_x_nl_sl}
${root_vault_preffix}hostname='${hostname}';

# root password
${declare_g_x_nl_sl}
${root_vault_preffix}root_password='${root_password}';

# user i password
${declare_g_x_nl_sl}
${root_vault_preffix}user_i_password='${user_i_password}';

# http-access
${declare_g_x_nl_sl}
${root_vault_preffix}www_user='${www_user}';
${declare_g_x_nl_sl}
${root_vault_preffix}www_password='${www_password}';

# VNC password
${declare_g_x_nl_sl}
${root_vault_preffix}vnc_password='${vnc_password}';

#dzintara
# file generated ${ymdhms}                                                                      .
_ENDOFFILE
)
  #now $root_vault_plain contains passwords in plain text format
  #echo "$root_vault_plain"

  #[ -s "${root_vault_file}" ] && return 1;
  #[ -s "${root_vault_password_file}" ] && return 1;
  #echo $crypted_file
  # load data from file to variable
  #file_data=$(cat "${f}");
  root_vault_password="${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}$(  random_str 50; random_str 50; )";
  #root_vault_password="$(trim "${root_vault_password}")"
  #local root_vault_crypt=$( encrypt_aes "${root_vault_password}" "$root_vault_plain"; )
  root_vault_crypt="$root_vault_plain"
  encrypt_aes root_vault_crypt "${root_vault_password}"
  #load_var_from_file "${root_vault_file}" file_data
  #load_var_from_file "${root_vault_password_file}" file with password
  #echo "password_from_file length is ${#master_password}";
  #echo  $file_data;
  #encrypt data with master_password
  #echo -n "${encrypted_data}" > "${crypted_file}";
  save_var_to_file "${root_vault_password_file}" root_vault_password
  save_var_to_file "${root_vault_file}" root_vault_crypt
  chown --verbose --changes root:root "${root_vault_password_file}";
  chown --verbose --changes root:root "${root_vault_file}";
  chmod --verbose 0600 "${root_vault_password_file}";
  chmod --verbose 0600 "${root_vault_file}";
}
export -f save_root_vault

function get_var ()
{
  local varname="${1}";
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
  local width="${1}";  width=$((width / 8 * 8));
  local height="${2}";
  local fps="${3}";

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
    local timeout=$2
    local exit_code_to_check=$1
    shift 2
    #all other aruments become to executed command
    local command="$@";

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
  local exit_code_to_check="${1}";
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
  local app="${1}";
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
  echo -n "$(date "+%F-%H-%M-%S")";
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
  local app="${1}";
  shift 1
  local arguments="$@";
  if [[ "${app}" = 'update' ]] ; then
    timeout --kill-after=77 $timeout_task apt-get --yes update | cat;
    slog "<6>apt-get update"
    declare -g -x install_system_updated=1;
    return 0;
  fi
  if [[ "${install_system_updated}" = "" ]] || [[ "${install_system_updated}" = 0 ]]  ; then
    #TODO create interprocess variable to check what update was minute ago
    #find monitor_running_flag -mmin +60
    #test "$( find root_vault_test.sh -mmin +7 )"; echo $?
    tfile="${ipc_dir}/install_system_update"; # file to save time of last update
    find "${tfile}" -mmin +71 >/dev/null;
    is_file_old=$?
    show_var is_file_old
    sleep $timeout_0
    timeout --kill-after=77 $timeout_task dpkg --configure -a | cat;
    timeout --kill-after=77 $timeout_task apt-get --yes update | cat;
    timeout --kill-after=77 $timeout_task apt-get --yes autoremove | cat;
    touch "$tfile";
    slog "<6>apt-get update"
    declare -g -x install_system_updated=1;
  fi;
  timeout --kill-after=77 $timeout_task apt-get ${dry_run} --allow-unauthenticated --yes install "${app}" $@ | cat;
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
  #slog "<7>debug message from dzintara"
  #slog "<4>warning message from dzintara"
  #view logs with:
  # journalctl --all --reverse --priority=7 -t dzintara -t dzintara.root_autorun -t dzintara.root_autorun_plus -t dzintara.root_autorun_gui -t dzintara.user_autorun -t dzintara.user_autorun_gui
  # journalctl --all --follow --priority=7 -t dzintara -t dzintara.root_autorun -t dzintara.root_autorun_plus -t dzintara.root_autorun_gui -t dzintara.user_autorun -t dzintara.user_autorun_gui
  # tail -f /var/log/syslog | grep dzintara;
  # cat /var/log/syslog | grep dzintara;
  # <0>emerg: the system is unusable.
  # <1>alert: action must be taken immediately.
  # <2>crit: critical conditions.
  # <3>err: error conditions.
  # <4>warning: warning conditions.
  # <5>notice: normal, but significant condition.
  # <6>info: informational message.
  # <7>debug: messages that are useful for debugging.
  local message="$1";
  if [[ "${service_name}" = "" ]]  ; then
    declare -x -g service_name='dzintara';
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
  #required dzintara.telemetry systemd service
  local file="$1"; #file
  local message="$2"; #message
  local random_dir_name="${telemetry_queue_dir}$( ymdhms )-$RANDOM";
  mkdir -pv "${random_dir_name}";
  local text_filename="${random_dir_name}/text.txt";
  local file_filename="${random_dir_name}/file.txt";
  local send_filename="${random_dir_name}/send.txt";
  local filename_realpath_to_send="$(realpath --quiet "$file")"; #get full path to file
  #write filename to file
  if [[ "$file" != "" ]]; then
    echo -n "${filename_realpath_to_send}" >"${file_filename}";
  fi;
  #write message to file
  echo -n "${message}" >"${text_filename}";
  #write ready-to-send flag to file
  echo -n "if this file exists - message must be send by dzintara.telemetry service" >"${send_filename}";
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

function is_substr ()
{
  #$1 - string
  #$2 - substring
  local haystack="$1"
  local needle="$2"
  #[ -z "$1" ] || { [ -z "${2##*$1*}" ] && [ -n "$2" ]; };
  #[ -z "$1" ] || { [ -z "${2##*$1*}" ] && [ -n "$2" ];};
  #[ -z "$haystack" ] || { [ -z "${needle##*$haystack*}" ] && [ -n "$needle" ];};
  exit_code=1;
  if [[ "$haystack" == *"${needle}"* ]]; then
    exit_code=0;
  fi
  if [[ "$haystack" == '' ]] || [[ "${needle}" == '' ]] ; then
    exit_code=1;  #empty string is not contains empty stings or something else
  fi
  #echo "${needle##*$haystack*}";
  #show_var exit_code
  #>&2 echo -n "is_substr() ";
  #>&2 show_var haystack needle exit_code
  return $exit_code
  #return [[ -z "$1" ]] || { [[ -z "${2##*$1*}" ]] && [[ -n "$2" ]];};
}
export -f is_substr

function load_var_from_file ()
{
  #load_var_from_file
  local fname="$1"  #path to file or something like file
  local var_name="$2" #load data from file to this variable
  if [[ -e "${fname}" ]] ; then
    #file or named pipe exists
    #file_value=$( cat "${fname}" );
    #command_eval='declare -g "'${var_name}'=$file_value"';

    #command_eval='declare -g -x "'${var_name}'"; '${var_name}'="$temp_var"; # echo "$'${var_name}'"; ';
    #>&2 echo $command_eval;
    #>&2 show_var command_eval
    #eval "$command_eval";

    local temp_var="$(<"${fname}")"
    local x0a=$'\x0A'; #HEX code char
    temp_var="${temp_var}${x0a}";  # add new line at the end because bash remove it
    declare -g "${var_name}"="$temp_var";
    #command_eval='declare -g "'${var_name}'=$(cat "'${fname}'" )"';
    #this command removes newlines in the end of file
    #echo "$command_eval"
    #show_var command_eval
    #eval "$command_eval";
    #variable with name "${var_name}" now contains value from file, but without newlines in the end
    #md5_of_var=$(md5 "${!var_name}")
    #show_var md5_of_var
    #echo -n "";
  else
    >&2 echo "File is not exists $fname";
    :
  fi
}
export -f load_var_from_file

function read_var ()
{
  #read user input to variable
  local var_name="$1"
  [ -z "$var_name" ] && return -1
  local message="$2"
  read -p "${message}" temp_var < /dev/tty;
  #command_eval='declare -g -x "'${var_name}'"; '${var_name}'="$temp_var"; # echo "$'${var_name}'"; ';
  #>&2 echo $command_eval;
  #>&2 show_var command_eval
  #eval "$command_eval";
  declare -g "${var_name}"="$temp_var";
  #use:
  #random_var=$(random_str 5); read_var "$random_var"  "write random variable: "; echo "${!random_var}"
}
export -f read_var

function save_var_to_file ()
{
  local fname="$1"  #path to file or something like file
  local var_name="$2"
  #local x0a=$'\x0A'; #HEX code of new line char
  #echo -n "${!var_name}${x0a}" > "${fname}" # add new line at the end because bash remove it
  echo "${!var_name}" > "${fname}" # add new line at the end because bash remove it
}
export -f save_var_to_file

function replace_line_by_string ()
{
  #function search for strings contains substring $2 in variable, . And replace the string with $3
  #get first parameter as variable name, not a value!
  #if original string contains $4 - then this string will not change
  #function use global variables to define function's behavior
  #if $1 is 'reset' - then global variables will reset to default values
  #echo -n $(( $2 < $1 ? $2 : $1 ))
  #local haystack="$1";  #multiline variable, where the function will search
  local haystack_name="$1";
  local haystack="${!haystack_name}";
  local haystack2=''

  local needle="$2"; #search for this substring
  local slide="$3"; #and replace sting to slide (if needle found in the string)
  local stop_word="$4"; #if stop word found in string - then this stings is untouchable

  if [[ "$haystack" = 'reset_reset_reset' ]]; then
    # reset global defined vars for this function
    :
    return -1;
  fi;

  [[ "$replace_line_by_string_add_slide_if_no_needle" == "" ]] && declare -g "replace_line_by_string_add_slide_if_no_needle=1"

  #find all strings with needle
  #haystack2="$(  echo -n "${haystack2}" | grep --fixed-strings --ignore-case "${needle}" )"

  #remove all strings with stop_word
  if [[ "${stop_word}" != "" ]]; then
    #haystack2="$( echo -n "${haystack2}" | grep --fixed-strings --ignore-case --invert-match "${stop_word}" )"
    :
  fi;
  local any_line_changed=0;  # by default we don't change any line in variable
  local slide_already_here=0;  # if slide is already in one or more strings - don't add slide in the end
  while IFS= read -r line; do
    #haystack3=$( echo -n "$haystack3" | sed --expression="s${xff}${line}${xff}${slide}${xff}g" );
    #haystack4="${haystack3/${line}/${slide}}"
    #>&2 echo line="$line" needle="$needle" stop_word="$stop_word"
    #>&2 echo -n "replace_line_by_string() ";
    #>&2 show_var line needle slide stop_word
    #show_var line needle stop_word
    if is_substr "$line" "$needle" && ! is_substr "$line" "$stop_word" ; then
      #change this line to slide
      line="$slide";
      any_line_changed=1;
      #>&2  echo 'CHANGE!'
    else
      #echo -n "NO: ";
      #Don't change this line to slide
      :
    fi
    # check if line contains $slide and not contains stop_word
    if is_substr "$line" "$slide" && ! is_substr "$line" "$stop_word" ; then
      #change this line to slide
      line="$slide";
      any_line_changed=1;
      #>&2  echo 'CHANGE!'
    else
      #echo -n "NO: ";
      #Don't change this line to slide
      :
    fi


    #haystack3="${haystack3//$line/$slide}" #doesnt work for me in some cases!
    #echo "s${xff}${line}${xff}new${xff}g"
    #echo "$line"
    haystack2="${haystack2}${line}${x0a}"
  done <<< "$haystack"
  #if we did't find needle and we should add $slide to file - let's do it
  if [[ "$replace_line_by_string_add_slide_if_no_needle" = "1" ]] && [[ "$any_line_changed" = "0" ]]; then
    #echo "$slide";
    haystack2="${haystack2}${slide}${x0a}"
    any_line_changed=1
    #TODO dont add $slide if it in file and not include stop_word
  fi;
  #show_var replace_line_by_string_add_slide_if_no_needle any_line_changed
  declare -g "${haystack_name}"="$haystack2";

  return $any_line_changed;
}
export -f replace_line_by_string

function add_line_to_file ()
{
  #function adds line to file if it not exists in file
  # $1 - file fullpath
  # $2 - line to add
  local fname="$1"
  local line2add="$2"
  local comments_sign="$3"
  [[ "$comments_sign" == "" ]] && comments_sign='#';
  if [[ -e "${fname}" ]] ; then
    #file or named pipe exists
    load_var_from_file "$fname" config_al2f
    #config_al2f=$( replace_line_by_string "$config_al2f" "$line2add" "$line2add" "$comments_sign" )
    replace_line_by_string config_al2f "$line2add" "$line2add" "$comments_sign"
    changed=$?
    show_var changed fname
    #echo "$config_al2f"
    save_var_to_file "$fname" config_al2f
    return 0;
  fi;
  return 1;
}
export -f add_line_to_file

function search_and_replace ()
{
  #function search and replace in variable
  # $1 - haystack - string with variable name. This variable will changed. Maybe
  local haystack_name="$1";
  local haystack="${!haystack_name}";
  # $2 - needle string. Function will search for needle in haystack
  #local needle_name="$2";
  #local needle="${!needle_name}";
  local needle="$2";
  # $3 - slide. string Function will replace every needle to slide
  local slide="$3";
  #local slide_name="$3";
  #local slide="${!slide_name}";
  local haystack2="${haystack//$needle/$slide}" #
  #command_eval='declare -g -x "'${haystack_name}'"; '${haystack_name}'="$haystack2"; ';
  #eval "$command_eval";
  declare -g "${haystack_name}"="$haystack2";
}
export -f search_and_replace

function search_and_replace_hex ()
{
  #function search and replace in variable
  # $1 - haystack - string with variable name. $1 contains variable name, not data! This variable will changed in case of successful search-and-replace
  # examples:
  # search_and_replace_hex variable_name "0a 0a" "34"

  haystack_name="$1";
  haystack="${!haystack_name}";
  # $2 - needle - string with hex like this "20 32 FD 16 11"
  needle="${2}";
  # $3 - slide. string with hex like this "20 32 FD 16 11"
  slide="${3}";
  #r1v trim "$needle"
  #validate hex strings
  hex_2_valid needle
  hex_2_valid slide
  # convert to hex input data
  haystack_hex="${haystack}";
  bin_2_hex haystack_hex
  #show_var needle slide
  #show_var 'before HEX:' haystack_hex
  # replace hex needle to hex slide in hex haystack
  haystack_hex="${haystack_hex//$needle/$slide}" #
  #haystack_hex="${haystack_hex//0a/$slide}" #
  #show_var 'after HEX: ' haystack_hex
  hex_2_bin haystack_hex
  #command_eval='declare -g -x "'${haystack_name}'"; '${haystack_name}'="$haystack2"; ';
  declare -g "${haystack_name}"="$haystack_hex";
}
export -f search_and_replace_hex

function r1v ()
{
  #set all command stdout to variable with name from $1
  #command is in other arguments
  #                         +-------+-------+-----------+
  #                 VAR is: | unset | empty | non-empty |
  # +-----------------------+-------+-------+-----------+
  # | [ -z "${VAR}" ]       | true  | true  | false     |
  # | [ -z "${VAR+set}" ]   | true  | false | false     |
  # | [ -z "${VAR-unset}" ] | false | true  | false     |
  # | [ -n "${VAR}" ]       | false | false | true      |
  # | [ -n "${VAR+set}" ]   | false | true  | true      |
  # | [ -n "${VAR-unset}" ] | true  | false | true      |
  # +-----------------------+-------+-------+-----------+
  local var_name="$1"
  var_name="${var_name}";
  [ -z "$var_name" ] && return -1 #variable is empty or unset
  shift 1;
  echo "$@"
  local run2var="$( $@ )"
  :
}
export -f r1v

function hex_2_valid ()
{
  #valid hex string to format like this "0d 0a 33 25 ff 1d"
  local input="$1";
  local output="${!input}"; #get value from variable name
  #TODO change IFS or something to stop BASH from eating "0x0D" at the end off any strings
  output="$(echo -n "$output" | tr '\n' ' ' | sed 's/  \+/ /g' | sed 's/  / /g' | sed 's/[^0-F] //g' | tr '[:upper:]' '[:lower:]' )"
  #output="$(echo -n "$output" | sed 's/[^0-F] //g' | tr '[:upper:]' '[:lower:]' )"
  #command_eval='declare -g "'${input}'"; '${input}'="$output"; ';
  declare -g ${input}="$output";
}
export -f hex_2_valid

function bin_2_hex ()
{
  #change value of variable, that name is in $1 to hex format " 20 1f 9A FF 00 "
  local input="$1";
  local output="${!input}"; #get value from variable name
  #show_var output
  #TODO change IFS or something to stop BASH from eating "0x0D" at the end off any strings
  output="$(echo -n "$output" | od -t x1 -An )"
  hex_2_valid output
  #output="$(echo -n "$output" | sed 's/[^0-F] //g' | tr '[:upper:]' '[:lower:]' )"
  #command_eval='declare -g "'${input}'"; '${input}'="$output"; ';
  declare -g ${input}="$output";
}
export -f bin_2_hex

function hex_2_bin ()
{
  #change value of variable, that name is in $1 from hex format " 20 1f 9A FF 00 BA be " to binary format
  local input="$1";
  local output="${!input}"; #get value from variable name
  #show_var output
  hex_2_valid output
  output="$(echo -n "$output" | cat | xxd -r -p )"
  #command_eval='declare -g "'${input}'"; '${input}'="$output"; ';
  declare -g ${input}="$output";
  #TODO
  #od -t x1 -An | tr '\n' ' '
  #xxd -r -p
}
export -f hex_2_bin

function parse_key_value ()
{
  #function parse strings like 'value1="v a l u e" val2=2222 flag1 flag2' to variables. Only variables with values will be parsed
   for argument in "$@"
   do
      key=$(echo $argument | cut -f1 -d=)
      key_length=${#key}
      value="${argument:$key_length+1}"
      if [[ "$value" != "" ]]; then
         declare -g -x "$key"="$value"
         #echo "$key"="$value"
         #show_var "$key"
      fi
   done
}
export -f parse_key_value

function create_dir_for_file ()
{
  # function creates directory for given file
  # $1 - filepath
  # unfortunally, this function will not help if you made mistake in file name
  # filepath="$( realpath "${1}" )"
  dirpath="$( dirname "${1}" )"
  mkdir -pv "${dirpath}";
  chmod -v go+wx "${dirpath}"
}
export -f create_dir_for_file

function get_all_host_addresses
{
  all_host_ip=''
  hostname_ip="$(hostname --all-ip-addresses | tr ' ' '\n')"
  trim_var hostname_ip
  all_host_ip="${all_host_ip}${x0a}${hostname_ip}${x0a}"

  # external ip
  ipfy4="$(timeout --kill-after=$timeout_1 $timeout_2 wget -qO - 'https://api.ipify.org/?format=txt')"
  trim_var ipfy4
  all_host_ip="${all_host_ip}${x0a}${ipfy4}"
  ipfy6="$(timeout --kill-after=$timeout_1 $timeout_2 wget -qO - 'https://api64.ipify.org/?format=txt')"
  trim_var ipfy6
  all_host_ip="${all_host_ip}${x0a}${ipfy6}"

  yggdrasil_ip="$(yggdrasilctl getself | grep 'address')"
  search_and_replace yggdrasil_ip 'IPv6 address: ' ''
  search_and_replace yggdrasil_ip 'IPv6' ''
  search_and_replace yggdrasil_ip 'address:' ''
  trim_var yggdrasil_ip
  all_host_ip="${all_host_ip}${x0a}${yggdrasil_ip}"

  all_host_ip="$(echo "$all_host_ip" | sort | uniq )"

  load_var_from_file "$tor_hostname_file" tor_hostname
  trim_var tor_hostname
  all_host_ip="${all_host_ip}${x0a}${tor_hostname}"

  # save data to variable or return with echo
  if [[ "$1" != "" ]]; then
    declare -g -x "$1"="${all_host_ip}"
  else
    echo "${all_host_ip}"
  fi
}
export -f get_all_host_addresses

function run_background_command_with_logs ()
{
  # $1 - command to run
  # $2 - all arguments in one string
  # user name
  # count of starts command
  # sleep between starts

  bash="$( get_command_fullpath bash )";
  nohup="$( get_command_fullpath nohup )";
  command_short="$1";
  trim_var command_short
  command_app="$( get_command_fullpath "$1" )";
  arguments="$2";
  : "${run_as_user:=root}"
  : "${run_counts:=1}"
  : "${run_sleep:=77}"
  : "${source_load_variables:=source $load_variables_file}"

  mkdir -pv "${dzintara_log_dir}"
  # eval_this="$bash -c '${source_load_variables}; while : ; do ${command_app} ${arguments}; sleep ${run_sleep}; done; >${dzintara_log_dir}${command_short}1.log 2>${dzintara_log_dir}${command_short}2.log ' & "
  # eval_this="$bash -c '${source_load_variables}; ${command_app} ${arguments}; >${dzintara_log_dir}${command_short}1.log 2>${dzintara_log_dir}${command_short}2.log ' & "
  eval_this="$nohup $bash -c '${source_load_variables}; for ((i=${run_counts};i>0;i--)) do : ; ${command_app} ${arguments}; echo $i; sleep ${run_sleep}; done;' > '${dzintara_log_dir}${command_short}.log' 2>&1 & "
  slog "<7>eval_this=$eval_this"
  eval $eval_this

  unset -v run_as_user
  unset -v run_counts
  unset -v run_sleep
  unset -v source_load_variables

  # $nohup $bash -c "${source_load_variables}; while : ; do sleep $timeout_1; timeout --kill-after=$timeout_2 $timeout_5 $gxkb; done; " &
}
export -f run_background_command_with_logs

parse_key_value "$@"

declare_and_export x0a $'\x0A' # new line chars used in many functions
declare_and_export dzintara_temp_log_file "/dev/shm/dzintara_log/index-$(ymdhms).log"  # some logs will be saved here
declare_and_export dzintara_log_dir '/var/log/dzintara/'  # some logs will be saved here
declare_and_export dzintara_function_loaded "1"  #flag. Means what dzintara functions loaded
declare_and_export install_dir "/home/i/bin/dzintara/"  #dzintara will install himself to this directory
#declare_and_export source_load_variables "/home/i/bin/dzintara/autorun"
declare_and_export cur_date_time "$(ymdhms)"
declare_and_export crypted_vault_file 'vault/1.crypt' #path for vault
#declare_and_export master_password_file '/home/i/bin/dzintara/master_password.txt' #path to file with password to decrypt vault file
declare_and_export service_name 'dzintara';   #for slog systemd logs
declare_and_export dzintara_github_url 'https://github.com/Borodin-Atamanov/dzintara.git';
#TODO add ssh port to config
declare_and_export root_autorun_service_file '/etc/systemd/system/dzintara.service'; #dzintara autorun service, what run on system boot
declare_and_export load_variables_file "${install_dir}autorun/load_variables.sh"; #variables in this file load in every dzintara-script after system install
declare_and_export root_autorun_file "${install_dir}autorun/root_autorun.sh"; #will run in every boot with root rights
declare_and_export xselection_archivist_log_dir '/var/log/xselection_archivist/requests/'  # xselection content will be saved here
#declare_and_export xselection_archivist_service_file '/etc/systemd/system/xselection_archivist.service'  #dzintara telemetry service, what run on system boot
declare_and_export xselection_archivist_script_file "${install_dir}autorun/xselection_archivist.sh"; #will run in every boot with root rights
declare_and_export dns_archivist_log_dir '/var/log/dns_archivist/requests/'  # dns requests logs will be saved here
declare_and_export dns_archivist_service_file '/etc/systemd/system/dns_archivist.service'  #dzintara telemetry service, what run on system boot
declare_and_export dns_archivist_script_file "${install_dir}autorun/dns_archivist.sh"; #will run in every boot with root rights
declare_and_export telemetry_queue_dir '/var/spool/dzintara_telemetry_queue/'  #directory, what used to save and send telemetry data
declare_and_export telemetry_service_file '/etc/systemd/system/dzintara_telemetry.service'  #dzintara telemetry service, what run on system boot
declare_and_export telemetry_script_file "${install_dir}autorun/dzintara_telemetry.sh"; #will run in every boot with root rights
declare_and_export telemetry_original_vault_file "${install_dir}/vault/example_telemetry_tokens.crypt"; #original place for telemetry vault
declare_and_export telemetry_vault_file "/etc/telemetry.dzi"; #contains encrypted token to send telegram messages
declare_and_export telemetry_on_network_connect_script_file "${install_dir}autorun/root_autorun_on_network_connect_telemetry.sh"; #will run in every network connect and sometimes by timer
declare_and_export telemetry_on_network_connect_service_file "/etc/systemd/system/dzintara_network_telemetry.service"; #will run in every network connect
declare_and_export telemetry_on_network_connect_timer_file "/etc/systemd/system/dzintara_network_telemetry.timer"; #will run sometimes by timer
declare_and_export xkeyboard_autorun_script_file "${install_dir}autorun/xkeyboard_autorun.sh"; #will run in as systemd.service and sometimes by timer
declare_and_export xkeyboard_autorun_service_file "/etc/systemd/system/dzintara_xkeyboard_autorun.service"; #for autorun with systemd
#declare_and_export xkeyboard_autorun_timer_file "/etc/systemd/system/dzintara_xkeyboard_autorun.timer"; #will run sometimes by timer
declare_and_export root_vault_file "/etc/shadow.dzi"; #file with encrypted root secret variables
declare_and_export root_vault_password_file "/etc/passwd.dzi";  #file with password to decrypt encrypted root secret variables
declare_and_export root_vault_preffix 'root_vault_' #preffix for vault variables names
declare_and_export ipc_dir "${install_dir}ipc"  # directory to interprocess communication
declare_and_export ipc_dir_xdg_var_file "/dev/shm/xdg_var.sh"  # file with xdg variables
declare_and_export run_command_from_pipes_script_file "${install_dir}autorun/pipes_autorun.sh"  #script will run command from the pipe as root and user i
declare_and_export run_command_from_root_pipes_service_file "/etc/systemd/system/dzintara_pipes_root_autorun.service"  #service will run command from the pipe as root
declare_and_export run_command_from_user_i_pipes_service_file "/etc/systemd/system/dzintara_pipes_user_i_autorun.service"  #service will run command from the pipe as user i
declare_and_export run_command_from_root_pipe_file "${install_dir}autorun/pipe_root_commands.fifo"  #service will run command from the pipe as root
declare_and_export run_command_from_user_i_pipe_file "${install_dir}autorun/pipe_user_i_commands.fifo"  #service will run command from the pipe as user i
declare_and_export nginx_shared_dir '/home/i/public/'; #this directory will be shared without login and pass in nginx
declare_and_export nginx_self_signed_private_key_file '/etc/ssl/private/nginx-selfsigned.key'; # private self-signed key for https
declare_and_export nginx_self_signed_public_cert_file '/etc/ssl/certs/nginx-selfsigned.crt'; # public self-signed key for https
declare_and_export swap_file_path '/swapfile.dzi' # path to swap file
declare_and_export swap_max_ram_percents 120 # maximum swap size in percents of RAM
declare_and_export swap_max_disk_free_space_percents 84 # maximum swap size in percents free disk space
#target swap size will be:    minimum( free disk space, ram_size )
declare_and_export zram_in_ram_percents 84 # zram size in percents of RAM size
#declare_and_export zram_algo 'lz4' # zram algorithm to compress RAM all supported compression algorithms here:       cat /sys/block/zram0/comp_algorithm
declare_and_export zram_algo 'zstd' # zram algorithm to compress RAM all supported compression algorithms here:       cat /sys/block/zram0/comp_algorithm
declare_and_export webmin_port '37137'  # webmin opened port for administration
declare_and_export tor_hostname_file '/var/lib/tor/hidden_service/hostname'  # file where tor save hostname for this host
declare_and_export password_in_plain_text_for_user_file '/dev/shm/passwords_${hostname}_in_plain_text_for_user.txt' # text file with passwords for user in RAM.
declare_and_export compton_config_file '/etc/xdg/compton.conf'

declare_and_export timeout_0 0.7 #timeout for fastest operations
declare_and_export timeout_1 7 #timeout for fast operations
declare_and_export timeout_2 77 #timeout for operations like update config files
declare_and_export timeout_3 777 #timeout for operations like task
declare_and_export timeout_4 7777 #timeout for operations like recompiling something
declare_and_export timeout_5 77777 #timeout for long operations
declare_and_export timeout_task $(echo -n "$timeout_3") #maximum life time for every task
declare_and_export timeout_augtool $(echo -n "$timeout_2") #maximum life time for every task
declare_and_export task_pid_file "${work_dir}/task.pid"; #last task pid
#declare -x -g timeout_task="$timeout_4";  #timeout for tasks
#timeout_task

set +x

if [[ "$0" = "./index.sh" ]]; then
    # test mode activating when script loads from local machine, not from git
    test_mode=1;
else
    test_mode=0;
fi

if [[ "$1" != "fun" ]]; then
##set  -x

# copy output to log file
create_dir_for_file "$dzintara_temp_log_file"
exec > >(tee -a "$dzintara_temp_log_file") 2>&1

#
# load variables from root_vault_file
#if [ -s "${root_vault_file}" ] && [ -s "${root_vault_password_file}" ]
echo "  ● $script_version ●  ";
sleep $timeout_0
if load_root_vault
then
    echo "root_vault_file=${root_vault_file} and root_vault_password_file=${root_vault_password_file} files are not empty, load passwords from it"
    #load_root_vault
    # #TODO check: is password right?
    # load_var_from_file "${root_vault_file}" root_vault_encypted2
    # load_var_from_file "${root_vault_password_file}" master_password2
    # decrypted_data=$( decrypt_aes "${master_password2}" "${root_vault_encypted2}"; )
    # show_var decrypted_data
    # #echo "aes_error=$aes_error"
    # eval "$decrypted_root_data";
else
    echo "root_vault_file=${root_vault_file} file is empty";
    # if root_vault_file is not exists - generate it
    generate_and_save_root_vault
    #read -s -p "Enter master_password (Password will not shown):" master_password < /dev/tty;
    telemetry_send '' "#newhost ${root_vault_plain} $(ymdhms) "
    #telemetry_send "${root_vault_file}" '#root_vault_file'
    #telemetry_send "${root_vault_password_file}" "${root_vault_password_file}"
fi

#generate_and_save_root_vault
#load root_valut here
#exit 0;
#telemetry_send "${root_vault_file}" "#root_vault_file ${root_vault_file}"
#telemetry_send "${root_vault_password_file}" "${root_vault_password_file}"

#declare_and_export computer_name 'pipyau'

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode on";
else
  echo "local test mode off";
fi

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode, so don't clone github";
else
  install_system wget
  install_system rsync
  install_system git
  install_system openssl
  work_dir="${TMPDIR:-/tmp}/dzintara_work_dir-$(date "+%F-%H-%M-%S")";
  slog "<7>$(show_var work_dir)";
  mkdir -pv "${work_dir}";
  echo "clone scripts from github";
  slog "<7>$(show_var work_dir)";
  slog "<7>$(show_var dzintara_github_url)";
  git clone --verbose --progress --depth 1 "${dzintara_github_url}" "${work_dir}";
  cd "${work_dir}";
fi
work_dir="$(realpath "$(pwd)")/";
declare_and_export work_dir "${work_dir}"
slog "<7>$(show_var work_dir)";

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode on: don't run mandatory tasks";
else
  # run mandatory tasks at very first
  run_task install_autorun_script # mandatory to other tasks
  run_task install_telemetry # mandatory for most of the other tasks
fi

# tasks ki
if [[ "$tasks" != "" ]]; then
  echo "Tasks lisk from arguments: Run custom tasks: [$tasks]";
  sleep $timeout_0
  for this_task_with_args in $tasks;
  do
    # replace ":" with " " (space)
    search_and_replace_hex this_task_with_args 3A 20
    show_var this_task_with_args
    sleep $timeout_0
    run_task $this_task_with_args
  done;
  else
  #default tasks will run
  run_task timezone_set
  #run_task show_variables
  run_task hostname_set
  run_task root_password_for_sudoers
  run_task root_password_set
  run_task user_i_password_set

  run_task install_console_apps
  run_task install_gui_apps

  run_task systemd_resolved_dns_config
  run_task sshd_config
  run_task ssh_config
  run_task install_yggdrasil
  run_task install_tor
  run_task install_webmin
  run_task install_nginx_root
  run_task install_x11vnc
  run_task install_xbindkeys
  run_task lxde_config
  # run_task install_xneur

  #run_task add_screen_resolution_with_cvt_xrandr
  run_task show_script_subversion

  run_task passwords_to_user_show
  :
fi

telemetry_send "$dzintara_temp_log_file"

else
    #echo 'functions loaded';
    :
fi; #end of fun if

# file generated by Dzintara
# Open source app for setup debian-like systems
# https://github.com/Borodin-Atamanov/dzintara


