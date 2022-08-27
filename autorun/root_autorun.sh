#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode

#load variables
source "/home/i/bin/dzible/autorun/load_variables.sh"
declare_and_export work_dir "/home/i/bin/dzible/"

#declare_and_export work_dir
#work_dir="/home/i/bin/dzible/autorun";

#access control disabled, clients can connect from any host
#xhost +

#for ((i=42;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;

#wait untill x server starts (or if waiting time is over)
echo "wait for X" >> "${work_dir}autorun/logs.root";
date >> "${work_dir}autorun/logs.root";

wait_for 133 'is_process_running Xorg'

echo "X is here!" >> "${work_dir}autorun/logs.root";
date >> "${work_dir}autorun/logs.root";

sleep 3;

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
su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun.sh;' ";

#su --login i --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; xset led 3; /bin/bash -l -v -c xterm -e 'xset led 3; /home/i/bin/dzible/autorun/user_autorun.sh; read; read; read; ' ";

#Работает:
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; chromium-browser; ";



#TODO run user_autorun.sh script in graphical environment on target computer


