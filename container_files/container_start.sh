#!/bin/bash -x

log="/tmp/start.log"

echo "Starting Container: " > $log
date >> $log
echo "" >> $log

if [ -e "/tmp/firsttimerunning" ]; then

    set -e
    
    /root/configure.sh
    
    cd /opt/grouper/2.3.0/grouper.apiBinary-2.3.0 && GROUPER_HOME=/opt/grouper/2.3.0/grouper.apiBinary-2.3.0 bin/gsh.sh -check

    rm -f /tmp/firsttimerunning 
else
    echo "Grouper DB already provisioned" >> $log
fi

exit 0
