#!/bin/bash -x

log="/tmp/start.log"

echo "Starting Container: " > $log
date >> $log
echo "" >> $log

if [ -e "/tmp/firsttimerunning" ]; then

    set -e
    
    /opt/bin/configure.sh

    /opt/bin/check.sh

    rm -f /tmp/firsttimerunning 
else
    echo "Grouper DB already provisioned" >> $log
fi

exit 0
