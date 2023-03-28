#!/bin/bash

runCommand() {

  echo "grouperContainer; INFO: (libraryRunCommand.sh-runCommand) Starting tomcat"
  /opt/tomcat/bin/catalina.sh run
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

