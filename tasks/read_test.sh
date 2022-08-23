#!/bin/bash
sleep 0.2;
tty_name=$(tty);
echo "$tty_name";
read -p "username:" user_var <  /dev/tty
echo "The username is: " $user_var
sleep 0.2;

