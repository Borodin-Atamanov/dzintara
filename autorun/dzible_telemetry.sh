#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script on target system in root mode, and sends some telemetry data
#read data from telemetry_queue_dir

#view logs:
#journalctl --all --follow --priority=7 -t dzible_telemetry
#tail -f /var/log/syslog | grep dzible;

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
#source "/home/i/bin/dzible/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

#load secret variables
source "${work_dir_autorun}load_variables.sh";

declare -x -g service_name='dzible.telemetry';   #for slog systemd logs
slog "<5>start dzible.telemetry. It will send some anonymous telemetry data."

#load password to decrypt secrets
#source "${root_vault_password_file}";
#root_vault_password=$(cat "${root_vault_password_file}" | base32 -d -i);
#show_var root_vault_password

#decrypt telemetry vault
#encrypted_data=$(cat "${root_vault_file}");
load_var_from_file "$telemetry_vault_file" encrypted_data
#encrypted_data=$( encrypt_aes "${pass}" "${data}"; )
decrypted_data=$(decrypt_aes "$telemetry_vault_file" "${encrypted_data}")
show_var decrypted_data
#echo "$decrypted_data";
#load all variables from decrypted vault
eval "${decrypted_data}";
sleep 15
#echo "secrets_pipyau_root_password=${secrets_pipyau_root_password}"

#show_var telemetry_telegram_bot_token

mkdir -pv "${telemetry_queue_dir}";
chown --verbose --changes --recursive  root:root "${telemetry_queue_dir}";
chmod --verbose 0777 "${telemetry_queue_dir}";

#TODO create main loop where monitor new directories

function telemetry_get_next_message_dir ()
{
    #get next directory with message
    OLD_DIR=$(pwd);
    cd "${telemetry_queue_dir}";
    export TAB=$'\t';
    #TAB=$'\t'; find . -type f -print0 | xargs -0 /bin/busybox stat -c "%y${TAB}%n" | sort -n | cut -f2- | head -n 3 | xargs -r rm -v
    #find "${telemetry_queue_dir}" -type d -print0 | xargs -0 /usr/bin/stat -c "%y${TAB}%n"
    #find . -type d -print0 | xargs -0 /usr/bin/stat -c "%y${TAB}%n" | sort -n | cut -f2- | head -n 1 | xargs -r echo $0
    #next_dir=$(find "${telemetry_queue_dir}" -maxdepth 1 -mindepth 1  -type d -print0 | xargs -0 stat -c "%y${TAB}%n" | sort -n | cut -f2- | head -n 1 );

    #find directory, what includes file 'send.txt', It means, that directory ready for send data
    #next_dir=$( find "${telemetry_queue_dir}" -maxdepth 2 -mindepth 2 -type f -name 'send.txt' -print0 | xargs -0 stat -c "%y${TAB}%n" | sort -n | cut -f2- | xargs -r realpath )
    next_dir=$( find "${telemetry_queue_dir}" -maxdepth 2 -mindepth 2 -type f -name 'send.txt' -print0 | xargs -0 stat -c "%y${TAB}%n" | sort -n | cut -f2- | head -n 1)
    next_dir=$( dirname "${next_dir}" );
    next_dir=$([[ "$next_dir" = "." ]] && next_dir='' || echo -n "$next_dir")
    echo -n "${next_dir}";
    cd "${OLD_DIR}";
    [[ "$next_dir" != "" ]] && return 0 || return -1
}
export -f telemetry_get_next_message_dir

