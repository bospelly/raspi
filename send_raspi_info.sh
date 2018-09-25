#!/bin/bash
# Script will gather some information and sent it via mail!
#
# --- VERSIONING ---
# Version 1.0 -- initial creation
# Version 1.1 -- adjustments
# Version 1.2 -- change command for DDCLIENT status
# Version 1.3 -- using file for variables
# Version 1.4 -- small adjustments
# Version 2.0 -- using GitHub for versioning
#
#
# --- SOURCE FILE WITH VARIABLES ---
# Source the file with vairables -- USE COMPLETE PATH
source /home/pi/Scripts/send_raspi_info_variables.txt
# You will need a file with the variables "EMAIL" and "RASPI_EMAIL"
#
#
# --- DEFINE LOCAL VARIABLES ---
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
#VPN=$(sudo more /var/log/openvpn.log |egrep "Peer|Inactivity")
NEXTCLOUD_BACKUP_DB=$(ls -1 /home/pi/Share/myNAS-SYBS/Backups/Nextcloud/db-backups/)
NEXTCLOUD_BACKUP_CFG=$(ls -1 /home/pi/Share/myNAS-SYBS/Backups/Nextcloud/config-backups/)
NEXTCLOUD_BACKUP_APPS_FOLDER=$(ls -1 /home/pi/Share/myNAS-SYBS/Backups/Nextcloud/apps-backups/)
NEXTCLOUD_BACKUP_THEMES_FOLDER=$(ls -1 /home/pi/Share/myNAS-SYBS/Backups/Nextcloud/themes-backups/)
NEXTCLOUD_BACKUP_FOLDER_SIZES=$(sudo du -sh /home/pi/Share/myNAS-SYBS/Backups/Nextcloud/* | sort -hr)
NEXTCLOUD_BACKUP_SIZES=$(sudo du -sh /home/pi/Share/myNAS-SYBS/Backups/* | sort -hr)
CHECK_FOR_UPDATES=$(sudo apt update)
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
	echo
	echo "$DDCLIENT_LOG"
	echo
	echo
	echo "[Authentication Information]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "$AUTHLOG"
	echo
	echo
#	echo "[OpenVPN Activities]"
#	echo "---------------------------------------------------------------------------------------------------"
#	echo "$VPN"
#	echo
#	echo
	echo "[Nextcloud Backup Files]"
	echo "---------------------------------------------------------------------------------------------------"
	echo "Backup files of database:"
	echo "----------------------------------"
	echo "$NEXTCLOUD_BACKUP_DB"
	echo
	echo "Backup files of config files:"
	echo "----------------------------------"
	echo "$NEXTCLOUD_BACKUP_CFG"
	echo
	echo "Backup files of apps folder:"
	echo "----------------------------------"
	echo "$NEXTCLOUD_BACKUP_APPS_FOLDER"
	echo
	echo "Backup files of themes folder:"
	echo "----------------------------------"
	echo "$NEXTCLOUD_BACKUP_THEMES_FOLDER"
	echo
	echo "Total size for backup files on the Raspi:"
	echo "----------------------------------"
	echo "$NEXTCLOUD_BACKUP_SIZES"
	echo
	echo "Detailed sizes for backup files on Raspi:"
	echo "----------------------------------"
	echo "$NEXTCLOUD_BACKUP_FOLDER_SIZES"
	echo
	echo "Checking for Updates:"
	echo "----------------------------------"
	echo "$CHECK_FOR_UPDATES"
	echo
} | mail -a "Subject: $HOSTNAME daily report" \
	 -a "From: $HOSTNAME <$RASPI_EMAIL>" \
	 $EMAIL
