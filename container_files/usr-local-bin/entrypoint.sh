#!/bin/sh

. /usr/local/bin/library.sh
prepConf

if [ "$#" -eq 0 ]; 
  then
   echo no component set to run
   finishPrep
   exec /usr/bin/supervisord -c /opt/tier-support/supervisord.conf
else
  echo executing $@
  exec "$@"
fi
