#!/bin/bash

testContainerUiNoSsl() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui without SSL with SSL client
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_TOMCAT_MAX_HEADER_COUNT=-1 -e GROUPER_USE_SSL=false -e GROUPER_TOMCAT_LOG_ACCESS=true -e GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES=30 $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_TOMCAT_MAX_HEADER_COUNT=-1 -e GROUPER_USE_SSL=false -e GROUPER_TOMCAT_LOG_ACCESS=true -e GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES=30 $imageName ui
  sleep $globalSleepSecondsAfterRun

  assertFileContains /opt/tomcat/conf/web.xml "<session-timeout>30</session-timeout>"
  
  assertFileNotContains /opt/tomcat/conf/server.xml "maxHeaderCount"

  assertEnvVar GROUPER_TOMCAT_LOG_ACCESS "true"
  assertEnvVar GROUPERWS_PROXY_PASS "#"
  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "false"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper-ui"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_PROXY_PASS ""
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVar GROUPER_RUN_TOMCAT "true"
  assertEnvVar GROUPER_TOMCAT_CONTEXT "grouper"
  assertEnvVar GROUPER_UI "true"
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "127.0.0.1/32"
  assertEnvVar GROUPER_UI_GROUPER_AUTH "false"
  assertEnvVar GROUPER_UI_ONLY "true"
  assertEnvVar GROUPER_URL_CONTEXT "grouper"
  assertEnvVar GROUPER_USE_SSL "false"
  assertEnvVar GROUPER_WS "false"
  assertEnvVar GROUPER_WS_GROUPER_AUTH "false"
  assertEnvVar GROUPER_WEBCLIENT_IS_SSL "true"

  assertNumberOfTomcatProcesses 1

  assertNotListeningOnPort 443
  assertListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001


}
export -f testContainerUiNoSsl
