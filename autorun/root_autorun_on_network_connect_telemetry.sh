#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
#script autorun from systemd when network connects.

#This script calls another scripts



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

ymdhms=$(ymdhms)

hostname="$(hostname)"
load_var_from_file "/etc/hostname" hostname2
hostname_ip="$(hostname --all-ip-addresses | tr ' ' '\n')"
hostnamectl="$(hostnamectl | grep -v "Hardware Vendor" | grep -v "Hardware Model" | grep -v "Machine ID" | grep -v "Boot ID" | grep -v "Deployment" | grep -v "Icon name" | tr '\n' ' ' )";
hostnamectl=$(echo -n $hostnamectl);


os_codename=$( trim $(lsb_release --short --codename ))
#lsb_release --short --id --codename --description --release = Ubuntu Ubuntu 22.04.1 LTS  22.04 jammy | Debian Debian GNU/Linux 11 (bullseye) 11 bullseye
architecture=$( trim $(dpkg --print-architecture))

tor_hostname_file='/var/lib/tor/hidden_service/hostname';
tor_hostname="$(cat $tor_hostname_file)"

top_b_n_1="$(top -b -n 1)"

free_mega_wide_lohi="$(free --mega --wide --lohi)"

uname_a="$(uname -a)"

lsscsi="$(lsscsi)"

fdisk_l="$(fdisk -l)"

lsblk="$(lsblk)"

lscpu="$(lscpu)"

lsusb="$(lsusb)"

lshw_short="$(lshw -short)"

lspci="$(lspci)"

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
if [[ "$ipfy6" != "$ipfy4}" ]]; then
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

all_data_to_file=$(cat <<_ENDOFFILE
$ymdhms

hostname
${hostname2}
${hostname}
${hostname_ip}

tor_hostname
${tor_hostname}

ipfy
${ipfy4}
[${ipfy6}]

${architecture}
${os_codename}

${hostnamectl}

uname -a
${uname_a}

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

free --mega --wide --lohi
${free_mega_wide_lohi}

top -b -n 1
${top_b_n_1}

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


_ENDOFFILE
)

all_data_to_message=$(cat <<_ENDOFFILE
$ymdhms
${hostname}
${hostname_ip}
${tor_hostname}
${ipfy4}
${ipfy6}
${architecture}
${os_codename}
${hostnamectl_status}
_ENDOFFILE
)

#show_var all_data
tmpfile="$(mktemp /tmp/${hostname}-network-${ymdhms}-XXXXX.txt)"
show_var tmpfile
echo -n "$all_data_to_file" > "$tmpfile"

telemetry_send "$tmpfile" "${all_data_to_message}"

#slog "<5>finish $0"

exit 0


