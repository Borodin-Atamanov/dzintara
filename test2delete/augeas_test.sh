#!/usr/bin/bash
#set  -x
export AUGEAS_ROOT=/dev/shm/augeas-sandbox
mkdir $AUGEAS_ROOT
sudo cp -prv /etc $AUGEAS_ROOT
#sudo chown -R $(id -nu):$(id -ng) $AUGEAS_ROOT
sudo chown -v -R i:i $AUGEAS_ROOT
augtool -b

#export AUGEAS_ROOT=/dev/shm/augeas-sandbox; augtool --new --root="/dev/shm/augeas-sandbox" --backup --include=DIR  --load-file=FILE  --timing --echo
augtool --timing --echo --new --backup  --root="/dev/shm/augeas-sandbox" --file "augeas_commands.txt"

--file=FILE Read commands from FILE.

