#!/bin/bash

log="/tmp/grouper.log"

cd /opt/grouper/2.3.0/grouper.apiBinary-2.3.0 && GROUPER_HOME=/opt/grouper/2.3.0/grouper.apiBinary-2.3.0 bin/gsh.sh -registry -check >> $log