#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#wget -qO - t.ly/mHc_ | bash

#function yell() { echo "$0: $*" >&2; }
#function die() { yell "$*"; exit 111; }
#function try() { "$@" || die "cannot $*"; }

echo "$0";
if [[ "$0" = "./index.sh" ]]; then
    test_mode=1;
else
    test_mode=0;
fi

if [[ "${test_mode}" = "1" ]]; then
    echo "local test mode on";
else
    echo "local test mode off";
fi

function run_task () 
{
  echo "test_mode=${test_mode}";
  if [[ "${test_mode}" = "1" ]]; then
    task_script="tasks/${1}.sh";
  else
    task_script="${temp_dir_for_bin}/tasks/${1}.sh";
  fi
  echo "task_script=${task_script}";


  if [ -s "$task_script" ]; then echo "exists! $task_script"; fi;
  sleep 100;

  ( exec "${task_script}" )
}

function run() 
{
  cmd_output=$(eval $1)
  return_value=$?
  if [ "$return_value" != 0 ]; then
    echo "Command $1 failed"
    exit -1
  else
    echo "output: $cmd_output"
    echo "Command succeeded."
  fi
  return $return_value
}


if [[ "${test_mode}" = "1" ]]; then
    echo "local test mode, so don't clone github";
else
  echo "clone scripts from github";
  temp_dir_for_bin="temp_dir_for_bin-$(date "+%F-%H-%M-%S")"; \
  mkdir -pv "${temp_dir_for_bin}";
  git clone --verbose --progress --depth 1 https://github.com/Borodin-Atamanov/dzible.git "${temp_dir_for_bin}";
fi


#"${temp_dir_for_bin}/tasks/add_screen_resolution_1280x1024_with_xrandr.sh"
#"${temp_dir_for_bin}/tasks/install_console_apps.sh"
run_task "install_console_apps"

exit 111;


