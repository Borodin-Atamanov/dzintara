#!/usr/bin/bash
# Dzintara
# Author dev@Borodin-Atamanov.ru
# License: MIT
# script run on target system in user mode with X11, and log local selection content

#view logs:
# journalctl --all --follow --priority=7 -t dzintara_telemetry
# tail -f /var/log/syslog | grep dzintara;

declare -g -x work_dir="/home/i/bin/dzintara/";
#declare -g -x work_dir="/home/i/github/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='xselection archivist dzintara';   #for slog systemd logs
slog "<5>start xselection archivist dzintara. It will log selection content."

#create new dir for logs
mkdir -pv "$xselection_archivist_log_dir"
chmod -v go+wx "$xselection_archivist_log_dir"
xsel_log_fname="${xselection_archivist_log_dir}xsel-$(ymdhms).txt"
touch "$xsel_log_fname"
chmod -v 0644 "$xsel_log_fname"
#tcpdump -t -l -n -i any '(tcp dst port 53) or (udp dst port 53) or (tcp src port 53) or (udp src port 53)' | grep -F ' A? ' | rev | awk '{print $2}' | rev > "$log_fname"
# start logging

declare -A -g -x selection_hashes

function save_new_selection_to_log ()
{
}
export -f save_new_selection_to_log

# https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
while : ;
do
	#selection_str="$(xsel --output --clipboard --secondary --primary --keep )"
	selection_str="$( xsel --primary )"
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
		echo "$selection_str" >> "$xsel_log_fname"
		show_var  is_new_selection hashes selection_md5 selection_str
	fi
	sleep $timeout_0

	[[ "$selection_str" = '0' ]] && break;	# TODO delete this after debug
done;

exit
