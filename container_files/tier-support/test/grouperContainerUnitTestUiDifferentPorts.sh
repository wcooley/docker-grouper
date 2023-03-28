#!/bin/bash

testContainerUiDifferentPorts() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui with self signed cert with different ports
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_TOMCAT_HTTP_PORT=8600 -e GROUPER_TOMCAT_AJP_PORT=8601 -e GROUPER_TOMCAT_SHUTDOWN_PORT=8602 $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_TOMCAT_HTTP_PORT=8600 -e GROUPER_TOMCAT_AJP_PORT=8601 -e GROUPER_TOMCAT_SHUTDOWN_PORT=8602 $imageName ui
  sleep $globalSleepSecondsAfterRun

  assertEnvVar GROUPER_TOMCAT_HTTP_PORT "8600"
  assertEnvVar GROUPER_TOMCAT_AJP_PORT "8601"
  assertEnvVar GROUPER_TOMCAT_SHUTDOWN_PORT "8602"

  assertNumberOfTomcatProcesses 1

  assertListeningOnPort 444
  assertListeningOnPort 81
  assertNotListeningOnPort 443
  assertNotListeningOnPort 80
  assertListeningOnPort 8600
  assertListeningOnPort 8601
  #assertListeningOnPort 8602
  assertNotListeningOnPort 9001


}
export -f testContainerUiDifferentPorts
