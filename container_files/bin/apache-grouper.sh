#!/bin/bash
log=/tmp/apache-supervisor.log
date >> $log
ps auxww |grep -iq start.sh
statusstart=$?

while [ "$statusstart" != 0 ]; do
ps auxww |grep -iq start.sh
statusstart=$?
echo "First start configuration is in process, please wait" >> $log
done
echo "Starting Apache" >> $log
date >> $log
/usr/local/bin/httpd-shib-foreground
