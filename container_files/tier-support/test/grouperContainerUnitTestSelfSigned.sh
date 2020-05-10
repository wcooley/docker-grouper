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
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_LOG_TO_HOST=true $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_LOG_TO_HOST=true $imageName ui
  sleep $globalSleepSecondsAfterRun

  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf cachain.pem
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf /etc/pki/tls/certs/localhost.crt

  assertFileContains /etc/httpd/conf.d/grouper-www.conf "ProxyPass /grouper ajp://localhost:8009/grouper timeout=3600"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "#ProxyPass /grouper-ws ajp://localhost:8009/grouper timeout=3600"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "#ProxyPass /grouper-ws-scim ajp://localhost:8009/grouper timeout=3600"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "\"/grouper/\""
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "__"

  assertFileNotContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties "/tmp/logpipe"

  assertEnvVar GROUPERSCIM_PROXY_PASS "#"
  assertEnvVar GROUPERSCIM_URL_CONTEXT "grouper-ws-scim"
  assertEnvVar GROUPERWS_PROXY_PASS "#"
  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_APACHE_NONSSL_PORT "80"
  assertEnvVar GROUPER_APACHE_SSL_PORT "443"
  assertEnvVar GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "false"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper-ui"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_PROXY_PASS ""
  assertEnvVar GROUPER_RUN_APACHE "true"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVar GROUPER_RUN_SHIB_SP "true"
  assertEnvVar GROUPER_RUN_TOMEE "true"
  assertEnvVar GROUPER_SCIM "false"
  assertEnvVar GROUPER_SCIM_GROUPER_AUTH "false"
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
  # bad cert apache wont start
  assertNumberOfApacheProcesses 5
  assertNumberOfShibProcesses 1


}