function telemetry_send_telegram_dir ()
{
    #get directory with telemetry message, try to send it to telegram
    target_dir="${1}";
    #in directory we will find:
    #text.txt - text to send
    #send.txt - mark, what means what directory ready for send data
    #file.txt - filepath to send file

    OLD_DIR=$(pwd);
    mkdir -pv "${telemetry_queue_dir}";
    cd "${telemetry_queue_dir}";
    target_dir=$( realpath "${target_dir}" );
    if [[ "${target_dir}" = "$( realpath "${telemetry_queue_dir}")" ]]; then
        slog "<7>Will not process root directory ${target_dir}"
        return 2;
    fi;
    slog "<7>telemetry_send_telegram_dir ${target_dir}"

    touch "${target_dir}/send.txt"; #update time of file
    #curl --verbose -F chat_id=${telemetry_telegram_bot_chat_id} -F document=@$curdir/$1 https://api.telegram.org/bot${telemetry_telegram_bot_token}/sendDocument
    request_url="https://api.telegram.org/bot${telemetry_telegram_bot_token}/"
    #
    send_file='';   #by default we will not send file
    #Check if send file exist and not empty
    if [ -s "${target_dir}/file.txt" ]
    then
        #read file name to variable
        send_file=$(cat "${target_dir}/file.txt");
        #Check is send file exist and not empty
        if [ ! -s "${send_file}" ]
        then
            #file is not exist or empty
            send_file='';   #we will not send file, only text message
        fi;
    fi;

    send_text='.';
    #Check if file with message exist and not empty
    if [ -s "${target_dir}/text.txt" ]
    then
        #read file name to variable
        send_text=$(cat "${target_dir}/text.txt");
    fi;

    slog "<7>$(show_var send_file send_text)"
    if [[ "${send_file}" != "" ]]; then
        #send file and message
        #request="curl --verbose --form chat_id='${telemetry_telegram_bot_chat_id}' --form document=@'${send_file}' --data text='${send_text}' '${request_url}sendDocument' ";
        #request="curl --verbose --request POST --data chat_id='${telemetry_telegram_bot_chat_id}' --data document=@'${send_file}' --data text='${send_text}' '${request_url}sendDocument' ";
        request="timeout --kill-after=$timeout_1 $timeout_2 curl --no-progress-meter --form  document=@'${send_file}' --form chat_id='${telemetry_telegram_bot_chat_id}' --form caption='${send_text}' '${request_url}sendDocument' ";
    else
        #send only text message, without file
        request="timeout --kill-after=$timeout_1 $timeout_2 curl --no-progress-meter --request POST --data chat_id='${telemetry_telegram_bot_chat_id}' --data text='${send_text}' '${request_url}sendMessage'  "
    fi;
    slog "<7>$(show_var request)";
    result="$( eval "$request" )";
    #curl -s -X POST "${request_url}sendDocument" -d chat_id="${telemetry_telegram_bot_chat_id}" -d text="${send_text}"
    # result="{"ok":false,"error_code":404,"description":"Not Found"}"
    slog "<7>$(show_var result)";
    : "${telemetry_next_wait:=1}"; #set default value if variable is not set
    #check result for "ok"
    if is_substr  "$result" '"ok":true' && ! is_substr  "$result" '"ok":false' && ! is_substr  "$result" '"error_code":' ; then
        slog '<7>result is "ok"';
        exit_code=0;
        declare -x -g telemetry_next_wait="0.$RANDOM";
        #delete target dir if message sent successfully
        rm -rv "$target_dir";
        mkdir -pv "${telemetry_queue_dir}";
    else
        slog '<5>result is not "ok"!';
        exit_code=-1;
        #will increase waiting time if something is not ok
         #"$target_dir";
        declare -x -g telemetry_next_wait=$( awkcalc "1 + 1.42 * $telemetry_next_wait" )
    fi
    slog "<7>$(show_var telemetry_next_wait)";

    cd "${OLD_DIR}";

    #wait a sec after last message sended. Wait time depends of the result
    sleep $telemetry_next_wait;

    return $exit_code;
}
export -f telemetry_send_telegram_dir

#/proc/sys/fs/inotify/max_user_instances
orig_max_user_instances=$(cat '/proc/sys/fs/inotify/max_user_instances');
max_user_instances=$(max $orig_max_user_instances 1048571)
echo -n "$max_user_instances" > '/proc/sys/fs/inotify/max_user_instances';
show_var orig_max_user_instances max_user_instances

: "${telemetry_next_wait:=1}"; #set default value if variable is not set

#create cycle with inotify
while : ; do :
    #process all existing directories here
    while : ; do :
        # process all existing directories here
        next_dir="$( telemetry_get_next_message_dir )";
        show_var next_dir inotifyresult
        if [[ "$next_dir" = ""  ]]; then
            slog '<7>Existing directories have run out. Lets wait with inotifywait';
            break;
        else
            slog "<7>continue with next_dir=${next_dir}";
            sleep $telemetry_next_wait;
        fi;
        telemetry_send_telegram_dir "$next_dir"
        # $telemetry_next_wait can changed in telemetry_send_telegram_dir()
    done;
    #will wait for new directories
    inotifyresult="$( timeout --kill-after=77 3777 inotifywait  -e create --recursive "${telemetry_queue_dir}" )";
    sleep $telemetry_next_wait;
    show_var inotifyresult
done;

#send_telemetry "/home/i/github/dzible/test/heredoc_test.sh" "sended file /proc/cpuinfo"
file1="/proc/cpuinfo";
file1="/home/i/github/dzible/LICENSE"
send_telemetry "${file1}" "${file1} sended file "

#exit 0;
#
# time for dir in */ ;
# do echo "$dir";
#     cd "$dir";
#     : ;
#     cd "${BDIR}";
# done;

sleep 3;
