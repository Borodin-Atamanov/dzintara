#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}index.sh" fun
source "${work_dir}tasks/1.sh"

set -x
start_log

exit
# exec 2>&1 | tee -a /home/i/github/dzintara/test2delete/logovo.log
#exec > >(tee -a "/home/i/github/dzintara/test2delete/logovo.log") 2>&1
#exec | tee -a 123.log
#exec 2>&1

date

echo 'help!'

countdown 75 0.03

echo 'help!'

$RANDOM
echo 'help!'

$RANDOM
#set  -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;


#wait_for 13 'ps -e | grep -c Xorg'

#wait_for 13 'is_process_running Xorg'



