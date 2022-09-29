#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT

install_system pcmanfm

config_source1="${work_dir}tasksdata/home:i:.config:pcmanfm:default:pcmanfm.conf"
config_source2="${work_dir}tasksdata/home:i:.config:libfm:libfm.conf"

config_target1='/home/i/.config/pcmanfm/default/pcmanfm.conf'
config_target2='/home/i/.config/libfm/libfm.conf'

rm -v "$config_target1"
rm -v "$config_target2"
create_dir_for_file "$config_target1"
create_dir_for_file "$config_target2"
cp -v "$config_source1" "$config_target1"
cp -v "$config_source2" "$config_target2"
# ln --verbose  "$config_target1" "$config_target2"
chown --verbose --changes  i:i "$config_target1";
chmod --verbose 0644 "$config_target1";
chown --verbose --changes  i:i "$config_target2";
chmod --verbose 0644 "$config_target2";


exit
