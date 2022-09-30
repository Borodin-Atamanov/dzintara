#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun from systemd when network connects.

#This script calls another scripts

set_o_posix="$( ( set -o posix ; set ) )";

declare -g -x work_dir="/home/i/bin/dzintara/";
declare -g -x work_dir_autorun="${work_dir}autorun/";
#declare_and_export work_dir "/home/i/bin/dzintara/"

#load variables
source_load_variables="source ${work_dir_autorun}load_variables.sh";
$source_load_variables;

declare -x -g service_name='dzintara.root_autorun_network';   #for slog systemd logs

declare_and_export fullpath_bash "$( get_command_fullpath bash )";
declare_and_export fullpath_nohup "$( get_command_fullpath nohup )";

#start plus root script
slog "<5>start root console script after network connect. It will start other scripts."
slog "<7>$(show_var EUID)"
whoami="$(whoami)"
slog "<7>$(show_var whoami)"

sleep $timeout_2

ymdhms=$(ymdhms)

hostname="$(hostname)"
load_var_from_file "/etc/hostname" hostname2
hostname_ip="$(hostname --all-ip-addresses | tr ' ' '\n')"
hostnamectl="$(hostnamectl | grep -v "Hardware Vendor" | grep -v "Hardware Model" | grep -v "Machine ID" | grep -v "Boot ID" | grep -v "Deployment" | grep -v "Icon name" | tr '\n' ' ' )";
hostnamectl=$(echo -n $hostnamectl);

uptime="$(uptime)"

os_codename=$( trim $(lsb_release --short --codename ))
#lsb_release --short --id --codename --description --release = Ubuntu Ubuntu 22.04.1 LTS  22.04 jammy | Debian Debian GNU/Linux 11 (bullseye) 11 bullseye
architecture=$( trim $(dpkg --print-architecture))

tor_hostname_file='/var/lib/tor/hidden_service/hostname';
tor_hostname="$(cat $tor_hostname_file)"

wmctrl_l="$(timeout --kill-after=$timeout_1 $timeout_2 wmctrl -l)"

pstree="$(pstree)"

top_b_n_1="$(timeout --kill-after=$timeout_1 $timeout_2 top -b -n 1)"

ps_forest="$(timeout --kill-after=$timeout_1 $timeout_2 ps -A -l -y ww  --forest --cumulative --sort cutime)"

systemctl_status="$(timeout --kill-after=$timeout_1 $timeout_2 systemctl status | cat)"

swapon="$(swapon)"

zramctl_output_all="$(timeout --kill-after=$timeout_1 $timeout_2 zramctl --output-all)"

free_mega_wide_lohi="$(timeout --kill-after=$timeout_1 $timeout_2 free --mega --wide --lohi)"

uname_a="$(uname -a)"

mount="$(timeout --kill-after=$timeout_1 $timeout_2 mount)"

lsscsi="$(lsscsi)"

fdisk_l="$(fdisk -l)"

lsblk="$(lsblk)"

lscpu="$(lscpu)"

lsusb="$(lsusb)"

lshw_short="$(lshw -short)"

lspci="$(lspci)"

last_fulltimes_ip="$(last --fulltimes --ip)"

wmctrl_m="$( wmctrl -m) "

netstat="$(timeout --kill-after=$timeout_1 $timeout_2 netstat -tunlp)"

yggd1="$(timeout --kill-after=$timeout_1 $timeout_2 yggdrasilctl getPeers)"
yggd2="$(timeout --kill-after=$timeout_1 $timeout_2 yggdrasilctl -v getSelf)"

ip1="$(timeout --kill-after=$timeout_1 $timeout_2 ip a)"
ip2="$(timeout --kill-after=$timeout_1 $timeout_2 ip -human-readable -statistics -details -pretty a)"
ip3="$(timeout --kill-after=$timeout_1 $timeout_2 ip r)"

# ="$(timeout --kill-after=$timeout_1 $timeout_2 1111111111)"

ipfy4="$(timeout --kill-after=$timeout_1 $timeout_2 wget -qO - 'https://api.ipify.org/?format=txt')"
ipfy6="$(timeout --kill-after=$timeout_1 $timeout_2 wget -qO - 'https://api64.ipify.org/?format=txt')"
ipfy4_whois="$(timeout --kill-after=$timeout_1 $timeout_2 whois "$ipfy4")"
if [[ "$ipfy6" != "$ipfy4" ]]; then
    ipfy6_whois="$(timeout --kill-after=$timeout_1 $timeout_2 whois "$ipfy6")"
