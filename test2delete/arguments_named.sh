#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}tasks/1.sh"

#set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

function parse_key_value ()
{
   for argument in "$@"
   do
      key=$(echo $argument | cut -f1 -d=)
      key_length=${#key}
      value="${argument:$key_length+1}"
      if [[ "$value" != "" ]]; then
         declare -g -x "$key"="$value"
         #echo "$key"="$value"
         #show_var "$key"
      fi
   done
}
export -f parse_key_value

parse_key_value "$@"
#parse_key_value "$@"

if [[ "$tasks" != "" ]]; then
   echo 'Run some tasks!'
   for this_task in $tasks;
   do
      show_var this_task
      :
   done;

fi

# use here your expected variables
echo "v1 = $v1"
echo "v2= $v2"
echo "v3 = $v3"


