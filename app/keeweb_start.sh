#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
# script try to start keeweb application in some way


source "/home/i/bin/dzintara/autorun/load_variables.sh" nocd
#declare_and_export work_dir "/home/i/bin/dzintara/"

url="https://app.keeweb.info/?from=dzintara"

command="qutebrowser"
if [ -x "$(command -v "$command")" ]; then
    $command --target tab "$url"
    echo "ok: $command"; sleep 1; exit;
fi

command="falkon"
if [ -x "$(command -v "$command")" ]; then
    $command --current-tab "$url"
    echo "ok: $command"; sleep 1; exit;
fi

command="firefox"
if [ -x "$(command -v "$command")" ]; then
    $command "$url"
    echo "ok: $command"; sleep 1; exit;
fi

command="chromium-browser"
if [ -x "$(command -v "$command")" ]; then
    $command "$url"
    echo "ok: $command"; sleep 1; exit;
fi

command="google-chrome"
if [ -x "$(command -v "$command")" ]; then
    $command "$url"
    echo "ok: $command"; sleep 1; exit;
fi

xdg-open "$url"
