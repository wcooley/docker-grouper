#!/bin/bash

testContainerSlashRoot() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui with slashRoot mounted
  echo "docker run --detach --name $containerName --mount type=bind,src=$someDir,dst=/opt/grouper/slashRoot --publish 443:443 $imageName ui"
  echo '################'
  echo

  local someDir=$(pwd)/someDir
  rm -rf someDir
  mkdir -p someDir/tmp
  echo 'whatever' > someDir/tmp/temp.txt
  mkdir -p someDir/opt/grouper/grouperWebapp/WEB-INF/classes
  echo 'someSettings' > someDir/opt/grouper/grouperWebapp/WEB-INF/classes/log4j_additional.properties

  docker run --detach --name $containerName --mount type=bind,src=$someDir,dst=/opt/grouper/slashRoot --publish 443:443 $imageName ui
  sleep $globalSleepSecondsAfterRun

  assertFileExists /tmp/temp.txt

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties "someSettings"


  #rm -rf someDir

}
export -f testContainerSlashRoot
