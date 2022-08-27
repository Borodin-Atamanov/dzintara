#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#https://telegram.org/dl/desktop/linux

temp_script_subversion=$( cat "${work_dir}index.sh" | grep '^script_subversion' );
echo "$temp_script_subversion";
temp_script_subversion=$( eval "${temp_script_subversion}" );
echo "★★★★★ $temp_script_subversion ★★★★★";
sleep 4.42;
