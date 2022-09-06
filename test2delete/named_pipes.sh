#!/usr/bin/bash

work_dir='/home/i/github/dzible/';
source "${work_dir}tasks/1.sh"

#set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

fifo_name='fifo.fif'

if [[ "$1" = "writer" ]]; then
    #test_mode=1;
    #write to pipe
    echo 'write to pipe'
    for ((i=42;i>0;i--))
    {
        echo $i | tee -a "$fifo_name";
        sleep 3.2;
    }

    :
else
    #read from pipe
    echo 'read from pipe'
    stat "$fifo_name"
    rm -v "$fifo_name"
    mkfifo "$fifo_name"
    stat "$fifo_name"
    for ((i=15;i>0;i--))
    {
        echo $i;
        cat "$fifo_name";
        sleep 2.2;
    }
    :
fi
