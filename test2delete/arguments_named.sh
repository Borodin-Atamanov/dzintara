#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
source "${work_dir}tasks/1.sh"

#set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

for argument in "$@"
do
   key=$(echo $argument | cut -f1 -d=)

   key_length=${#key}
   value="${argument:$key_length+1}"

   #export "$key"="$value"
   if [[ "$value" != "" ]]; then
      echo declare -g -x "$key"="$value"
   fi
done


if [[ "$tasks" != "" ]]; then
   #echo declare -g -x "$key"="$value"
   echo 'Run some tasks!'
   for argument in "$@";
   do
      :
   done;

fi

# use here your expected variables
echo "v1 = $v1"
echo "v2= $v2"
echo "v3 = $v3"


