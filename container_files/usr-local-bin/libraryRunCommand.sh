#!/bin/bash

runCommand() {

  if [ "$GROUPER_RUN_PROCESSES_AS_USERS" = "true" ]; then
    echo "grouperContainer; INFO: (libraryRunCommand.sh-runCommand) Starting tomcat: sudo --preserve-env -u tomcat /opt/tomcat/bin/catalina.sh run"
    sudo --preserve-env -u tomcat /opt/tomcat/bin/catalina.sh run
  else
    echo "grouperContainer; INFO: (libraryRunCommand.sh-runCommand) Starting tomcat: /opt/tomcat/bin/catalina.sh run"
    /opt/tomcat/bin/catalina.sh run
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

