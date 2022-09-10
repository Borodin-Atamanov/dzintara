#!/usr/bin/bash
sleep_time='0.42';
#set -x;
vault/encrypt_all_vaults.sh
source index.sh fun
sleep $sleep_time;
time ( \
    git diff | head --lines=42
    sleep $sleep_time;
    echo git pull --verbose;
    git whatchanged | head --lines=13
    #find and delete old script_subversion set from index.sh
    cat index.sh | grep -v '^script_subversion' | grep -v '^export script_subversion'  | cat > index_w_script_subversion.sh
    script_subversion="$(random_str 5)-$(git describe  --always --tags)-$(date "+%F-%H-%M-%S")";
    #add script_subversion to index.sh
    echo  "●●● ${script_subversion}";
    echo -n "export script_subversion='${script_subversion}'; " >> "index_w_script_subversion.sh"
    echo -n 'echo "${script_subversion}=script_subversion"; ' >> "index_w_script_subversion.sh"
    # echo '"'; >> "index_w_script_subversion.sh"
    echo -e "\n"; >> "index_w_script_subversion.sh"
    cp --update --verbose "index_w_script_subversion.sh" "index.sh";
    rm -v "index_w_script_subversion.sh"
    #
    sleep $sleep_time;
    git add --verbose --all;
    sleep $sleep_time;
    git commit --allow-empty-message --message="$script_subversion" --verbose;
    git push --verbose;
    echo  "●●● ${script_subversion}";
    #check all syntax without running
    find . -name '*.sh' -print0 | xargs -0 -P"$(nproc)"  -I {} bash -n "{}"
)
