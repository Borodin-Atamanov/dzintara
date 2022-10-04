#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script starts pcmanfm with right default dir

source "/home/i/bin/dzintara/autorun/load_variables.sh"
#declare_and_export work_dir "/home/i/bin/dzintara/"

pcmanfm --no-desktop --new-win "/home/i/downloads/"
