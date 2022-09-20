#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in root mode

#This script also calls another scripts:

# 0. load_variables.sh - sourced to all scripts, it includes important variables, what is needed to X11 applications
# root_autorun_final.sh
# 1. root script after gui started
# 2. user i script before gui
# 3. user i script after gui started

# root_autorun.sh
#    ├── load_variables.sh
#    ├── root_autorun_plus.sh
#    ├── user_autorun.sh
#    ├── root_autorun_gui.sh
#    └── user_autorun_gui.sh

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzintara.root_autorun';   #for slog systemd logs

#path to scripts, what we will start
user_autorun="${work_dir_autorun}user_autorun.sh"
root_autorun_plus="${work_dir_autorun}root_autorun_plus.sh"
root_autorun_gui="${work_dir_autorun}root_autorun_gui.sh"
user_autorun_gui="${work_dir_autorun}user_autorun_gui.sh"

declare_and_export fullpath_bash "$( get_command_fullpath bash )";
bash="$( get_command_fullpath bash )";
declare_and_export fullpath_terminal_gui_app "$( get_command_fullpath rxvt )";
declare_and_export fullpath_nohup "$( get_command_fullpath nohup )";

#start plus root script
slog "<5>start root console script. It will start other scripts."
slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"

slog "<7>start root console script plus  ${root_autorun_plus}";
eval_this="su --login root --shell='${fullpath_bash}' --command='${source_load_variables}; ${fullpath_nohup} ${root_autorun_plus} & ' ";
slog "<7>eval this '${eval_this}'"
eval "${eval_this}";

sleep $timeout_0;

#start user i script
slog "<7>start user console script  ${user_autorun}";
eval_this="su --login i --shell='${fullpath_bash}' --command='${source_load_variables}; ${fullpath_nohup} ${user_autorun} & ' ";
slog "<7>eval this '${eval_this}'"
eval "${eval_this}";

#wait untill x server starts (or if waiting time is over)
slog "<7>wait for Xorg (exit code == 0, wait untill x server starts (or if waiting time is over))";
wait_for_exit_code 0 777 "timeout 42 xprop -root ";

slog "<7>Xorg loaded";

#slog "<7>sleep some";
#run_task sleep 13
sleep $timeout_1
sleep $timeout_1

# #start root GUI script
# #( $source_load_variables; xterm -e ${root_autorun_gui} ) &
# eval_this="${fullpath_bash} --login -c '( ${source_load_variables}; ${fullpath_nohup} ${fullpath_terminal_gui_app} -e ${root_autorun_gui} ) & '  ";
# slog "<7>eval this '${eval_this}'"
# eval "${eval_this}";

slog "<7>start root GUI script ${root_autorun_gui}";
#eval_this='su --login i --shell="${fullpath_bash}" --command="source /home/i/bin/dzintara/autorun/load_variables.sh;  rxvt -e /home/i/bin/dzintara/autorun/user_autorun_gui.sh & " ';
eval_this="su --login root --shell='${fullpath_bash}' --command='${source_load_variables};  ${fullpath_nohup} ${fullpath_terminal_gui_app} -e ${root_autorun_gui} & ' ";
slog "<7>eval this  '${eval_this}'"
eval "${eval_this}";

#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzintara/autorun/load_variables.sh; xterm -e '/home/i/bin/dzintara/autorun/user_autorun_gui.sh;' "; &
#slog "<7>$(export)";

#slog "<7>sleep some";
#( export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xmessage "sleep 2 $(ymdhms)"; ) &
#run_task sleep 17
#slog "<7>sleep 2";
sleep 2.5;

#start user i GUI script
slog "<7>start user GUI script ${user_autorun_gui}";
#eval_this='su --login i --shell="${fullpath_bash}" --command="source /home/i/bin/dzintara/autorun/load_variables.sh;  rxvt -e /home/i/bin/dzintara/autorun/user_autorun_gui.sh & " ';
eval_this="su --login i --shell='${fullpath_bash}' --command='${source_load_variables};  ${fullpath_nohup} ${fullpath_terminal_gui_app} -e ${user_autorun_gui} & ' ";
slog "<7>eval this  '${eval_this}'"
eval "${eval_this}";

slog "<5>finish $0"

#( $source_load_variables; su --login i --shell="/bin/bash"  --command="$source_load_variables; xterm -e '${user_autorun_gui}' " ) &
#( $source_load_variables; ${user_autorun_gui} ) &
#su i --preserve-environment --pty --command "source /home/i/bin/dzintara/autorun/load_variables.sh; cvt_xrandr 1280 1024 60; "
#sudo --user=i --shell  "source /home/i/bin/dzintara/autorun/load_variables.sh; cvt_xrandr 1280 1024 60; "
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; source /home/i/bin/dzintara/autorun/load_variables.sh; cvt_xrandr 1280 1024 60;"
#autorandr --debug --load itworks
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; autorandr --debug --load itworks" #dont work for me
#su i --preserve-environment --pty --command "source /home/i/bin/dzintara/autorun/load_variables.sh; time chromium-browser; ";
#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzintara/autorun/load_variables.sh; cvt_xrandr 1280 1024 60;";
#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzintara/autorun/load_variables.sh; time chromium-browser; ";
#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzintara/autorun/load_variables.sh; time stterm -T 'Borodin-Atamanov system update' -e command '/bin/bash -c \'for ((i=42;i>=0;i--)); do echo -ne "\b\b\b\b\b\b\b\b $i  "; sleep 1.42; done;\'' ";
#su --login i --pty --shell="/bin/bash" --command="source /home/i/bin/dzintara/autorun/load_variables.sh; stterm -e /bin/bash -c source /home/i/bin/dzintara/autorun/load_variables.sh; sleep 35; ";
#su --login i --pty --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'ls; read; sleep 35;' ";
#su --login i --shell="/bin/bash"  --command="export DISPLAY=:0; xterm -e 'xset led 3; /home/i/bin/dzintara/autorun/user_autorun.sh; read; read; read; ' ";
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; xset led 3; /bin/bash -l -v -c xterm -e 'xset led 3; /home/i/bin/dzintara/autorun/user_autorun.sh; read; read; read; ' ";
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xmessage "Hello X!"
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; /home/i/bin/dzintara/autorun/user_autorun_gui.sh
#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzintara/autorun/load_variables.sh; xterm -e '/home/i/bin/dzintara/autorun/user_autorun_gui.sh;' ";

#Works in some situations:
#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzintara/autorun/load_variables.sh; xterm -e '/home/i/bin/dzintara/autorun/user_autorun_gui.sh;' " &
#( export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xmessage "sleep 1 $(ymdhms)"; ) &
#su --login i --shell="/bin/bash"  --command="source /home/i/bin/dzintara/autorun/load_variables.sh; xterm -e '/home/i/bin/dzintara/autorun/user_autorun_gui.sh;' " | tee --append "${work_dir_autorun}logs.root";
#su --login i --pty --shell="/bin/bash" --command="export DISPLAY=:0; chromium-browser www.youtube.com; ";
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; time xterm -maximized -e 'wget -qO - clck.ru/uRPBG | bash';
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; xprop -root
#export DISPLAY=:0; export XAUTHORITY='/home/i/.Xauthority'; chromium-browser --no-sandbox www.youtube.com;

#source /home/i/bin/dzintara/autorun/load_variables.sh;  rxvt -e /home/i/bin/dzintara/autorun/user_autorun_gui.sh;
