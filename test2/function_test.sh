#!/usr/bin/bash

work_dir='/home/i/github/dzible/';
source "${work_dir}tasks/1.sh"

set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;


#wait_for 13 'ps -e | grep -c Xorg'

#wait_for 13 'is_process_running Xorg'

if is_process_return_this_code 15 'exit 15' ; then echo "equal"; else echo "NOT equal"; fi;
echo -e "\n\n\n";
if is_process_return_this_code 127 'timeout 1 yes " Borodin-Atamanov.ru" ' ; then echo "equal"; else echo "NOT equal"; fi;
echo -e "\n\n\n";

if is_process_return_this_code 0 'xprop -root ' ; then echo "equal"; else echo "NOT equal"; fi;
echo -e "\n\n\n";

#sleep 1;
show_var returned_text
echo -e "\n\n\n";

#wait_for 333 ' is_process_return_this_code 0 " timeout 42 xprop -root "  '

wait_for_exit_code 0 777 "timeout 42 xprop -root ";
