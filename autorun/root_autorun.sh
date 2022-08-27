#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode

#This script also calls 3 another script:
#1. root script after gui started
#2. user i script before gui
#3. user i script after gui started

#load variables
source "/home/i/bin/dzible/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzible/"

#declare_and_export work_dir
#work_dir="/home/i/bin/dzible/autorun";

#access control disabled, clients can connect from any host
#xhost +

#for ((i=42;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;

#read some logs:
#journalctl -b -u dzible


for ((i=133;i>=0;i--));
do
echo -ne "\b\b\b\b\b\b\b\b $i  ";
xprop_data=$( export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xprop -root );
echo "xprop length is ${#xprop_data}";
sleep 0.5;
done;

#TODO start root script
{ ymdhms; echo " start root console script"; } | tee --append "${work_dir}autorun/logs.root";
#TODO start user i script
{ ymdhms; echo " start user i console script"; } | tee --append "${work_dir}autorun/logs.root";

#wait untill x server starts (or if waiting time is over)
{ ymdhms; echo " wait for Xorg..."; } | tee --append "${work_dir}autorun/logs.root";

wait_for 133 'is_process_running Xorg'
#TODO check for Xorg with xprop -root

#{ymdhms; echo " Xorg is here!";} | tee --append "${work_dir}autorun/logs.root";

#TODO start root GUI script
{ ymdhms; echo " start root GUI script"; } | tee --append "${work_dir}autorun/logs.root";
#TODO start user i GUI script
{ ymdhms; echo " start user i GUI script"; } | tee --append "${work_dir}autorun/logs.root";

#TODO create lock file?
#В цикле вызываем скрипт от пользователя. До тех пор, пока lock-файл не исчезнет.
#
# Запустили скрипт.
#
#
#

sleep 11;

{ ymdhms; echo " Xorg waiting completed"; } | tee --append "${work_dir}autorun/logs.root";

#TODO wait for lock file, generated after success execution if the script
#TODO delete lock file if it is too old
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
su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun_gui.sh;' " | tee --append "${work_dir}autorun/logs.root";

#su --login i --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; xset led 3; /bin/bash -l -v -c xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";

#Работает:
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; chromium-browser www.youtube.com; ";
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; time xterm -maximized -e 'wget -qO - clck.ru/uRPBG | bash';
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xprop -root
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; chromium-browser --no-sandbox www.youtube.com;

#TODO run user_autorun.sh script in graphical environment on target computer


