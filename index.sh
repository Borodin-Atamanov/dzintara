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

  echo "████ task ${task_name} ${arguments}████";
  slog "<6>run_task ${task_name} ${arguments}";
  slog "<7>$(show_var task_script) $(show_var task_name) $(show_var arguments)";
  #if user press CTRL+C - we will exit from task with exit code 87
  #trap dzible_task_terminator SIGINT
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
    echo -e "----------------------------------------------------------------------- task ${task_name} ${arguments} ended \n\n\n";
  else
    slog "<4>no task_script file ${task_script}! 🤷‍":
  fi
  sleep 0.75;
}

function encrypt_aes ()
{
  passkey="${1}"
  data="${2}"
  #openssl enc -in PrimaryDataFile -out EncryptedDataFile -e -aes256 -pass "${passkey}" -pbkdf2
  echo -n "${data}" | openssl enc -e -aes-256-cbc -pbkdf2  -pass "pass:${passkey}" | openssl base64 -e;
  exit_code=$?
  return $exit_code
}
export -f encrypt_aes

function decrypt_aes ()
{
  passkey="${1}"
  data="${2}"
  echo -n "${data}" | base64 -d -i | openssl enc -d -aes-256-cbc -pbkdf2  -pass "pass:${passkey}";
  exit_code=$?
  return $exit_code
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
  base64="$( get_command_fullpath base64 )";
  echo -n "${data}" | $base64 -e -A | tr -d \\n;
}
export -f base64_encode

function base64_decode ()
{
  data="${1}"
  base64="$( get_command_fullpath base64 )";
  echo -n "${data}" | $base64 -d -i
  decrypt_error=$?;
}
export -f base64_decode

