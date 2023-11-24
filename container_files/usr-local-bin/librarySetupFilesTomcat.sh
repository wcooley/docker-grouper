#!/bin/bash

setupFilesTomcat() {
  setupFilesTomcat_serverXml
  setupFilesTomcat_remoteCidrValve
  setupFilesTomcat_turnOnAjp
  setupFilesTomcat_authn
  setupFilesTomcat_context
  setupFilesTomcat_ports
  setupFilesTomcat_accessLogs
  setupFilesTomcat_sessionTimeout
  setupFilesTomcat_ssl
  setupFilesTomcat_sslCertsAnchors
  setupFilesTomcat_sslCertsClient
}


setupFilesTomcat_remoteCidrValve() {

  if [ ! -z "$GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW" ]; then 
    if [ $(grep -c '<!--GROUPER_REMOTE_CIDR_VALVE-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      sed -i 's|<!--GROUPER_REMOTE_CIDR_VALVE-->|<Valve className="org.apache.catalina.valves.RemoteCIDRValve" allow="__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__" usePeerAddress="true" />|g' /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteCidrValve) Apply remote CIDR valve: sed -i 's|<!--GROUPER_REMOTE_CIDR_VALVE-->|<Valve className=\"org.apache.catalina.valves.RemoteCIDRValve\" allow=\"__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__\"  usePeerAddress=\"true\" />|g' /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      sed -i "s|__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__|$GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW|g" /opt/tomcat/conf/server.xml
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteCidrValve) Apply remote CIDR valve value: sed -i \"s|__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__|$GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteCidrValve) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_REMOTE_CIDR_VALVE--> so will not have remote CIDR valve applied"
    fi
    
  fi

}

setupFilesTomcat_serverXml() {

  if [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]; then
    cp /opt/tomcat/conf/server.xml /opt/tomcat/conf/server.xml.currentOriginalInContainer
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_serverXml) cp /opt/tomcat/conf/server.xml /opt/tomcat/conf/server.xml.currentOriginalInContainer , result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi

    patch /opt/tomcat/conf/server.xml /opt/tomcat/conf/server.xml.grouper.patch
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_serverXml) Patch server.xml to apply grouper settings: patch /opt/tomcat/conf/server.xml /opt/tomcat/conf/server.xml.grouper.patch, result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
  else
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_serverXml) /opt/tomcat/conf/server.xml is not the original file so will not be edited"
  fi
  
}


