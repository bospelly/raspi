#!/bin/bash
# Script will gather some information and sent it via mail!
# Version 1.0 -- initial creation
# Version 1.1 -- adjustments
# Version 1.2 -- change command for DDCLIENT status
# Version 1.3 -- using file for variables 
# Version 1.4 -- small adjustments
#
#
# Source the file with vairables
source ./send_raspi_info_variables.txt
# Define local variables for script
DATE="$(date)"
UPTIME_FOR=$(uptime -p)
UPTIME_SINCE=$(uptime -s)
MEMORYUSAGE=$(cat /proc/meminfo |egrep "Mem|Cache|Swap")
DISKUSAGE=$(df -h)
IFCONFIG=$(sudo ifconfig)
IPROUTE=$(ip route show)
SERVICES=$(sudo service --status-all |egrep "cron|ddclient|rsyslog|sendmail|unattended-upgrades")
DDCLIENT_LOG=$(sudo ddclient -daemon=0 -debug -verbose -noquiet |egrep -v "cache|config|globals|opt")
DDCLIENT_SERVICE=$(systemctl status ddclient.service)
AUTHLOG=$(cat /var/log/auth.log |egrep "Accepted|Disconnected")
VPN=$(sudo more /var/log/openvpn.log |egrep "Peer|Inactivity")
{
	echo "Todays report for $HOSTNAME"
	echo "Renerated: $DATE"
	echo "System is running since $UPTIME_SINCE (uptime is $UPTIME_FOR)"
	echo
	echo
	echo "[Memory Usage]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$MEMORYUSAGE"
	echo
	echo
	echo "[Disk Usage]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$DISKUSAGE"
	echo
	echo
	echo "[IP Address]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$IFCONFIG"
	echo
	echo
	echo "[IP Route]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$IPROUTE"
	echo
	echo
	echo "[Service Status]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$SERVICES"
	echo
	echo
	echo "[DynDNS Status]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$DDCLIENT_SERVICE"
	echo "$DDCLIENT_LOG"
	echo
	echo
	echo "[Authentication Information]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$AUTHLOG"
	echo
	echo
	echo "[OpenVPN Activities]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$VPN"
	echo
} | mail -a "Subject: $HOSTNAME daily report" \
	 -a "From: $HOSTNAME <$RASPI_EMAIL>" \
	 $EMAIL
