#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun

# TODO start it from gui_root_autorun, not from systemd service

exit

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh nocd";
$source_load_variables;

declare -x -g service_name='dzintara.xkeyboard';   #for slog systemd logs

#start plus root script
whoami="$(whoami)"
slog "<7>start X11 input settings update service"

bash="$( get_command_fullpath bash )";
numlockx="$( get_command_fullpath numlockx )";
xset="$( get_command_fullpath xset )";
setxkbmap="$( get_command_fullpath setxkbmap )";
gxkb="$( get_command_fullpath gxkb )";
#xneur="$( get_command_fullpath xneur )";
nohup="$( get_command_fullpath nohup )";
compton="$( get_command_fullpath compton )";
#xcompmgr="$( get_command_fullpath xcompmgr )";

#echo -e "remove Lock = Caps_Lock\nremove Control = Control_L\nkeysym Control_L = Caps_Lock\nkeysym Caps_Lock = Control_L\nadd Lock = Caps_Lock\nadd Control = Control_L\n" | xmodmap -v -
#timeout --kill-after=$timeout_1 $timeout_2 $setxkbmap -layout "us,ru" -option "" -option "grp:shift_caps_switch" -option "grp_led:scroll" -option "grp_led:caps" -option "compose:sclk"

# slow, but without tearing:
#$compton --backend glx --paint-on-overlay --vsync opengl-swc --shadow-radius=3 --shadow-opacity=1 --shadow-offset-x=-15 --shadow-offset-y=-15 --fade-delta=89 --menu-opacity=97 --no-dock-shadow --inactive-opacity=0.97 --frame-opacity=0.87 --daemon --shadow-ignore-shaped --blur-background --blur-background-fixed --blur-kern '7,7,0.000003,0.000102,0.000849,0.001723,0.000849,0.000102,0.000003,0.000102,0.003494,0.029143,0.059106,0.029143,0.003494,0.000102,0.000849,0.029143,0.243117,0.493069,0.243117,0.029143,0.000849,0.001723,0.059106,0.493069,0.493069,0.059106,0.001723,0.000849,0.029143,0.243117,0.493069,0.243117,0.029143,0.000849,0.000102,0.003494,0.029143,0.059106,0.029143,0.003494,0.000102,0.000003,0.000102,0.000849,0.001723,0.000849,0.000102,0.000003'
# minimum is :
# compton --backend glx --vsync opengl-swc
#$compton --backend glx --paint-on-overlay --vsync opengl-swc --shadow-radius=5 --menu-opacity=0.87 --no-dock-shadow --inactive-opacity=0.87 --frame-opacity=0.84 --daemon


$compton --daemon --config $compton_config_file --backend glx --paint-on-overlay --vsync opengl-swc --shadow-radius=5 --menu-opacity=0.87 --no-dock-shadow --inactive-opacity=0.87 --frame-opacity=0.84 &
# fallback mode (if something wrong with daemon
$nohup $bash -c "${source_load_variables}; while : ; do $compton --config $compton_config_file --backend glx --paint-on-overlay --vsync opengl-swc --shadow-radius=5 --menu-opacity=0.87 --no-dock-shadow --inactive-opacity=0.87 --frame-opacity=0.84; sleep $timeout_2; done; " &

$nohup $bash -c "${source_load_variables}; while : ; do sleep $timeout_1; timeout --kill-after=$timeout_2 $timeout_5 $gxkb; done; " &
#nohup $bash -c 'while : ; do source /home/i/bin/dzintara/autorun/load_variables.sh nocd; timeout --kill-after='$timeout_2' '$timeout_4' '$xneur'; sleep '$timeout_2'; done; ' &

#$nohup su --login i --shell="${bash}" --command="${source_load_variables}; while : ; do sleep $timeout_1; timeout --kill-after=$timeout_2 $timeout_5 $xcompmgr -c; done; " &

$nohup $bash -c "${source_load_variables}; while : ; do sleep $timeout_1; ${xselection_archivist_script_file}; done; " &

sleep $timeout_1
# nohup="$( get_command_fullpath nohup )"; \
# source_load_variables="source '"$load_variables_file"'"; \
# bash="$( get_command_fullpath bash )"; \
# su --login i --shell="${bash}" --command="${source_load_variables}; xneur;"



#while : ; do :
for ((i=5;i>=0;i--)); do
    #timeout --kill-after=$timeout_1 $timeout_2 $numlockx on
    $numlockx on
    $xset led 3;
    nohup $setxkbmap -layout "us,ru" -option "" -option "grp:shift_caps_switch" -option "grp_led:scroll" -option "grp_led:caps" -option "compose:sclk" &
    #nohup gxkb &
    #timeout --kill-after=$timeout_1 $timeout_2 $xset led 3;
    #timeout --kill-after=$timeout_1 $timeout_2 $setxkbmap -layout "us,ru"
    # https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee
    #lv3:enter_switch
    #TODO turn off caps lock (if it accidentally turned on)
    #
    sleep $timeout_2
    #timeout --kill-after=$timeout_1 $timeout_2 $xset -led 3;
    #sleep "1.$RANDOM"
    #sleep $timeout_1
done;

