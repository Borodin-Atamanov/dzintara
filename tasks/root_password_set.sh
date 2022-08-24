#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
echo "run $0";

if [[ "$function_loaded" != "1" ]]; then
  #load all functions and variables
  source ../index.sh fun
fi;

var_name="${secrets}_${computer_name}_root_pass";
show_var "$var_name"


if [[ $EUID -ne 0 ]]; then
   echo "Must be run as root! $0"
   exit 1
fi

#echo -e "$password\n$password\n" | sudo passwd root
echo -e "$( get_var "${var_name}" )\n$( get_var "${var_name}" )" | passwd root

passwd --status  --all