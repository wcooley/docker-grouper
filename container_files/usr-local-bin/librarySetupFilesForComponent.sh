#!/bin/bash

setupFilesForComponent_ws() {

  # copy files to their appropriate locations based on passed in flags
  if [ "$GROUPER_WS" = "true" ]
     then
       cp -r /opt/grouper/grouperWebapp/WEB-INF/libWs/* /opt/grouper/grouperWebapp/WEB-INF/lib/
       returnCode=$?
       echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ws) cp -r /opt/grouper/grouperWebapp/WEB-INF/libWs/* /opt/grouper/grouperWebapp/WEB-INF/lib/ , result: $returnCode"
       if [ $returnCode != 0 ]; then exit $returnCode; fi
       
       
       if [ ! -z "$GROUPERWS_URL_WITH_CONTEXT_NOSLASH" ]; then
        sed -i "s|http://localhost:8400/grouper-ws|$GROUPERWS_URL_WITH_CONTEXT_NOSLASH|g" /opt/grouper/grouperWebapp/docs/index.html
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ws) sed -i \"s|http://localhost:8400/grouper-ws|/$GROUPERWS_URL_WITH_CONTEXT_NOSLASH/|g\" /opt/grouper/grouperWebapp/docs/index.html , result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
       else
        echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ws) GROUPERWS_URL_WITH_CONTEXT_NOSLASH is not set, so not adjusting URL in swagger , result: $returnCode"
       fi
       
       if [ ! -z "$GROUPERWS_URL_CONTEXT" ]; then
        sed -i "s|/grouper-ws/|/$GROUPERWS_URL_CONTEXT/|g" /opt/grouper/grouperWebapp/docs/index.json
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ws) sed -i \"s|/grouper-ws/|/$GROUPERWS_URL_CONTEXT/|g\" /opt/grouper/grouperWebapp/docs/index.json , result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
       else
        echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ws) GROUPERWS_URL_CONTEXT is not set, so not adjusting context in swagger , result: $returnCode"
       fi
       
  else 
    rm -rf /opt/grouper/grouperWebapp/docs
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ws) rm -rf /opt/grouper/grouperWebapp/docs , result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}


setupFilesForComponent_ui() {

  if [ "$GROUPER_UI" = "true" ] || [ "$GROUPER_DAEMON" = "true" ]
     then
       cp -r /opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/* /opt/grouper/grouperWebapp/WEB-INF/lib/
       returnCode=$?
       echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ui) cp -r /opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/* /opt/grouper/grouperWebapp/WEB-INF/lib/ , result: $returnCode"
       if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesForComponent_quickstart() {

    if [ ! -z "$GROUPERSYSTEM_QUICKSTART_PASS" ]
      then
        if [ "$GROUPER_UI_GROUPER_AUTH" = 'true' ]
          then
            echo '' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.base.properties
            echo 'grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig = ${elUtils.processEnvVarOrFile('"'"'GROUPERSYSTEM_QUICKSTART_PASS'"'"')}' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties
            returnCode=$?
            echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_quickstart) edit grouper.hibernate.base.properties with UI GrouperSystem password for quick start, result: $returnCode"
            if [ $returnCode != 0 ]; then exit $returnCode; fi
        fi
        if [ "$GROUPER_WS_GROUPER_AUTH" = 'true' ]
          then         
            echo '' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.base.properties
            echo 'grouperPasswordConfigOverride_WS_GrouperSystem_pass.elConfig = ${elUtils.processEnvVarOrFile('"'"'GROUPERSYSTEM_QUICKSTART_PASS'"'"')}' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties
            returnCode=$?
            echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_quickstart) edit grouper.hibernate.base.properties with WS GrouperSystem password for quick start, result: $returnCode"
            if [ $returnCode != 0 ]; then exit $returnCode; fi
        fi
    fi

}

setupFilesForComponent() {
  
  setupFilesForComponent_ws

  setupFilesForComponent_ui

  setupFilesForComponent_quickstart

}


setupFilesForComponent_unsetAll() {
  unset -f setupFilesForComponent
  unset -f setupFilesForComponent_quickstart
  unset -f setupFilesForComponent_ui
  unset -f setupFilesForComponent_unsetAll
  unset -f setupFilesForComponent_ws
}

setupFilesForComponent_exportAll() {
  export -f setupFilesForComponent
  export -f setupFilesForComponent_quickstart
  export -f setupFilesForComponent_ui
  export -f setupFilesForComponent_unsetAll
  export -f setupFilesForComponent_ws
  
}

# export everything
setupFilesForComponent_exportAll


