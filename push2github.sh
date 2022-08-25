#!/usr/bin/bash
set -x;
./encrypt_all_vaults.sh
sleep 3;
time ( \
echo git pull --verbose;
git whatchanged | head --lines=42
sleep 3;
git add --verbose --all;
sleep 3;
git commit --allow-empty-message --message=$(date "+%F_%H-%M-%S") --verbose; git push --verbose;
)
