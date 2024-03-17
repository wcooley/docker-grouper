#!/bin/bash

testContainerQuickstart() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as quickstart
  echo "docker-compose up"
  echo '################'
  echo

  cp docker-compose.yaml.txt docker-compose.yaml
  sed -i "s|IMAGE_VERSION|$imageName|g" docker-compose.yaml
  
  docker-compose up
  sleep $globalSleepSecondsAfterRun

  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties GROUPERSYSTEM_QUICKSTART_PASS

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml "grouper;"

  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "true"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVar GROUPER_RUN_TOMCAT "true"
  assertEnvVar GROUPER_TOMCAT_CONTEXT "grouper"
  assertEnvVar GROUPER_UI "true"
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "0.0.0.0/0"
  assertEnvVar GROUPER_UI_GROUPER_AUTH "true"
  assertEnvVarNot GROUPER_UI_ONLY "true"
  assertEnvVar GROUPER_URL_CONTEXT "grouper"
  assertEnvVar GROUPER_USE_SSL "true"
  assertEnvVar GROUPER_WS "true"
  assertEnvVar GROUPER_WS_GROUPER_AUTH "true"

  assertNumberOfTomcatProcesses 1

  assertListeningOnPort 443
  assertListeningOnPort 80
  assertListeningOnPort 8009
  assertListeningOnPort 9001

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost -o index.html
  assertLocalFileContains index.html document.location.href

  curl -L -k https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:XthisPassIsCopyrightedDontUse https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'end index.jsp'

  curl -L -k https://localhost/grouper-ws/servicesRest/v2_4_000/subjects/GrouperSystem -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:XthisPassIsCopyrightedDontUse https://localhost/grouper-ws/servicesRest/v2_4_000/subjects/GrouperSystem -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost/grouper-ws/servicesRest/v2_4_000/subjects/GrouperSystem -o index.html
  assertLocalFileContains index.html '"resultCode":"SUCCESS"'

  docker stop $containerName
  docker start $containerName

  sleep $globalSleepSecondsAfterRun

  assertNumberOfTomcatProcesses 1

  assertListeningOnPort 443
  assertListeningOnPort 80
  assertListeningOnPort 8009
  assertListeningOnPort 9001

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost -o index.html
  assertLocalFileContains index.html document.location.href

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'end index.jsp'

  containerCommandResultEquals "ps -ef | grep root | grep cat | grep -v grep | wc -l" 6
  containerCommandResultEquals "ps -ef | grep root | grep awk | grep grouper | wc -l" 1
  containerCommandResultEquals "ps -ef | grep root | grep awk | grep tomcat | wc -l" 1

  docker-compose down
  rm docker-compose.yaml
}
export -f testContainerQuickstart
