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
		active_window_title="$(xdotool getwindowname $(xdotool getactivewindow) )"
		trim_var active_window_title
		# last_active_window_title="$active_window_title"
		if [[ "$last_active_window_title" == "$active_window_title" ]]; then
			# if active window name didn't change - don't add it to log
			str_add_last_active_window_title_to_log="";
		else
			# if active window changed - add its name to log
			str_add_last_active_window_title_to_log="${x0a} ● ${active_window_title} ● ${x0a}";
		fi
		echo "${str_add_last_active_window_title_to_log}${selection_str}" >> "$xsel_log_fname"
		declare -g last_active_window_title="$active_window_title"
		# show_var  is_new_selection hashes selection_md5 selection_str
	fi
}
export -f save_new_selection_to_log

# https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
while : ;
do
	#selection_str="$(xsel --output --clipboard --secondary --primary --keep )"
	selection="$( xsel --primary )"
	save_new_selection_to_log "$selection"
	selection="$( xsel --secondary  )"
	save_new_selection_to_log "$selection"
	selection="$( xsel --clipboard  )"
	save_new_selection_to_log "$selection"

	selection="$( xclip -out -rmlastnl -selection clip )"
	save_new_selection_to_log "$selection"

	sleep $timeout_0

	# [[ "$selection" == '0' ]] && break;	# TODO delete this after debug
done;

exit



