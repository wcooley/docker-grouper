#!/bin/bash

testContainerDaemon() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as daemon
  echo "docker run --detach --name $containerName --publish 443:443 $imageName daemon"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 $imageName daemon
  sleep $globalSleepSecondsAfterRun

  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "true"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper-daemon"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVar GROUPER_RUN_TOMCAT "true"
  assertEnvVar GROUPER_TOMCAT_CONTEXT "grouper"
  assertEnvVar GROUPER_UI "false"
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "127.0.0.1/32"
  assertEnvVar GROUPER_UI_GROUPER_AUTH "false"
  assertEnvVar GROUPER_URL_CONTEXT "grouper"
  assertEnvVar GROUPER_USE_SSL "true"
  assertEnvVar GROUPER_WS "false"
  assertEnvVar GROUPER_WS_GROUPER_AUTH "false"

  assertNumberOfTomcatProcesses 1

  assertNotListeningOnPort 443
  assertNotListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001

}
export -f testContainerDaemon
