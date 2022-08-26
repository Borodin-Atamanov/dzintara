#!/usr/bin/bash
sleep_time='0.42';
set -x;
./encrypt_all_vaults.sh
source index.sh fun
sleep $sleep_time;
time ( \
    git diff | head --lines=42
    sleep $sleep_time;
    echo git pull --verbose;
    git whatchanged | head --lines=42

    #delete script_subversion from index.sh
    cat index.sh | grep -v '^[script_subversion]' > index_wo_script_subversion.sh
    cat index.sh > index_wo_script_subversion.sh
    script_subversion="$(random_str 5)-$(git describe  --always --tags)-$(date "+%F-%H-%M-%S")";
    echo  "${script_subversion}";
    echo -n "script_subversion='${script_subversion}'; " >> "index.sh"
    echo -n 'echo "${script_subversion}=script_subversion"; ' >> "index.sh"
    echo '"'; >> "index.sh"
    #
    sleep $sleep_time;
    git add --verbose --all;
    sleep $sleep_time;
    git commit --allow-empty-message --message=$(date "+%F_%H-%M-%S") --verbose; git push --verbose;
)
