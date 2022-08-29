#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode

#This script also calls 3 another script;
# 0. load_variables.sh - sourced to all scripts, it includes important variables, what is needed to X11 applications
# 1. root script after gui started
# 2. user i script before gui
# 3. user i script after gui started

# root_autorun.sh
#    ├── load_variables.sh
#    ├── user_autorun.sh
#    ├── root_autorun_gui.sh
#    └── user_autorun_gui.sh

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
#source "/home/i/bin/dzible/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzible.root_autorun';   #for slog systemd logs

#path to scripts, what we will start
user_autorun="${work_dir_autorun}user_autorun.sh"
root_autorun_gui="${work_dir_autorun}root_autorun_gui.sh"
user_autorun_gui="${work_dir_autorun}user_autorun_gui.sh"

declare_and_export fullpath_bash "$( get_command_fullpath bash )";
declare_and_export fullpath_terminal_gui_app "$( get_command_fullpath rxvt )";
declare_and_export fullpath_nohup "$( get_command_fullpath nohup )";

#start root script (we are in this script already, and it is successfully running now)
slog "<7>start root console script"
slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"

#start user i script
slog "<7>start user console script  ${user_autorun}";
eval_this="su --login i --shell='${fullpath_bash}' --command='${source_load_variables}; ${fullpath_nohup} ${user_autorun} > ${user_autorun}.log & ' ";
slog "<7>eval this '${eval_this}'"
eval "${eval_this}";

#wait untill x server starts (or if waiting time is over)
slog "<7>wait for Xorg (exit code == 0, wait untill x server starts (or if waiting time is over))";

wait_for_exit_code 0 777 "timeout 42 xprop -root ";

slog "<7>Xorg loaded";

slog "<7>sleep some";
run_task sleep 17

#start root GUI script
slog "<7>start root GUI script ${root_autorun_gui}";
#( $source_load_variables; xterm -e ${root_autorun_gui} ) &
eval_this="${fullpath_nohup} ${fullpath_bash} --login -c '( ${source_load_variables}; ${fullpath_terminal_gui_app} -e ${root_autorun_gui} > ${root_autorun_gui}.log ) &'  ";
slog "<7>eval this '${eval_this}'"
eval "${eval_this}";

#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun_gui.sh;' "; &
#slog "<7>$(export)";

#slog "<7>sleep some";
#( export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xmessage "sleep 2 $(ymdhms)"; ) &
#run_task sleep 17
slog "<7>sleep 2";
sleep 2

#start user i GUI script
slog "<7>start user GUI script ${user_autorun_gui}";
#eval_this='su --login i --shell="${fullpath_bash}" --command="source /home/i/bin/dzible/autorun/load_variables.sh;  rxvt -e /home/i/bin/dzible/autorun/user_autorun_gui.sh & " ';
eval_this="su --login i --shell='${fullpath_bash}' --command='${source_load_variables};  ${fullpath_nohup} ${fullpath_terminal_gui_app} -e ${user_autorun_gui}  > ${user_autorun_gui}.log & ' ";
slog "<7>eval this  '${eval_this}'"
eval "${eval_this}";

for ((x=42;x>=0;x--)); do
    #echo -ne "\b\b\b\b\b\b\b\b $x  ";
    slog "<7>$(show_var x) $whoami $EUID $0"
    #countdown 7 1
    sleep 13.42;
done;

#( $source_load_variables; su --login i --shell="/bin/bash"  --command="$source_load_variables; xterm -e '${user_autorun_gui}' " ) &
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
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; /home/i/bin/dzible/autorun/user_autorun_gui.sh
#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun_gui.sh;' ";

#Работает;
#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun_gui.sh;' " &
#( export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xmessage "sleep 1 $(ymdhms)"; ) &
#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzible/autorun/load_variables.sh; xterm -e '/home/i/bin/dzible/autorun/user_autorun_gui.sh;' " | tee --append "${work_dir_autorun}logs.root";
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; chromium-browser www.youtube.com; ";
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; time xterm -maximized -e 'wget -qO - clck.ru/uRPBG | bash';
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xprop -root
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; chromium-browser --no-sandbox www.youtube.com;

#source /home/i/bin/dzible/autorun/load_variables.sh;  rxvt -e /home/i/bin/dzible/autorun/user_autorun_gui.sh;

slog "<7>end";