else
    # if ipfy6 == ipfy4
    ipfy6='';
fi

arp="$(timeout --kill-after=$timeout_1 $timeout_2 arp)"

ifconfig="$(timeout --kill-after=$timeout_1 $timeout_2 /sbin/ifconfig -a)"

nmcli_device="$(timeout --kill-after=$timeout_1 $timeout_2 nmcli device status)"

nmcli_connection="$(timeout --kill-after=$timeout_1 $timeout_2 nmcli connection show)"

tcpdump_interfaces="$(timeout --kill-after=$timeout_1 $timeout_2 tcpdump --list-interfaces)"


update_alternatives_verbose_debug_get_selections="$(timeout --kill-after=$timeout_1 $timeout_2 update-alternatives --verbose --debug --get-selections)"

inxi_data=""
inxi_args=" --machine --cpu --graphics --sensors --battery --slots --disk --disk-full --partitions-full --usb --label --logical --raid --swap --bluetooth --network --network-advanced --ip --repos --memory --processes --audio   --full --info -v8  "
for arg in $inxi_args; do
    inxi_cur="$(inxi  --tty --no-ssl -xxxxxxxxx $arg)"
    inxi_data="${inxi_data}${x0a}inxi $arg${x0a}${inxi_cur}${x0a}${x0a}"
    #sleep 1;
done;

# get info from dzintara log files in ram (/dev/shm/)

dzintara_ram_log_dir_content=''
while IFS= read -r -d '' -u 3 one_file; do
    load_var_from_file "${one_file}" one_file_content
    dzintara_ram_log_dir_content="${dzintara_ram_log_dir_content} - - - - - ${one_file} - - - - - ${x0a}${one_file_content}${x0a}${x0a}"
done 3< <(find "$dzintara_ram_log_dir" -mindepth 1 -maxdepth 1 -type f -name "*.*"  -printf '%s\t%p\0' | sort -zn | cut -zf 2-)

dmesg="$(dmesg)"

all_data_to_file=$(cat <<_ENDOFFILE
$ymdhms

hostname
${hostname2}
${hostname}
${hostname_ip}
${hostnamectl}

uname -a
${uname_a}

tor_hostname
${tor_hostname}

ipfy
${ipfy4}
[${ipfy6}]

${architecture}
${os_codename}

wmctrl -l
${wmctrl_l}

netstat
${netstat}

ip a r
${ip1}
${ip2}
${ip3}

yggdrasilctl
${yggd1}
${yggd2}

arp
${arp}

ifconfig
${ifconfig}

nmcli_device
${nmcli_device}

nmcli_connection
${nmcli_connection}

tcpdump_interfaces
${tcpdump_interfaces}

update-alternatives --verbose --debug --get-selections
${update_alternatives_verbose_debug_get_selections}

free --mega --wide --lohi
${free_mega_wide_lohi}

swapon
${swapon}

zramctl --output-all
${zramctl_output_all}

systemctl status
${systemctl_status}

mount
${mount}

set -o posix
${set_o_posix}

lsscsi
${lsscsi}

fdisk -l
${fdisk_l}

lsblk
${lsblk}

lscpu
${lscpu}

lsusb
${lsusb}

whois v4
${ipfy4_whois}

whois v6
${ipfy6_whois}

lshw -short
${lshw_short}

lspci
${lspci}

inxi
${inxi_data}

last --fulltimes --ip
${last_fulltimes_ip}

wmctrl -m
${wmctrl_m}

pstree
${pstree}

top -b -n 1
${top_b_n_1}

ps -A -l -y ww  --forest --cumulative --sort cutime
${ps_forest}

/dev/shm/dzintara/
${dzintara_ram_log_dir_content}

_ENDOFFILE
)

all_data_to_message=$(cat <<_ENDOFFILE
#${hostname} ${hostname}.local
${architecture} ${os_codename}
${hostname_ip}
${tor_hostname}
${ipfy4} ${ipfy6}
$ymdhms ${uptime}
_ENDOFFILE
)

#show_var all_data
tmpfile="$(mktemp /tmp/${hostname}-network-${ymdhms}-XXXXX.txt)"
show_var tmpfile
echo -n "$all_data_to_file" > "$tmpfile"

telemetry_send "$tmpfile" "${all_data_to_message}"

#slog "<5>finish $0"

exit 0


