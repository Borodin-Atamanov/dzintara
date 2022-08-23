#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
echo "run $0";

if [[ "$function_loaded" != "1" ]]; then
  #load all functions and variables
  source ../index.sh fun
fi;

#declare_and_export name1 "valueeee"
#echo "$name1";

echo -n "secrets_pipyau_root_pass=";
echo '"'$( get_var "${secrets}_${computer_name}_root_pass" )'"'

#echo "${get_var_last_name}";

if [[ $EUID -ne 0 ]]; then
   echo "Must be run as root! $0"
   exit 1
fi

passwd --status  --all