setupFilesTomcat_turnOnAjp() {

  if [ $(grep -c '<!--GROUPER_AJP_CONNECTOR-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
  
    sed -i 's|<!--GROUPER_AJP_CONNECTOR-->|<Connector address="0.0.0.0" secretRequired="false" secure="true"  scheme="https"  URIEncoding="UTF-8"  tomcatAuthentication="false"  port="8009" protocol="AJP/1.3" redirectPort="8443" maxParameterCount="10000" />|g' /opt/tomcat/conf/server.xml 
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) Apply AJP: sed -i 's|<!--GROUPER_AJP_CONNECTOR-->|<Connector address=\"0.0.0.0\" secretRequired=\"false\" secure=\"true\"  scheme=\"https\"  URIEncoding=\"UTF-8\"  tomcatAuthentication=\"false\"  port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" maxParameterCount=\"10000\" />|g' /opt/tomcat/conf/server.xml, result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
  else
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_AJP_CONNECTOR--> so will not have AJP connector applied"
  fi
  
}

setupFilesTomcat_accessLogs() {
  
  if [ "$GROUPER_TOMCAT_LOG_ACCESS" = "true" ]; then
    if [ $(grep -c '<!--GROUPER_LOGGING_VALVE-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      sed -i 's|<!--GROUPER_LOGGING_VALVE-->|<Valve className="org.apache.catalina.valves.AccessLogValve" directory="/tmp" prefix="tomcat_access_log" rotatable="false" pattern="%h %l %u %t \&quot;%r\&quot; %s %b" />|g' /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) Apply access logs: sed -i 's|<!--GROUPER_LOGGING_VALVE-->|<Valve className=\"org.apache.catalina.valves.AccessLogValve\" directory=\"/tmp\" prefix=\"tomcat_access_log\" rotatable=\"false\" pattern=\"%h %l %u %t &quot;%r&quot; %s %b\" />|g' /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_LOGGING_VALVE--> so will not have access logs applied"
    fi
  fi
  
}

setupFilesTomcat_ports() {

      if [ "$GROUPER_TOMCAT_HTTP_PORT" != "8080" ]; then 
        sed -i "s|8080|$GROUPER_TOMCAT_HTTP_PORT|g" /opt/tomcat/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change http port: sed -i \"s|8080|$GROUPER_TOMCAT_HTTP_PORT|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ "$GROUPER_TOMCAT_AJP_PORT" != "8009" ]; then 
        sed -i "s|8009|$GROUPER_TOMCAT_AJP_PORT|g" /opt/tomcat/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change ajp port: sed -i \"s|8009|$GROUPER_TOMCAT_AJP_PORT|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ "$GROUPER_TOMCAT_MAX_HEADER_COUNT" != "-1" ]; then 
        # add in maxHeaderCount since new chrome sends too many headers
        sed -i "s|port=\"$GROUPER_TOMCAT_AJP_PORT\"|port=\"$GROUPER_TOMCAT_AJP_PORT\" maxHeaderCount=\"$GROUPER_TOMCAT_MAX_HEADER_COUNT\" |g" /opt/tomcat/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml add maxHeaderCount: sed -i \"s|port=\"$GROUPER_TOMCAT_AJP_PORT\"|port=\"$GROUPER_TOMCAT_AJP_PORT\" maxHeaderCount=\"$GROUPER_TOMCAT_MAX_HEADER_COUNT\" |g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
  
      if [ "$GROUPER_TOMCAT_SHUTDOWN_PORT" != "8005" ]; then 
        sed -i "s|8005|$GROUPER_TOMCAT_SHUTDOWN_PORT|g" /opt/tomcat/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change shutdown port: sed -i \"s|8005|$GROUPER_TOMCAT_SHUTDOWN_PORT|g\" /opt/tomcat/conf/server.xml , result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
}

setupFilesTomcat_context() {

  if [ -f /opt/tomcat/conf/Catalina/localhost/grouper.xml ]
    then
      if [ "$GROUPER_ORIGFILE_GROUPER_XML" = "true" ]; then
        # ws only doesnt have cookies
        sed -i "s|__GROUPER_CONTEXT_COOKIES__|$GROUPER_CONTEXT_COOKIES|g" /opt/tomcat/conf/Catalina/localhost/grouper.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Replace context cookies in grouper.xml: sed -i \"s|__GROUPER_CONTEXT_COOKIES__|$GROUPER_CONTEXT_COOKIES|g\" /opt/tomcat/conf/Catalina/localhost/grouper.xml , result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        
        # setup context
        sed -i "s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g" /opt/tomcat/conf/Catalina/localhost/grouper.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Replace tomcat context in grouper.xml: sed -i \"s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g\" /opt/tomcat/conf/Catalina/localhost/grouper.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        
        # rename file if needed since that can matter with tomcat
        if [ "$GROUPER_TOMCAT_CONTEXT" != "grouper" ]
          then  
            mv -v /opt/tomcat/conf/Catalina/localhost/grouper.xml "/opt/tomcat/conf/Catalina/localhost/$GROUPER_TOMCAT_CONTEXT.xml"
            returnCode=$?
            echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) mv -v /opt/tomcat/conf/Catalina/localhost/grouper.xml \"/opt/tomcat/conf/Catalina/localhost/$GROUPER_TOMCAT_CONTEXT.xml\" , result: $returnCode"
            if [ $returnCode != 0 ]; then exit $returnCode; fi
        fi
      else
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) /opt/tomcat/conf/Catalina/localhost/grouper.xml is not the original file so will not be edited"
      fi    
  fi

}

setupFilesTomcat_authn() {

    if [ "$GROUPER_WS_TOMCAT_AUTHN" = "true" ] 
      then
      
        if [ "$GROUPER_ORIGFILE_WEBAPP_WEB_XML" = "true" ]; then
          cp /opt/tier-support/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml
          returnCode=$?
          echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) cp /opt/tier-support/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml , result: $returnCode"
          if [ $returnCode != 0 ]; then exit $returnCode; fi
        else
          echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) /opt/grouper/grouperWebapp/WEB-INF/web.xml is not the original file so will not be edited"
        fi

        sed -i 's|tomcatAuthentication="false"|tomcatAuthentication="true"|g' /opt/tomcat/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) sed -i 's|tomcatAuthentication=\"false\"|tomcatAuthentication=\"true\"|g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi

    fi

}

