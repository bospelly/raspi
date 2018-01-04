#!/bin/bash
# Simple Ping Monitor for hosts
#
# We parse this file to retrieve Hosts
HOSTS=$(cat /home/pi/Scripts/hosts.list)

## Check Hosts and compile a list of ones that may be unreachable
for myHost in $HOSTS;
do
	ping -q -c 3 $myHost > /dev/null
	if [ ! $? -eq 0 ]
	then
		echo "Host: $myHost is unresponsive (ping failed)" >> /home/pi/Scripts/down_now
	fi
done

## Email that list and remove the file for next check
# Set email VARS
SUBJECT="monitored host(s) unreachable!"
# --- SOURCE FILE WITH VARIABLES ---
# Source the file with vairables -- USE COMPLETE PATH
source /home/pi/Scripts/send_raspi_info_variables.txt
# You will need a file with the variables "EMAIL" and "RASPI_EMAIL"

#Send email and remove list
if [ -e /home/pi/Scripts/down_now ];
then
	echo "$(cat /home/pi/Scripts/down_now)" | mail -a "Subject: $HOSTNAME $SUBJECT" \
			 			       -a "From: $HOSTNAME <$RASPI_EMAIL>" \
			 	 		       $EMAIL
	rm -rf /home/pi/Scripts/down_now
else
	exit 0
fi

exit 0
