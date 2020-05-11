#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
if [ "$#" -ne 2 ]; then
  echo "You must enter exactly 2 command line arguments: username, and uid to change to"
  exit 1
fi
username=$1
newUid=$2
oldUid="$(id -u "$username")"
usermod -u "$newUid" "$username"
find / -xdev -type d -user "$oldUid" -exec chown -h "$username" {} \;
