#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode after GUI starts. If no GUI in computer - this script will never run

#load variables
source "/home/i/bin/dzible/autorun/load_variables.sh"
declare -x -g service_name='dzible.root_autorun_gui';   #for slog systemd logs

slog "<5>start"
slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"
#countdown 31337 0.1
#sleep 37

( /home/i/bin/dzible/autorun/x11vnc_autorun.sh )

random_wait

slog "<5>finish $0"

#
# #( xmessage -buttons ok,no,wow -default wow -timeout 4 -print -nearmouse "hello" ); echo $?
# #xconsole
# #xmessage "some message here'
#
# #declare_and_export work_dir
# #work_dir="/home/i/bin/dzible/autorun";
#
# #access control disabled, clients can connect from any host
# #xhost +
#
# #for ((i=42;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;
#
# #wait untill x server starts (or if waiting time is over)
# echo "wait for Xorg" | tee --append "${work_dir}autorun/logs.root";
# date | tee --append "${work_dir}autorun/logs.root";
#
# #wait_for 133 'is_process_running Xorg'
#
# wait_for 333 ' is_process_return_this_code 0 " timeout 42 xprop -root "  '
# #if is_process_return_this_code 0 'xprop -root ' ; then echo "Xorg running"; else echo "Xorg NOT running"; fi;
#
# echo "Xorg loaded" | tee --append "${work_dir}autorun/logs.root";
# date | tee --append "${work_dir}autorun/logs.root";
#
# #TODO create lock file?
# #В цикле вызываем скрипт от пользователя. До тех пор, пока lock-файл не исчезнет.
# #
# # Запустили скрипт.
# #
# #
#
# #sleep 11;
#
# #echo "waiting completed" | tee --append "${work_dir}autorun/logs.root";
# date | tee --append "${work_dir}autorun/logs.root";
#
# #TODO wait for lock file, generated after success execution if the script
# #TODO delete lock file if it is too old
#
# #su i --preserve-environment --pty --command "source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60; "
# #sudo --user=i --shell  "source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60; "
# #su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60;"
# #autorandr --debug --load itworks
# #su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; autorandr --debug --load itworks" #dont work for me
#
# #su i --preserve-environment --pty --command "source /home/i/bin/dzible/autorun/load_variables.sh; time chromium-browser; ";
# #su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60;";
#
# #su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; time chromium-browser; ";
# #su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; time stterm -T 'Borodin-Atamanov system update' -e command '/bin/bash -c \'for ((i=42;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;\'' ";
# #su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; stterm -e /bin/bash -c source /home/i/bin/dzible/autorun/load_variables.sh; sleep 35; ";
# #su --login i --pty --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'ls; read; sleep 35;' ";
# su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun.sh;' ";
#
# #su --login i --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";
# #su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; xset led 3; /bin/bash -l -v -c xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";
#
# #Работает:
# #su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; chromium-browser; ";
#
# #TODO run user_autorun.sh script in graphical environment on target computer
#
#