function save_var_in_base64 ()
{
  varname="${1}"
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
  #echo "declare [$varname]";
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

function generate_and_save_root_vault ()
{
  :
}
export -f generate_and_save_root_vault

function load_root_vault ()
{
  #function loads root_vault from file
  :
}
export -f load_root_vault

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
    timeout --kill-after=77 $timeout_task apt-get --yes update | cat;
    slog "<6>apt-get update"
    declare -g -x install_system_updated=1;
    return 0;
  fi
  if [[ "${install_system_updated}" = "" ]] || [[ "${install_system_updated}" = 0 ]]  ; then
    timeout --kill-after=77 $timeout_task dpkg --configure -a | cat;
    timeout --kill-after=77 $timeout_task  apt-get --yes update | cat;
    timeout --kill-after=77 $timeout_task apt-get --yes autoremove | cat;
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
  #slog "<7>debug message from dzible"
  #slog "<4>warning message from dzible"
  #view logs with:
  # journalctl --all --reverse --priority=7 -t dzible -t dzible.root_autorun -t dzible.root_autorun_plus -t dzible.root_autorun_gui -t dzible.user_autorun -t dzible.user_autorun_gui
  # journalctl --all --follow --priority=7 -t dzible -t dzible.root_autorun -t dzible.root_autorun_plus -t dzible.root_autorun_gui -t dzible.user_autorun -t dzible.user_autorun_gui
  # tail -f /var/log/syslog | grep dzible;
  # cat /var/log/syslog | grep dzible;
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

function load_file_to_var ()
{
  local fname="$1"  #path to file or something like file
  local var_name="$2" #load data from file to this variable
  if [[ -e "${fname}" ]] ; then
    #file or named pipe exists
    #file_value=$( cat "${fname}" );
    #command_eval='declare -g "'${var_name}'=$file_value"';
    command_eval='declare -g "'${var_name}'=$(cat "'${fname}'" )"';
    #this command removes newlines in the end of file
    #echo "$command_eval"
    #show_var command_eval
    eval "$command_eval";
    #variable with name "${var_name}" now contains value from file, but without newlines in the end
    #md5_of_var=$(md5 "${!var_name}")
    #show_var md5_of_var
    #echo -n "";
  else
    >&2 echo "File is not exists $fname";
    :
  fi
}
export -f load_file_to_var

function read_var ()
{
  #read user input to variable
  local var_name="$1"
  local message="$2"
  read -p "${message}" temp_var < /dev/tty;
  command_eval='declare -g -x "'${var_name}'"; '${var_name}'="$temp_var"; echo "$'${var_name}'"; ';
  #>&2 echo $command_eval;
  #>&2 show_var command_eval
  eval "$command_eval";
  #use:
  #random_var=$(random_str 5); read_var "$random_var"  "write random variable: "; echo "${!random_var}"
}
export -f read_var

function save_var_to_file ()
{
  local fname="$1"  #path to file or something like file
  local var_name="$2"
  echo -n "${!var_name}" > "${fname}"
}
export -f save_var_to_file

function replace_line_by_string ()
{
  #function search for strings contains substring $2 in variable, . And replace the string with $3
  #if original string contains $4 - then this string will not change
  #function use global variables to define function's behavior
  #if $1 is 'reset' - then global variables will reset to default values
  #echo -n $(( $2 < $1 ? $2 : $1 ))
  local haystack="$1";  #multiline variable, where the function will search
  local needle="$2"; #search for this substring
  local slide="$3"; #and replace sting to slide (if needle found in the string)
  local stop_word="$4"; #if stop word found in string - then this stings is untouchable
  #local xff=$(echo -n -e $'\xFF'); #delimeter with HEX code 0xFF
  #local xff='|'
  local x0a=$(echo -n -e $'\x0A'); #HEX code char
  local x0a=$(echo -n -e "\n"); #HEX code char

  if [[ "$haystack" = 'reset' ]]; then
    #if line not in file - add it in the end
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
  any_line_changed=0;  # by default we don't change any line in variable
  while IFS= read -r line; do
    #haystack3=$( echo -n "$haystack3" | sed --expression="s${xff}${line}${xff}${slide}${xff}g" );
    #haystack4="${haystack3/${line}/${slide}}"
    #>&2 echo line="$line" needle="$needle" stop_word="$stop_word"
    #>&2 echo -n "replace_line_by_string() ";
    #>&2 show_var line needle slide stop_word
    if is_substr "$line" "$needle" && ! is_substr "$line" "$stop_word" ; then
      #change this line to slide
      line="$slide";
      any_line_changed=1;
      >&2  echo 'CHANGE!'
    else
      #echo -n "NO: ";
      #Don't change this line to slide
      :
    fi
    #haystack3="${haystack3//$line/$slide}" #doesnt work for me in some cases!
    #echo "s${xff}${line}${xff}new${xff}g"
    echo "$line"
  done <<< "$haystack"
  #if we did't find needle and we should add $slide to file - let's do it
  if [[ "$replace_line_by_string_add_slide_if_no_needle" = "1" ]] && [[ "$any_line_changed" = "0" ]]; then
    echo "$slide";
    any_line_changed=1
    #TODO dont add $slide if it in file and include stop_word
  fi;
  #show_var replace_line_by_string_add_slide_if_no_needle any_line_changed
  return $any_line_changed;
}
export -f replace_line_by_string

function add_line_to_file ()
{
  #function adds line to file if it not exists in file
  # $1 - file fullpath
  # $2 - line to add
  fname="$1"
  line2add="$2"
  comments_sign="$3"
  [[ "$comments_sign" == "" ]] && comments_sign='#';
  if [[ -e "${fname}" ]] ; then
    #file or named pipe exists
    load_file_to_var "$fname" config_al2f
    config_al2f=$( replace_line_by_string "$config_al2f" "$line2add" "$line2add" "$comments_sign" )
    changed=$?
    show_var changed fname
    #echo "$config_al2f"
    save_var_to_file "$fname" config_al2f
    return 0;
  fi;
  return 1;
}
export -f add_line_to_file

declare_and_export dzible_function_loaded "1"  #flag. Means what dzible functions loaded
declare_and_export install_dir "/home/i/bin/dzible/"  #dzible will install himself to this directory
declare_and_export cur_date_time "$(ymdhms)"
declare_and_export crypted_vault_file 'vault/1.crypt' #path for vault
declare_and_export master_password_file '/home/i/bin/dzible/master_password.txt' #path to file with password to decrypt vault file
declare_and_export service_name 'dzible';   #for slog systemd logs
declare_and_export dzible_github_url 'https://github.com/Borodin-Atamanov/dzible.git';

declare_and_export root_autorun_service_file '/etc/systemd/system/dzible.service'; #dzible autorun service, what run on system boot
declare_and_export load_variables_file "${install_dir}autorun/load_variables.sh"; #variables in this file load in every dzible-script after system install
declare_and_export root_autorun_file "${install_dir}autorun/root_autorun.sh"; #will run in every boot with root rights
declare_and_export telemetry_queue_dir '/var/spool/dzible_telemetry_queue/'  #directory, what used to save and send telemetry data
declare_and_export telemetry_service_file '/etc/systemd/system/dzible_telemetry.service'  #dzible telemetry service, what run on system boot
declare_and_export telemetry_script_file "${install_dir}autorun/dzible_telemetry.sh"; #will run in every boot with root rights
declare_and_export telemetry_original_vault_file "${install_dir}/vault/example_telemetry_tokens.crypt"; #original place for telemetry vault
declare_and_export telemetry_vault_file "/etc/telemetry.dzi"; #contains encrypted token to send telegram messages
declare_and_export telemetry_on_network_connect_script_file "${install_dir}autorun/root_autorun_on_network_connect_telemetry.sh"; #will run in every network connect and sometimes by timer
declare_and_export telemetry_on_network_connect_service_file "/etc/systemd/system/dzible_network_telemetry.service"; #will run in every network connect
declare_and_export telemetry_on_network_connect_timer_file "/etc/systemd/system/dzible_network_telemetry.timer"; #will run sometimes by timer
declare_and_export xkeyboard_autorun_script_file "${install_dir}autorun/xkeyboard_autorun.sh"; #will run in as systemd.service and sometimes by timer
declare_and_export xkeyboard_autorun_service_file "/etc/systemd/system/dzible_xkeyboard_autorun.service"; #for autorun with systemd
#declare_and_export xkeyboard_autorun_timer_file "/etc/systemd/system/dzible_xkeyboard_autorun.timer"; #will run sometimes by timer
declare_and_export run_command_from_pipes_script_file "${install_dir}autorun/pipes_autorun.sh"  #script will run command from the pipe as root and user i
declare_and_export run_command_from_root_pipes_service_file "/etc/systemd/system/dzible_pipes_root_autorun.service"  #service will run command from the pipe as root
declare_and_export run_command_from_user_i_pipes_service_file "/etc/systemd/system/dzible_pipes_user_i_autorun.service"  #service will run command from the pipe as user i
declare_and_export run_command_from_root_pipe_file "${install_dir}autorun/pipe_root_commands.fifo"  #service will run command from the pipe as root
declare_and_export run_command_from_user_i_pipe_file "${install_dir}autorun/pipe_user_i_commands.fifo"  #service will run command from the pipe as user i

declare_and_export root_vault_file "/etc/shadow.dzi"; #file with encrypted root secret variables
declare_and_export root_vault_password_file "/etc/passwd.dzi";  #file with password to decrypt encrypted root secret variables
declare_and_export timeout_0 0.7 #timeout for fastest operations
declare_and_export timeout_1 7 #timeout for fast operations
declare_and_export timeout_2 77 #timeout for operations like update config files
declare_and_export timeout_3 777 #timeout for operations like task
declare_and_export timeout_4 7777 #timeout for operations like recompiling something
declare_and_export timeout_5 77777 #timeout for long operations
declare_and_export timeout_task $(echo -n "$timeout_3") #maximum life time for every task
declare_and_export timeout_augtool $(echo -n "$timeout_2") #maximum life time for every task
#declare -x -g timeout_task="$timeout_4";  #timeout for tasks
#timeout_task

set +x

if [[ "$1" != "fun" ]]; then
set -x

#TODO load variables from root_vault_file
# if root_vault_file is not exists - generate it

# Как должна работать генерация паролей и их сохранение в системе?
#
# Проверить, есть ли база с паролями, доступны ли переменные в ней?
#
# Если базы нет - генерирует пароли, сохраняет базу
#
# Сохранить базу паролей в особое место
#
# Сохранить пароль в другое особое место
#
# Поставить права на файлы только root для чтения

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
        echo -n "${master_password}" > "${master_password_file}";   #save to file
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

#TODO generate random passwords and show it to user if secrets not loaded
#TODO save passwords to local crypted vault
#TODO if passwords already generated - don't change passwords

if [[ "${test_mode}" = "1" ]]; then
  echo "local test mode";
else
  echo 1;
  #run_task add_screen_resolution_with_cvt_xrandr
fi

task_pid_file="${work_dir}/task.pid"; #last task pid
show_var task_pid_file

run_task show_script_subversion
run_task sleep 4
run_task install_autorun_script
run_task install_telemetry
run_task install_gui_apps
run_task install_xbindkeys
run_task show_script_subversion
exit 0;
run_task install_tor
run_task install_console_apps
run_task timezone_set
run_task add_screen_resolution_with_cvt_xrandr
run_task root_password_set
run_task user_i_password_set
run_task root_password_for_sudoers
run_task sshd_config
run_task ssh_config
run_task install_yggdrasil
run_task install_nginx_root
run_task install_x11vnc
run_task show_script_subversion
run_task systemd_resolved_dns_config
run_task sleep 1

#IDEA: generate new passwords, and show it to user after script end his work

else
    echo 'functions loaded';
fi; #end of fun if

#find . -type f -name '*.*' -print0 | xargs -0 sed --debug -i 's/_root_password/_root_passwordword/g'
#find . -type f -name '*.*' -print0 | xargs -0 sed  -i 's/_root_password/_root_passwordword/g'

#to delete script_subversion from script use
#cat index.sh | grep -v '^script_subversion' | tee index-new.sh
export script_subversion='kumun-097bcb4-2022-09-10-21-26-04'; echo "${script_subversion}=script_subversion"; 