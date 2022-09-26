#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
# script try to start keeweb application in some way


source "/home/i/bin/dzintara/autorun/load_variables.sh" nocd
#declare_and_export work_dir "/home/i/bin/dzintara/"

url="https://2ip.ru/?from=dzintara"

command="chromium-browser"
if [ -x "$(command -v "$command")" ]; then
    $command --proxy-server="socks5://127.0.0.1:9050" "$url"
    echo "ok: $command"; sleep 1; exit;
fi

command="chrome"
if [ -x "$(command -v "$command")" ]; then
    $command --proxy-server="socks5://127.0.0.1:9050" "$url"
    echo "ok: $command"; sleep 1; exit;
fi

# xdg-open "$url"
