#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#load this script before any task

if [[ "$function_loaded" != "1" ]]; then
  #load all functions and variables
  source "${work_dir}/index.sh" fun
fi;
source "${work_dir}/index.sh" fun

cd "${work_dir}";

# if [[ $EUID -ne 0 ]]; then
#    echo "Must be run as root! $0"
#    exit 1
# fi

