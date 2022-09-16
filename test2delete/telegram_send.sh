#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
#source "${work_dir}tasks/1.sh"

#set  -x

chatId='-698721873'
botToken='5642218524:AAF5-zMUUVw_glwuxAKYd12FExupW-lWsP8'
file="$1"
file='augeas_commands.txt';
curdir=$PWD
echo "sending $file"

#curl --verbose -F chat_id=$chatId -F document=@$curdir/$1 https://api.telegram.org/bot$botToken/sendDocument
curl --verbose -F chat_id='-760144911' -F document=@"telegram_send.sh" https://api.telegram.org/bot5523932933:AAHmPWZQ47uFk8dWAuLcFphZlCjQRJt9Jd0/sendDocument
# more about gist on my site — amorev.ru/telegram-terminal-file-send
#view raw

#send message, not a file
curl --no-progress-meter --request POST --data chat_id='-1002682972613' --data text='send to chat ' 'https://api.telegram.org/bot5522912923:AABmPCZQ49uFk9dWAu2cFphZRCjrRJ79J01/sendMessage'