setupFilesTomcat_sessionTimeout() {

  if [ "$GROUPER_RUN_TOMCAT" = "true" ] && [ "$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES" != "-2" ]
    then
    sed -i "s|<session-timeout>30</session-timeout>|<session-timeout>$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES</session-timeout>|g" /opt/tomcat/conf/web.xml
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sessionTimeout) based on GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES, sed -i \"s|<session-timeout>30</session-timeout>|<session-timeout>$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES</session-timeout>|g\" /opt/tomcat/conf/web.xml , result=$returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi
}

setupFilesTomcat_ssl() {

  if [ "$GROUPER_WEBCLIENT_IS_SSL" = "false" ]
    then
    sed -i 's|secure="true"||g' /opt/tomcat/conf/server.xml
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ssl) based on GROUPER_WEBCLIENT_IS_SSL, sed -i 's|secure=\"true\"||g' /opt/tomcat/conf/server.xml , result=$returnCode"
    if [ $returnCode != 0 ] && [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]
      then
        exit $returnCode
    fi  
    sed -i 's|scheme="https"|scheme="http"|g' /opt/tomcat/conf/server.xml
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ssl) based on GROUPER_WEBCLIENT_IS_SSL, sed -i 's|scheme=\"https\"|scheme=\"http\"|g' /opt/tomcat/conf/server.xml , result=$returnCode"
    if [ $returnCode != 0 ] && [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]
      then
        exit $returnCode
    fi  
  fi
}

