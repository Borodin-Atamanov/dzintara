#!/usr/bin/bash

work_dir='/home/i/github/dzible/';
source "${work_dir}tasks/1.sh"

set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

set +x
run_if_not_root echo "U A not root!"; whoami;
#run_if_not_root whoami

run_if_root echo 'U A root!'
