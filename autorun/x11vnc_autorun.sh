#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun x11vnc

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzintara.x11vnc';   #for slog systemd logs

#start plus root script
whoami="$(whoami)"
slog "<5>start x11vnc $(show_var EUID) $(show_var whoami)"

declare_and_export fullpath_bash "$( get_command_fullpath bash )";
declare_and_export fullpath_terminal_gui_app "$( get_command_fullpath rxvt )";
declare_and_export fullpath_nohup "$( get_command_fullpath nohup )";

#HOME
#"${preffix}_${computer}_vnc_password"

#vnc_password=$( get_var "${root_vault_preffix}vnc_password" )
#show_var vnc_password
#x11vnc -storepasswd "$vnc_password" /root/.vnc/passwd
#x11vnc -storepasswd "$vnc_password" '/root/.vnc/passwd'

# source /home/i/bin/dzintara/autorun/load_variables.sh;
x11vnc_start_command="x11vnc -6 -reopen -scale 0.5 -shared -forever -loop7777 -users i -capslock -clear_all -fixscreen V=111,C=121,X=137 -ping 2 -passwdfile /root/.vnc/passwd ";
x11vnc_start_command="x11vnc -6 -reopen -scale 0.75 -shared -forever -loop7777 -capslock -clear_all -fixscreen V=111,C=121,X=137 -ping 2 -ncache_cr -ncache 10  -rfbauth /root/.vnc/passwd ";
x11vnc_start_command="x11vnc -6 -reopen -scale 0.75 -shared -forever -loop7777 -capslock -clear_all -fixscreen V=111,C=121,X=137 -ping 2 -ncache_cr -ncache 10  -rfbauth /root/.vnc/passwd >/dev/null ";
#/root/.vnc/passwd
#-usepw If  no  other password method was supplied on the command line, first look for ~/.vnc/passwd and if found use it with -rfbauth; next, look for ~/.vnc/passwdfile and use it with -passwdfile; otherwise, prompt the user for a password to create ~/.vnc/passwd and use it with the -rfbauth option.  If none of these succeed x11vnc exits immediately.
#-viewpasswd string Supply a 2nd password for view-only logins.  The -passwd (full-access) password must also be supplied.
#eval_this='su --login i --shell="${fullpath_bash}" --command="source /home/i/bin/dzintara/autorun/load_variables.sh;  rxvt -e /home/i/bin/dzintara/autorun/user_autorun_gui.sh & " ';
eval_this="su --login root --shell='${fullpath_bash}' --command='${source_load_variables};  ${fullpath_nohup} ${x11vnc_start_command} & ' ";
slog "<7>eval this  '${eval_this}'"
eval "${eval_this}";

