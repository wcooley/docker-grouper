#!/bin/sh

. /usr/local/bin/library.sh
prepConf

if [ "$#" -eq 0 ]; 
  then
   finishPrep
   exec /usr/bin/supervisord -c /opt/tier-support/supervisord.conf
else
  exec "$@"
fi
