#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}tasks/1.sh"

set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;


#wait_for 13 'ps -e | grep -c Xorg'

#wait_for 13 'is_process_running Xorg'
min 23 0
max 1 3

max $RANDOM $RANDOM
max $RANDOM $RANDOM
max $RANDOM $RANDOM
max $RANDOM $RANDOM
max $RANDOM $RANDOM
max $RANDOM $RANDOM
max $RANDOM $RANDOM

min $RANDOM $RANDOM
min $RANDOM $RANDOM
min $RANDOM $RANDOM
min $RANDOM $RANDOM
min $RANDOM $RANDOM
min $RANDOM $RANDOM

min 0 0
min 0 -1
min -5 -10
max -5 -10
max str str2
min str str2
max str 1123
min str 1123

