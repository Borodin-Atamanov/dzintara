#!/usr/bin/bash
#script generate  "vault" from user input

#load all functions and variables
old_dir=$(pwd)
cd ..
source index.sh fun
cd "$old_dir"

#uses vars:
#"${root_vault_file}"
#"${root_vault_password_file}"

root_vault_file='/tmp/root_vault_file'
root_vault_password_file='/tmp/root_vault_password_file'

generate_and_save_root_vault

#save_root_vault

