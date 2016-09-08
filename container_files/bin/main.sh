#!/bin/bash -x

log="/tmp/start-main.log"

echo "Starting Container: " > $log
date >> $log
echo "" >> $log

if [ -e "/tmp/firsttimerunning" ]; then

    set -e
    
    /opt/bin/configure.sh >> $log

    /opt/bin/check.sh >> $log

    /opt/bin/cleanup.sh >> $log
 
else
    echo "Grouper container has run." >> $log
    echo "If there are problems, docker rm this container and try again." >> $log
fi
#exit 0
