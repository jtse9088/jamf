#!/bin/sh
# This script renames the computer to first inital + last name + last 4 digits of serial

# gets last four of the serial number
serial_no=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}' | tail -c 5)

#gets name
#firstInitial=$(finger -s $getUser | head -2 | tail -n 1 | awk '{print tolower($2)}' | cut -c 1)
firstName=$(finger -s $getUser | head -3 | tail -n 1 | awk '{print tolower($2)}')
lastName=$(finger -s $getUser | head -3 | tail -n 1 | awk '{print tolower($3)}')

#user_name=$(ls  "/Users/" | grep -v '^[.*]' | grep -v 'root' | grep -v 'daemon' | grep -v 'jamf-ssh' | grep -v 'nobody' | grep -v 'Guest' | grep -v 'jamfadmin' | grep -v 'Shared' | grep -v 'Deleted Users')

#sets name
#computer_name="${firstInitial}${lastName}-${serial_no}"
computer_name="${firstName}.${lastName}-${serial_no}"
/usr/sbin/scutil --set LocalHostName "${computer_name}"
/usr/sbin/scutil --set ComputerName "${computer_name}"
/usr/sbin/scutil --set HostName "${computer_name}"

dscacheutil -flushcache

#Update Inventory to reflect the new name
sudo jamf recon