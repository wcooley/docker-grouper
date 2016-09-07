#!/bin/bash

log="/tmp/grouper-cleanup.log"
date >> $log
if [ -z ${COMPOSE+x} ];then
echo "Not composed so not waiting for MariaDB and first time running was ok: " >> $log
rm -f /tmp/firsttimerunning >> $log
else
echo "Composed with MariaDB, running completed" >> $log
rm -f /tmp/firsttimerunning >> $log
fi
