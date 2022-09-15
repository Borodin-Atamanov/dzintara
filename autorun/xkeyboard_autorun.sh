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

declare -x -g service_name='dzintara.xkeyboard';   #for slog systemd logs

#start plus root script
whoami="$(whoami)"
slog "<7>start X11 input settings update service"

numlockx="$( get_command_fullpath numlockx )";
xset="$( get_command_fullpath xset )";
setxkbmap="$( get_command_fullpath setxkbmap )";
gxkb="$( get_command_fullpath gxkb )";
xneur="$( get_command_fullpath xneur )";
bash="$( get_command_fullpath bash )";

#echo -e "remove Lock = Caps_Lock\nremove Control = Control_L\nkeysym Control_L = Caps_Lock\nkeysym Caps_Lock = Control_L\nadd Lock = Caps_Lock\nadd Control = Control_L\n" | xmodmap -v -
#timeout --kill-after=$timeout_1 $timeout_2 $setxkbmap -layout "us,ru" -option "" -option "grp:shift_caps_switch" -option "grp_led:scroll" -option "grp_led:caps" -option "compose:sclk"
nohup $bash -c 'while : ; do source /home/i/bin/dzintara/autorun/load_variables.sh nocd; timeout --kill-after='$timeout_2' '$timeout_4' '$gxkb'; sleep '$timeout_2'; done; ' &
sleep $timeout_1
#nohup $bash -c 'while : ; do source /home/i/bin/dzintara/autorun/load_variables.sh nocd; timeout --kill-after='$timeout_2' '$timeout_4' '$xneur'; sleep '$timeout_2'; done; ' &

#while : ; do :
for ((i=7;i>=0;i--)); do
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

nohup $xneur &
