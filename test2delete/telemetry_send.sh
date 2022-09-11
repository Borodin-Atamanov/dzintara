#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script sends some telemetry data in background

work_dir='/home/i/github/dzintara/'; source "${work_dir}tasks/1.sh"

#send_telemetry 'augeas_test.sh' 'hello world '

#for ((i=5;i>0;i--)); do :;
#newfilename="$(random_str 17)$(ymdhms).dat"
#echo "$newfilename" > $newfilename

ymdhms=$(ymdhms)
text=$(cat <<_ENDOFFILE
Немного текста ymdhms 1
2
3
_ENDOFFILE
)
temp_file="$ymdhms"
echo -n "$text" > "$temp_file"



telemetry_send "$(realpath $temp_file)" "$text"
sleep 3;
rm -v "$temp_file"
#nohup bash -c 'sleep 37; rm -v "$newfilename"; ' &
sleep 0.01;
#done;
