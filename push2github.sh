#!/usr/bin/bash
sleep_time='0.22';
set -x;
./encrypt_all_vaults.sh
sleep $sleep_time;
time ( \
git diff
sleep $sleep_time;
echo git pull --verbose;
git whatchanged | head --lines=42
sleep $sleep_time;
git add --verbose --all;
sleep $sleep_time;
git commit --allow-empty-message --message=$(date "+%F_%H-%M-%S") --verbose; git push --verbose;
)
