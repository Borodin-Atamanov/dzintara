#!/usr/bin/bash
# Dzintara
# Author dev@Borodin-Atamanov.ru
# License: MIT
# script run on target system in root mode, and log local dns queries

#view logs:
# journalctl --all --follow --priority=7 -t dzintara_telemetry
# tail -f /var/log/syslog | grep dzintara;

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
#source "/home/i/bin/dzintara/autorun/load_variables.sh"
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dns archivist dzintara';   #for slog systemd logs
slog "<5>start dns archivist dzintara. It will log dns requests."

#create new dir for logs
mkdir -pv "$dns_archivist_log_dir"
chmod -v go+wx "$dns_archivist_log_dir"
log_fname="${dns_archivist_log_dir}dns-$(ymdhms).txt"
chmod -v 0644 "$log_fname"
#tcpdump -t -l -n -i any '(tcp dst port 53) or (udp dst port 53) or (tcp src port 53) or (udp src port 53)' | grep -F ' A? ' | rev | awk '{print $2}' | rev > "$log_fname"
# start logging

# this capture not all DNS queries, most of the browser's queries is not here:
tcpdump -t -l -n -i any | grep -F ' A? ' | awk '{ print $(NF-1); fflush() }' >> "$log_fname"
# TODO find solution how to get all local DNS requests.

exit

# now only small part of them can be logged

# when using system request:
# 17:01:34.899392 lo    In  IP 127.0.0.1.56563 > 127.0.0.1.53: 12083+ [1au] A? uru.com. (48)
# 17:01:36.144830 lo    In  IP 127.0.0.1.53 > 127.0.0.1.56563: 12083 1/0/1 A 65.98.217.88 (52)
# 17:01:47.200728 lo    In  IP 127.0.0.1.45976 > 127.0.0.1.53: 27238+ [1au] A? biv.com. (48)
# 17:01:48.701202 lo    In  IP 127.0.0.1.53 > 127.0.0.1.45976: 27238 1/0/1 A 23.185.0.2 (52)
# 17:01:59.756758 lo    In  IP 127.0.0.1.40962 > 127.0.0.1.53: 16861+ [1au] A? axi.com. (48)
# 17:02:01.028180 lo    In  IP 127.0.0.1.53 > 127.0.0.1.40962: 16861 2/0/1 A 2.19.183.138, A 2.19.183.152 (68)
# 17:02:12.087085 lo    In  IP 127.0.0.1.40166 > 127.0.0.1.53: 30073+ [1au] A? gol.com. (48)
# 17:02:13.488215 lo    In  IP 127.0.0.1.53 > 127.0.0.1.40166: 30073 0/1/1 (83)
# 17:02:24.550857 lo    In  IP 127.0.0.1.50116 > 127.0.0.1.53: 30660+ [1au] A? osu.com. (48)
# 17:02:25.764407 lo    In  IP 127.0.0.1.53 > 127.0.0.1.50116: 30660 0/1/1 (95)

# when using chrome
# 17:05:44.789936 lo    In  IP 127.0.0.1.42119 > 127.0.0.1.53: 19754+ A? muka.com. (26)
# 17:05:44.957225 wlx1c5974830f22 Out IP 192.168.4.100.60355 > 1.1.1.1.53: 19754+ A? muka.com. (26)
# 17:05:44.976946 wlx1c5974830f22 Out IP 192.168.4.100.40751 > 9.9.9.11.53: 19754+ A? muka.com. (26)
# 17:05:45.029515 lo    In  IP 127.0.0.1.42908 > 127.0.0.1.53: 5036+ A? muka.com. (26)
# 17:05:45.193226 wlx1c5974830f22 Out IP 192.168.4.100.54921 > 1.1.1.1.53: 5036+ A? muka.com. (26)
# 17:05:45.217807 wlx1c5974830f22 Out IP 192.168.4.100.59693 > 9.9.9.11.53: 5036+ A? muka.com. (26)
