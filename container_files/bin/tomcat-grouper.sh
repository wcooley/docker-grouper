#!/bin/bash

ps auxww |grep -iq start.sh
statusstart=$?
ps auxww | grep -iq bin/httpd-shib-foreground
statusapache=$?

while [ "$statusstart" != 0 ] && [ "$statusapache" == "0" ]; do
ps auxww |grep -iq start.sh
statusstart=$?
echo "First start configuration is in process, please wait"
ps auxww | grep -iq bin/httpd-shib-foreground
statusapache=$?
echo "Apache is not running, please wait"
done
echo "Starting Tomcat"
/opt/grouper/2.3.0/apache-tomcat-6.0.35/bin/catalina.sh run

