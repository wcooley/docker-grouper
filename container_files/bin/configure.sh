#!/bin/bash

log="/tmp/grouper-configure.log"
date >> $log
#sed -i "s|#GROUPER_SYSTEM_PASSWORD#|$GROUPER_SYSTEM_PASSWORD|g" /opt/etc/grouper.installer.properties >> $log

# Long-lived configuration values, these are symlinked into place

sed -i "s|#MYSQL_HOST#|$MYSQL_HOST|g" /opt/etc/grouper.hibernate.properties >> $log

sed -i "s|#MYSQL_USER#|$MYSQL_USER|g" /opt/etc/grouper.hibernate.properties >> $log

sed -i "s|#MYSQL_PASSWORD#|$MYSQL_PASSWORD|g" /opt/etc/grouper.hibernate.properties >> $log

sed -i "s|#MYSQL_DATABASE#|$MYSQL_DATABASE|g" /opt/etc/grouper.hibernate.properties >> $log

# Transient DB whitelist capability for when schema changes are needed

sed -i "s|#MYSQL_HOST#|$MYSQL_HOST|g" /opt/etc/grouper.properties >> $log

sed -i "s|#MYSQL_USER#|$MYSQL_USER|g" /opt/etc/grouper.properties >> $log

sed -i "s|#MYSQL_DATABASE#|$MYSQL_DATABASE|g" /opt/etc/grouper.properties >> $log

cat /opt/etc/grouper.hibernate.properties >> $log

cat /opt/etc/grouper.properties >> $log
