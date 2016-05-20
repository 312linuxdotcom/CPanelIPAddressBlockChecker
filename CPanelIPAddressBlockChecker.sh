#!/bin/bash

#check the script is being ran properly ie) ipcheck 192.168.1.1
if [ $# -ne 1 ]
then
echo "Please retry... Operation has been aborted due to insufficient arguments"
echo "Please run the command followed by a routable IP address"
echo "Example: $0 192.168.0.1"
exit 1
fi

#Search for blocks in CSF, cpHulk, messages
grep $1 /usr/local/cpanel/logs/cphulkd.log
csf -g $1
grep $1 /var/log/messages|grep "TCP_IN Blocked" | tail -n2

#Ask user if they would like to remove the blocks
read -p "Check for and remove cPHulk Blocks? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then

#If yes, then remove the blocks
echo "Unblocking $1 ..."
whmapi1 flush_cphulk_login_history_for_ips ip=$1
csf -dr $1
csf -tr $1

#If no, quit
else echo "User quit, operation aborted"
exit 1
fi
