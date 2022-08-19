#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#wget -qO - t.ly/mHc_ | bash
set -x;
echo "Borodin-Atamanov"
sleep 0.3;
temp_dir_for_bin="temp_dir_for_bin-$(date "+%F-%H-%M-%S")"; \
mkdir -p "${temp_dir_for_bin}";
git clone --verbose --progress --depth 1 https://github.com/Borodin-Atamanov/dzible.git "${temp_dir_for_bin}";

