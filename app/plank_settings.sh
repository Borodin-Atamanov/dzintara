#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script starts plank with settings

source "/home/i/bin/dzintara/autorun/load_variables.sh"
#declare_and_export work_dir "/home/i/bin/dzintara/"

if [[ "$1" != "" ]]; then
  working_dir="$1"
else
  working_dir="/home/i/downloads/"
fi

cd "$working_dir"
# x-terminal-emulator --working-directory="$working_dir" --loginshell --title="$working_dir"

declare -x XDG_SESSION_TYPE=x11
plank --preferences --verbose --debug

# dconf dump /net/launchpad/plank/docks/ > /path/where/to/save/plank/docks.ini
# And then one may want to reload the saved settings:
# cat /path/where/saved/plank/docks.ini | dconf load /net/launchpad/plank/docks/
