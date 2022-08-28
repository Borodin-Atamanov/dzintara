#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode

#This script also calls 3 another script:
#1. root script after gui started
#2. user i script before gui
#3. user i script after gui started

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
#source "/home/i/bin/dzible/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

#path to scripts, what we will start
root_autorun_gui="${work_dir_autorun}root_autorun_gui.sh"
user_autorun="${work_dir_autorun}user_autorun.sh"
user_autorun_gui="${work_dir_autorun}user_autorun_gui.sh"

#declare_and_export work_dir
#work_dir="/home/i/bin/dzible/autorun";

#access control disabled, clients can connect from any host
#xhost +

#for ((i=42;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;

#read some logs:
#journalctl -b -u dzible

# for ((i=133;i>=0;i--));
# do
#     #echo -ne "\b\b\b\b\b\b\b\b $i  ";
#     xprop_data=$( export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xprop -root );
#     #
#     export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority';
#     xprop_data=$( xprop -root );
#     #when 'xprop -root' returns 0 - Xorg works
#     echo "$i [$?] xprop length is ${#xprop_data}";
#     sleep 0.5;
# done;

#start root script (we are in this script already, and it is successfully running now)
{ ymdhms; echo " start root console script"; } | tee --append "${work_dir_autorun}logs.root";

#start user i script
{ ymdhms; echo " start user i console script"; } | tee --append "${work_dir_autorun}logs.root";
( $source_load_variables; ${user_autorun} ) &

#wait untill x server starts (or if waiting time is over)
{ ymdhms; echo " wait for Xorg (exit code == 0)"; } | tee --append "${work_dir_autorun}logs.root";

wait_for_exit_code 0 777 "timeout 42 xprop -root ";
{ ymdhms; echo " Xorg loaded!"; } | tee --append "${work_dir_autorun}logs.root";

#TODO start root GUI script
{ ymdhms; echo " start root GUI script"; } | tee --append "${work_dir_autorun}logs.root";
su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun_gui.sh;' ";
( $source_load_variables; su --login i --shell="/bin/bash"  --command="$source_load_variables; nohup xterm -e '${root_autorun_gui}' " ) &

sleep 3.5

#TODO start user i GUI script
{ ymdhms; echo " start user i GUI script"; } | tee --append "${work_dir_autorun}logs.root";
( $source_load_variables; su --login i --shell="/bin/bash"  --command="$source_load_variables; nohup xterm -e '${user_autorun_gui}' " ) &
#( $source_load_variables; ${user_autorun_gui} ) &


#su i --preserve-environment --pty --command "source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60; "
#sudo --user=i --shell  "source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60; "
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60;"
#autorandr --debug --load itworks
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; autorandr --debug --load itworks" #dont work for me

#su i --preserve-environment --pty --command "source /home/i/bin/dzible/autorun/load_variables.sh; time chromium-browser; ";
#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; cvt_xrandr 1280 1024 60;";

#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; time chromium-browser; ";
#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; time stterm -T 'Borodin-Atamanov system update' -e command '/bin/bash -c \'for ((i=42;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;\'' ";
#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzible/autorun/load_variables.sh; stterm -e /bin/bash -c source /home/i/bin/dzible/autorun/load_variables.sh; sleep 35; ";
#su --login i --pty --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'ls; read; sleep 35;' ";

#su --login i --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; xset led 3; /bin/bash -l -v -c xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xmessage "Hello X!"


#Работает:
#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun_gui.sh;' " | tee --append "${work_dir_autorun}logs.root";
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; chromium-browser www.youtube.com; ";
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; time xterm -maximized -e 'wget -qO - clck.ru/uRPBG | bash';
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xprop -root
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; chromium-browser --no-sandbox www.youtube.com;

#TODO run user_autorun.sh script in graphical environment on target computer


