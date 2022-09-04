#!/usr/bin/bash

work_dir='/home/i/github/dzible/';
#source "${work_dir}tasks/1.sh"

set -x

chatId='-698721873'
botToken='5642218524:AAF5-zMUUVw_glwuxAKYd12FExupW-lWsP8'
file="$1"
file='augeas_commands.txt';
curdir=$PWD
echo "sending $file"

#curl --verbose -F chat_id=$chatId -F document=@$curdir/$1 https://api.telegram.org/bot$botToken/sendDocument
curl --verbose -F chat_id=$chatId -F document=@"${file}" https://api.telegram.org/bot${botToken}/sendDocument
# more about gist on my site — amorev.ru/telegram-terminal-file-send
#view raw

