#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#load this script before any task

script_base_name=$(basename "${0}");
script_base_name="${script_base_name%.*}";
#echo $script_base_name;
export script_base_name;
#pwd;
echo "████ task ${script_base_name} ${0} ████";

if [[ "$function_loaded" != "1" ]]; then
  #load all functions and variables
  source "${work_dir}/index.sh" fun
fi;
cd "${work_dir}";

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

