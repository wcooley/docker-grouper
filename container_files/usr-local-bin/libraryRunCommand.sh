#!/bin/sh

runCommand() {

  runCommand_unsetAll
  
  if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" = "true" ]
    then
      /opt/tomee/bin/catalina.sh run
    else
      exec /usr/bin/supervisord -c /opt/tier-support/supervisord.conf
  fi

}

runCommand_unsetAll() {
  unset -f runCommand
  unset -f runCommand_unsetAll
}

runCommand_exportAll() {
  export -f runCommand
  export -f runCommand_unsetAll
  
}

# export everything
runCommand_exportAll

