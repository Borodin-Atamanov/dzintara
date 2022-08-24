#!/usr/bin/bash
set -x;
./encrypt_all_vaults.sh
time (echo git pull --verbose; git add --verbose --all; git commit --allow-empty-message --message=$(date "+%F_%H-%M-%S") --verbose; git push --verbose;)
