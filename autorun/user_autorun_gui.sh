#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun on target system in user mode after GUI starts. It will never starts in pure console computers, f.e. servers

# export all XDG-variables to use in other scripts
# set -a  # or: set -o allexport
# . ./environment
# set +a

x_variables="$( printenv | grep -F 'X' )"
set -o allexport
eval $x_variables;
set +a
x2_variables="$( export | grep -F 'X' )"

source "/home/i/bin/dzintara/autorun/load_variables.sh"
declare -x -g service_name='dzintara.user_autorun_gui';   #for slog systemd logs

start_log

# export XDG-variables to file, and other scripts will use it (some of XDG variables needed to run gui apps)
${ipc_dir_xdg_var_file}
save_var_to_file "${ipc_dir_xdg_var_file}" x2_variables

#access control disabled, clients can connect from any host
# xhost +

#if you need sudo su as root, you can do the following
#echo secret_root_password | sudo -S echo -n 2>/dev/random 1>/dev/random

slog "<5>start $0"

slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"

xset led 3;
/usr/bin/numlockx on
#nohup xbindkeys &

#nohup telegram-desktop &

XDG_SESSION_TYPE=x11
run_counts="1"
run_background_command_with_logs gtk-launch dzintara-plank_start
echo -e "\n\n"

random_wait

#run_task show_script_subversion
#run_task add_screen_resolution_with_cvt_xrandr

#cvt_xrandr 1280 1024 60

#cvt_xrandr 1920 1080 60
#cvt_xrandr 1360 768 60

# autorandr --debug --change
# autorandr --debug --load itworks
# autorandr --debug horizontal

#read

slog "<5>finish $0"