setupFilesTomcat_sslCertsAnchors() {

    # the container user (we arent sure who this is) should be able to update root certs
    # echo 'ALL ALL=NOPASSWD: /bin/update-ca-trust' | sudo EDITOR='tee -n' visudo
    # generate anchor:
    # openssl genrsa -out rootCAKey.pem 2048
    # openssl req -x509 -sha256 -new -nodes -key rootCAKey.pem -days 3650 -out rootCACert.pem

    
    if [ -n "$(ls -A /opt/grouper/certs/anchors/ 2>/dev/null)" ]; then
      # if root
      if [[ $EUID -eq 0 ]]; then
  
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) There are anchor certs in /opt/grouper/certs/anchors/ to process"
        
        /usr/bin/cp -v /opt/grouper/certs/anchors/* /etc/pki/ca-trust/source/anchors
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) /usr/bin/cp -v /opt/grouper/certs/anchors/* /etc/pki/ca-trust/source/anchors , result=$returnCode"
        if [ $returnCode != 0 ]
        then
          exit $returnCode
        fi  
        
        /bin/update-ca-trust
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) /bin/update-ca-trust , result=$returnCode"
        if [ $returnCode != 0 ]
        then
          exit $returnCode
        fi  
        
      else
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) There are anchor certs in /opt/grouper/certs/anchors/ to process but not running as root so run this in derived image: /usr/bin/cp -v /opt/grouper/certs/anchors/* /etc/pki/ca-trust/source/anchors; /bin/update-ca-trust"
      fi
      
      chmod u+w $JAVA_HOME/lib/security/cacerts
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) chmod u+w $JAVA_HOME/lib/security/cacerts , result=$returnCode"
      if [ $returnCode != 0 ]
      then
        exit $returnCode
      fi  
  
      for fileName in /opt/grouper/certs/anchors/*.pem; do
        [ -f "$fileName" ] || continue

        fileNameNoExtension=$(basename -- "$fileName")
        fileNameNoExtension="${fileNameNoExtension%.*}"
        /usr/lib/jvm/java/bin/keytool -import -trustcacerts -noprompt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -alias "$fileNameNoExtension" -file "$fileName"

        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) /usr/lib/jvm/java/bin/keytool -import -trustcacerts -noprompt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -alias \"$fileNameNoExtension\" -file \"$fileName\" , result=$returnCode"
        if [ $returnCode != 0 ]
        then
          exit $returnCode
        fi  
        
      done

      chmod u-w $JAVA_HOME/lib/security/cacerts
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) chmod u-w $JAVA_HOME/lib/security/cacerts , result=$returnCode"
      if [ $returnCode != 0 ]
      then
        exit $returnCode
      fi  
      
      
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) There are no anchor certs in /opt/grouper/certs/anchors/ to process"
    fi
    
}

setupFilesTomcat_sslCertsClient() {

    if [ -n "$(ls -A /opt/grouper/certs/client/*.pem 2>/dev/null)" ]; then

      chmod u+w $JAVA_HOME/lib/security/cacerts
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsClient) chmod u+w $JAVA_HOME/lib/security/cacerts , result=$returnCode"
      if [ $returnCode != 0 ]
      then
        exit $returnCode
      fi  
  
      for fileName in /opt/grouper/certs/client/*.pem; do
        [ -f "$fileName" ] || continue

        fileNameNoExtension=$(basename -- "$fileName")
        fileNameNoExtension="${fileNameNoExtension%.*}"
        /usr/lib/jvm/java/bin/keytool -import -noprompt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -alias "$fileNameNoExtension" -file "$fileName"

        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsClient) /usr/lib/jvm/java/bin/keytool -import -noprompt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -alias \"$fileNameNoExtension\" -file \"$fileName\" , result=$returnCode"
        if [ $returnCode != 0 ]
        then
          exit $returnCode
        fi  
        
      done

      chmod u-w $JAVA_HOME/lib/security/cacerts
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsClient) chmod u-w $JAVA_HOME/lib/security/cacerts , result=$returnCode"
      if [ $returnCode != 0 ]
      then
        exit $returnCode
      fi  
      
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsClient) There are no client certs in /opt/grouper/certs/client/*.pem to process"
    fi
    
}


setupFilesTomcat_unsetAll() {

  unset -f setupFilesTomcat
  unset -f setupFilesTomcat_authn
  unset -f setupFilesTomcat_context
  unset -f setupFilesTomcat_ports
  unset -f setupFilesTomcat_remoteCidrValve
  unset -f setupFilesTomcat_serverXml
  unset -f setupFilesTomcat_ssl
  unset -f setupFilesTomcat_sslCertsAnchors
  unset -f setupFilesTomcat_sslCertsClient
  unset -f setupFilesTomcat_unsetAll
  unset -f setupFilesTomcat_accessLogs
  unset -f setupFilesTomcat_sessionTimeout
  unset -f setupFilesTomcat_turnOnAjp

}

setupFilesTomcat_exportAll() {

  export -f setupFilesTomcat
  export -f setupFilesTomcat_authn
  export -f setupFilesTomcat_context
  export -f setupFilesTomcat_ports
  export -f setupFilesTomcat_remoteCidrValve
  export -f setupFilesTomcat_serverXml
  export -f setupFilesTomcat_ssl
  export -f setupFilesTomcat_sslCertsAnchors
  export -f setupFilesTomcat_sslCertsClient
  export -f setupFilesTomcat_unsetAll
  export -f setupFilesTomcat_accessLogs
  export -f setupFilesTomcat_sessionTimeout
  export -f setupFilesTomcat_turnOnAjp
}

# export everything
setupFilesTomcat_exportAll

