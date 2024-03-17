#!/bin/bash

testContainerSelfSigned() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui with self signed cert
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_LOG_TO_HOST=true -e  -e =10.0.2.16/28 $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_LOG_TO_HOST=true $imageName ui
  sleep $globalSleepSecondsAfterRun

  assertEnvVar GROUPER_SSL_USE_CHAIN_FILE "false"
  assertEnvVar GROUPER_SSL_CERT_FILE "/etc/pki/tls/certs/localhost.crt"
  assertEnvVar GROUPER_SSL_KEY_FILE "/etc/pki/tls/private/localhost.key"

  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "false"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper-ui"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVar GROUPER_RUN_TOMCAT "true"
  assertEnvVar GROUPER_SELF_SIGNED_CERT "true"
  assertEnvVar GROUPER_TOMCAT_CONTEXT "grouper"
  assertEnvVar GROUPER_UI "true"
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "127.0.0.1/32"
  assertEnvVar GROUPER_UI_GROUPER_AUTH "false"
  assertEnvVar GROUPER_UI_ONLY "true"
  assertEnvVar GROUPER_URL_CONTEXT "grouper"
  assertEnvVar GROUPER_USE_SSL "true"
  assertEnvVar GROUPER_WS "false"
  assertEnvVar GROUPER_WS_GROUPER_AUTH "false"

  assertNumberOfTomcatProcesses 1


}
