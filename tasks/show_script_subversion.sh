#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#https://telegram.org/dl/desktop/linux

temp_script_subversion=$( cat "${work_dir}index.sh" | grep '^script_subversion' );
echo "$temp_script_subversion";
temp_script_subversion=$( eval "${temp_script_subversion}" );
echo "●●●  $temp_script_subversion ●●●";
for ((i=142;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 0.12; done;
sleep 4.42;
