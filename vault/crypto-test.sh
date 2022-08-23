#!/usr/bin/bash


data=$(cat $0);

encrypt_aes '1' "${data}" > 1.crypt.sh

cat 1.crypt.sh

decrypt_aes '1' "$(cat 1.crypt.sh)"
