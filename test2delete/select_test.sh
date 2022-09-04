#!/usr/bin/bash

work_dir='/home/i/github/dzible/';
source "${work_dir}tasks/1.sh"

set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;


#wait_for 13 'ps -e | grep -c Xorg'

#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
            echo "you chose choice 1"
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

