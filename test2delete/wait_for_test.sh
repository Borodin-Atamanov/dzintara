#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}tasks/1.sh"

#set  -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;


#wait_for 13 'ps -e | grep -c Xorg'

wait_for 13 'is_process_running Xorg'

