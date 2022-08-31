#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#load this script before any task

if [[ "$dzible_function_loaded" != "1" ]]; then
  #load all functions and variables
  source "${work_dir}/index.sh" fun
fi;

cd "${work_dir}";

