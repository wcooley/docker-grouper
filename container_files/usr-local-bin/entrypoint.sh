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

  if [ "$@" = "/opt/grouper/grouperWebapp/WEB-INF/bin/gsh.sh" ]
    then 
      GROUPER_ENTRYPOINT_COMMAND=gsh
    else
      GROUPER_ENTRYPOINT_COMMAND="$@"
  fi

  echo executing "$GROUPER_ENTRYPOINT_COMMAND"
  exec "$GROUPER_ENTRYPOINT_COMMAND"
fi
