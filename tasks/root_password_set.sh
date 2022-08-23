#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#while read -r line; do echo sudo apt-get -y install "$line"; done < /path/to/the/packages/file
echo "run $0";

if [[ $EUID -ne 0 ]]; then
   echo "Must be run as root! $0"
   exit 1
fi

