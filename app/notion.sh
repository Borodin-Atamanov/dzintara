#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
# script try to start keeweb application in some way


source "/home/i/bin/dzintara/autorun/load_variables.sh" nocd
#declare_and_export work_dir "/home/i/bin/dzintara/"

url="https://notion.so/?from=dzintara"

xdg-open "$url"
