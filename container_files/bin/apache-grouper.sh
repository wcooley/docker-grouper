#!/bin/bash

ps auxww |grep -iq start.sh
statusstart=$?

while [ "$statusstart" != 0 ]; do
ps auxww |grep -iq start.sh
statusstart=$?
echo "First start configuration is in process, please wait"
done
echo "Starting Apache"
/usr/local/bin/httpd-shib-foreground
