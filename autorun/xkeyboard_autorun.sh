#!/usr/bin/bash
#Post installation script for debian-like systems
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun x11vnc

declare -g -x work_dir="/home/i/bin/dzible/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzible/"

#load variables
#source "/home/i/bin/dzible/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzible.xkeyboard';   #for slog systemd logs

#start plus root script
whoami="$(whoami)"
slog "<7>start X11 input settings update service"

numlockx_fp="$( get_command_fullpath numlockx )";
xset_fp="$( get_command_fullpath xset )";
setxkbmap_fp="$( get_command_fullpath setxkbmap )";

#echo -e "remove Lock = Caps_Lock\nremove Control = Control_L\nkeysym Control_L = Caps_Lock\nkeysym Caps_Lock = Control_L\nadd Lock = Caps_Lock\nadd Control = Control_L\n" | xmodmap -v -

while : ; do :
    timeout --kill-after=$timeout_1 $timeout_2 $numlockx_fp on
    timeout --kill-after=$timeout_1 $timeout_2 $xset_fp led 3;
    #timeout --kill-after=$timeout_1 $timeout_2 $setxkbmap_fp -layout "us,ru"
    # https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee
    #lv3:enter_switch
    timeout --kill-after=$timeout_1 $timeout_2 $setxkbmap_fp -layout "us,ru" -option "" -option "grp:shift_caps_switch" -option "grp_led:scroll" -option "grp_led:caps" -option "compose:sclk"
    #TODO turn off caps lock (if it accidentally turned on)
    #
    sleep $timeout_2
    #timeout --kill-after=$timeout_1 $timeout_2 $xset_fp -led 3;
    #sleep "1.$RANDOM"
    #sleep $timeout_1
done;

