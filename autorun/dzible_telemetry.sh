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
root_vault_password=$(cat "${root_vault_password_file}" | base32 -d -i);
#show_var root_vault_password

#decrypt root vault
encrypted_data=$(cat "${root_vault_file}");
#encrypted_data=$( encrypt_aes "${pass}" "${data}"; )
decrypted_data=$(decrypt_aes "${root_vault_password}" "${encrypted_data}")
show_var decrypt_aes_error
#echo "$decrypted_data";
#load all variables from decrypted vault
eval "${decrypted_data}";
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
    echo -n "${next_dir}";
    cd "${OLD_DIR}";
}
export function telemetry_get_next_message_dir

function telemetry_send_telegram_dir ()
{
    #get directory with telemetry message, try to send it to telegram
    target_dir="${1}";
    OLD_DIR=$(pwd);
    cd "${telemetry_queue_dir}";
    target_dir=$( realpath "${target_dir}" );
    if [[ "${target_dir}" = "$( realpath "${telemetry_queue_dir}")" ]]; then
        slog "<7>Will not process root directory ${target_dir}"
        return 2;
    fi;

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

    slog "<7>$(show_var send_file) $(show_var send_text)"
    if [[ "${send_file}" != "" ]]; then
        #send file and message
        #request="curl --verbose --form chat_id='${telemetry_telegram_bot_chat_id}' --form document=@'${send_file}' --data text='${send_text}' '${request_url}sendDocument' ";
        #request="curl --verbose --request POST --data chat_id='${telemetry_telegram_bot_chat_id}' --data document=@'${send_file}' --data text='${send_text}' '${request_url}sendDocument' ";
        request="curl --form  document=@'${send_file}' --form chat_id='${telemetry_telegram_bot_chat_id}' --form caption='${send_text}' '${request_url}sendDocument' ";
        slog "<7>$(show_var request)";
        result="$( request )";
        #curl -s -X POST "${request_url}sendDocument" -d chat_id="${telemetry_telegram_bot_chat_id}" -d text="${send_text}"
        slog "<7>$(show_var result)";
    else
        #send only text message, without file
        request="curl --request POST --data chat_id='${telemetry_telegram_bot_chat_id}' --data text='${send_text}' '${request_url}sendMessage'  "
        slog "<7>$(show_var request)";
        result="$( request )";
        slog "<7>$(show_var result)";
    fi;


    cd "${OLD_DIR}";
    # telemetry_telegram_bot_chat_id
    # telemetry_telegram_bot_token
    #in directory we will find:
    #text.txt - text to send
    #send.txt - mark, what means what directory ready for send data
    #file.txt - filepath to send file

    #TODO wait a sec after last message sended
    sleep 0.$RANDOM;

    #TODO delete target dir if message sent successfully
    rm -rv "$target_dir"

    # chatId='-698761873'
    # botToken='5692208524:AAF6-zMUUVw_glwuxAKYd12FExupW-lWsP8'
    # file="$1"
    # file='augeas_commands.txt';
    # curdir=$PWD
    # echo "sending $file"
    #
    # #curl --verbose -F chat_id=$chatId -F document=@$curdir/$1 https://api.telegram.org/bot$botToken/sendDocument
    # #curl --verbose -F chat_id=$chatId -F document=@"${file}" https://api.telegram.org/bot${botToken}/sendDocument
    # # more about gist on my site — amorev.ru/telegram-terminal-file-send
}
export function telemetry_get_next_message_dir

for ((i=1;i>=0;i--)); do
    next_dir=$(telemetry_get_next_message_dir)
    show_var next_dir
    telemetry_send_telegram_dir "${next_dir}"
    echo "${i} $(show_var next_dir)";
    sleep 0.1;
done;

send_telemetry "/home/i/github/dzible/test/heredoc_test.sh" "sended file /proc/cpuinfo"

exit 42;

while 1 ; do
    #countdown 15 0.1
    countdown
    echo 1;
    sleep 1;
done;
#
# time for dir in */ ;
# do echo "$dir";
#     cd "$dir";
#     : ;
#     cd "${BDIR}";
# done;

sleep 3;
