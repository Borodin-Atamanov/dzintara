#!/usr/bin/bash
# Dzintara
# Author dev@Borodin-Atamanov.ru
# License: MIT
# script run on target system in user mode with X11, and log local windows

#view logs:
# journalctl --all --follow --priority=7 -t dzintara_telemetry
# tail -f /var/log/syslog | grep dzintara;
# /var/log/dzintara
# /var/log/wmctrl_archivist

declare -g -x work_dir="/home/i/bin/dzintara/";
#declare -g -x work_dir="/home/i/github/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

start_log

declare -x -g service_name='wmctrl archivist dzintara';   #for slog systemd logs
slog "<5>start wmctrl archivist dzintara. It will log selection content."

#create new dir for logs
mkdir -pv "$wmctrl_archivist_log_dir"
chmod -v go+rwx "$wmctrl_archivist_log_dir"
wmctrl_log_fname="${wmctrl_archivist_log_dir}wmctrl-$(ymdhms).txt"
touch "$wmctrl_log_fname"
chmod -v 0644 "$wmctrl_log_fname"
#tcpdump -t -l -n -i any '(tcp dst port 53) or (udp dst port 53) or (tcp src port 53) or (udp src port 53)' | grep -F ' A? ' | rev | awk '{print $2}' | rev > "$log_fname"
# start logging

declare -A -g -x selection_hashes

last_time="$(date "+%F-%H-%M")"
function save_new_selection_to_log ()
{
	selection_str="$1"
	trim_var selection_str
	selection_md5="$(echo -n "$selection_str" | md5 | xxd -r -p | base32 | sed 's/=//g')"
	#selection_md5="$(echo -n "$selection_str" | md5 )"
	#[ "${hashes[$selection_md5]+abc}" ] && is_new_hash=1;
	#echo ${hashes[$selection_md5]}
	if [[ -v "selection_hashes[$selection_md5]" ]] ; then
		is_new_selection=0
	else
		is_new_selection=1
	fi
	if [[ $selection_md5 != '' ]]; then
		selection_hashes[$selection_md5]="1";
	fi
	hashes="${#selection_hashes[*]}"

	if [[ "$is_new_selection" = '1' ]]; then
		# It's new selection - save it to file
		new_time="$(date "+%F-%H-%M")"
		if [[ "$last_time" != "$new_time" ]]; then
			echo " ● $new_time" >> "$wmctrl_log_fname"
		fi
		last_time="$(date "+%F-%H-%M")"
		echo "${selection_str}" >> "$wmctrl_log_fname"
		# show_var  is_new_selection hashes selection_md5 selection_str
	fi
}
export -f save_new_selection_to_log

# https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
while : ;
do
	#selection_str="$(xsel --output --clipboard --secondary --primary --keep )"
	wms="$( wmctrl -l | awk '{$1=""; $2=""; $3=""; print$0}' )"
	old_ifs="$IFS"
	while IFS= read -r line; do
		save_new_selection_to_log "$line"
	done <<< "$wms"
	sleep $timeout_0

	# save_new_selection_to_log "$selection"
	# timeout 1 xmessage -timeout 1 "$selection"
	# sleep $timeout_0


# 	selection="$( xsel --output --nodetach --secondary  )"
# 	save_new_selection_to_log "$selection"
# 	sleep $timeout_0
#
# 	selection="$( xsel --output --nodetach --clipboard  )"
# 	save_new_selection_to_log "$selection"
# 	sleep $timeout_0

	#selection="$( xclip -out -rmlastnl -selection clip )"
	#save_new_selection_to_log "$selection"

	#sleep $timeout_1

	# [[ "$selection" == '0' ]] && break;	# TODO delete this after debug
done;

exit



