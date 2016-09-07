#!/bin/bash

log="/tmp/grouper-check.log"

echo "Installing schema" >> $log
cd /opt/grouper/2.3.0/grouper.apiBinary-2.3.0 && GROUPER_HOME=/opt/grouper/2.3.0/grouper.apiBinary-2.3.0 bin/gsh.sh -registry -drop -runscript -noprompt >> $log

echo "Preparing subjects" >> $log
cd /opt/grouper/2.3.0/grouper.apiBinary-2.3.0 && GROUPER_HOME=/opt/grouper/2.3.0/grouper.apiBinary-2.3.0 bin/gsh.sh -registry -runsqlfile /opt/grouper/2.3.0/subjects.sql -noprompt >> $log

echo "Adding Quickstart data" >> $log
cd /opt/grouper/2.3.0/grouper.apiBinary-2.3.0 && GROUPER_HOME=/opt/grouper/2.3.0/grouper.apiBinary-2.3.0 bin/gsh.sh -xmlimportold GrouperSystem /opt/grouper/2.3.0/quickstart.xml -noprompt >> $log

echo "Checking" >> $log
cd /opt/grouper/2.3.0/grouper.apiBinary-2.3.0 && GROUPER_HOME=/opt/grouper/2.3.0/grouper.apiBinary-2.3.0 bin/gsh.sh -registry -check >> $log
