#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script sends some telemetry data in background

work_dir='/home/i/github/dzible/'; source "${work_dir}tasks/1.sh"

#send_telemetry 'augeas_test.sh' 'hello world '

work_dir='/home/i/github/dzible/'; source "${work_dir}tasks/1.sh";
for ((i=5;i>0;i--)); do :;
newfilename="$(random_str 17)$(ymdhms).dat"
echo "$newfilename" > $newfilename
send_telemetry $newfilename $newfilename
nohup bash -c 'sleep 37; rm -v "$newfilename"; ' &
sleep 0.01;
done;
