#!/bin/sh

. /usr/local/bin/library.sh
prep_conf

if [ "$#" -eq 0 ]; 
  then
   echo no component set to run
   prep_finish
   setupFiles
   runCommand
else
  echo executing $@
  exec "$@"
fi
