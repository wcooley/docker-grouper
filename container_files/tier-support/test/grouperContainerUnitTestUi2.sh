#!/bin/bash

testContainerUi2() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_TOMCAT_MAX_HEADER_COUNT=1235 -e GROUPER_SSL_CERT_FILE=/a/b/cert -e GROUPER_SSL_KEY_FILE=/a/b/key -e GROUPER_SSL_CHAIN_FILE=/a/b/chain -e GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=false $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_TOMCAT_MAX_HEADER_COUNT=1235 -e GROUPER_SSL_CERT_FILE=/a/b/cert -e GROUPER_SSL_KEY_FILE=/a/b/key -e GROUPER_SSL_CHAIN_FILE=/a/b/chain -e GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=false $imageName ui
  sleep $globalSleepSecondsAfterRun


  assertFileContains /opt/tomcat/conf/server.xml 'address="0.0.0.0"'
  assertFileContains /opt/tomcat/conf/server.xml 'allowedRequestAttributesPattern=".*"'
  
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

  assertFileContains /opt/tomcat/conf/server.xml "maxHeaderCount"
  assertFileContains /opt/tomcat/conf/server.xml "1235"

  assertEnvVar GROUPER_SSL_USE_CHAIN_FILE "true"
  assertEnvVar GROUPER_SSL_CERT_FILE "/a/b/cert"
  assertEnvVar GROUPER_SSL_KEY_FILE "/a/b/key"
  assertEnvVar GROUPER_SSL_CHAIN_FILE "/a/b/chain"

  assertNumberOfTomcatProcesses 1

  assertNotListeningOnPort 443
  assertNotListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001
  assertListeningOnPort 8080
  #assertListeningOnPort 8005


}
export -f testContainerUi2
