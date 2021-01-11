#!/bin/bash

setupFilesTomcat() {
  setupFilesTomcat_loggingSlf4j
  setupFilesTomcat_turnOnAjp
  setupFilesTomcat_supervisor
  setupFilesTomcat_authn
  setupFilesTomcat_context
  setupFilesTomcat_ports
  setupFilesTomcat_accessLogs
  setupFilesTomcat_sessionTimeout
}



setupFilesTomcat_turnOnAjp() {

  if [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]; then
    cp /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.currentOriginalInContainer
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) cp /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.currentOriginalInContainer , result: $?"
    patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.turnOnAjp.patch
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) Patch server.xml to turn on ajp, result: $?"
  else
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) /opt/tomee/conf/server.xml is not the original file so will not be edited"
  fi
  
}

setupFilesTomcat_accessLogs() {
  
  if [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]; then
    if [ "$GROUPER_TOMCAT_LOG_ACCESS" = "true" ]; then
    
        # this patch happens after the last patch
        patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.loggingpipe.patch
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) Patch server.xml to log access, result: $?"
      
    else  
  
      patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.nologging.patch
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) Patch server.xml to not log access, result: $?"
      
    fi
  else
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) /opt/tomee/conf/server.xml is not the original file so will not be edited"
  fi
  
}

setupFilesTomcat_ports() {

      if [ "$GROUPER_TOMCAT_HTTP_PORT" != "8080" ]; then 
        sed -i "s|8080|$GROUPER_TOMCAT_HTTP_PORT|g" /opt/tomee/conf/server.xml
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change http port, result: $?"
      fi
      
      if [ "$GROUPER_TOMCAT_AJP_PORT" != "8009" ]; then 
        sed -i "s|8009|$GROUPER_TOMCAT_AJP_PORT|g" /opt/tomee/conf/server.xml
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change ajp port, result: $?"
      fi
  
      if [ "$GROUPER_TOMCAT_SHUTDOWN_PORT" != "8005" ]; then 
        sed -i "s|8005|$GROUPER_TOMCAT_SHUTDOWN_PORT|g" /opt/tomee/conf/server.xml
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change shutdown port, result: $?"
      fi
}

setupFilesTomcat_context() {

  if [ -f /opt/tomee/conf/Catalina/localhost/grouper.xml ]
    then
      if [ "$GROUPER_ORIGFILE_GROUPER_XML" = "true" ]; then
        # ws only and scim only dont have cookies
        sed -i "s|__GROUPER_CONTEXT_COOKIES__|$GROUPER_CONTEXT_COOKIES|g" /opt/tomee/conf/Catalina/localhost/grouper.xml
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Replace context cookies in grouper.xml, result: $?"
        
        # setup context
        sed -i "s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g" /opt/tomee/conf/Catalina/localhost/grouper.xml
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Replace tomcat context in grouper.xml, result: $?"
        
        # rename file if needed since that can matter with tomcat
        if [ "$GROUPER_TOMCAT_CONTEXT" != "grouper" ]
          then  
            mv -v /opt/tomee/conf/Catalina/localhost/grouper.xml "/opt/tomee/conf/Catalina/localhost/$GROUPER_TOMCAT_CONTEXT.xml"
            echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) mv -v /opt/tomee/conf/Catalina/localhost/grouper.xml /opt/tomee/conf/Catalina/localhost/$GROUPER_TOMCAT_CONTEXT.xml , result: $?"
        fi
      else
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) /opt/tomee/conf/Catalina/localhost/grouper.xml is not the original file so will not be edited"
      fi    
  fi

  # setup the apache linkage to tomcat  
  if [ -f /etc/httpd/conf.d/grouper-www.conf ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]
    then
      sed -i "s|__GROUPER_APACHE_AJP_TIMEOUT_SECONDS__|$GROUPER_APACHE_AJP_TIMEOUT_SECONDS|g" /etc/httpd/conf.d/grouper-www.conf
      results="$?"
      sed -i "s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPER_URL_CONTEXT__|$GROUPER_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPERWS_URL_CONTEXT__|$GROUPERWS_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPERSCIM_URL_CONTEXT__|$GROUPERSCIM_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPER_PROXY_PASS__|$GROUPER_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      if [ -f /etc/httpd/conf.d/ssl-enabled.conf ]; then
        sed -i "s|__GROUPER_PROXY_PASS__|$GROUPER_PROXY_PASS|g" /etc/httpd/conf.d/ssl-enabled.conf
        results="$results $?"
      fi
      sed -i "s|__GROUPERSCIM_PROXY_PASS__|$GROUPERSCIM_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPERWS_PROXY_PASS__|$GROUPERWS_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      if [ "$GROUPER_TOMCAT_AJP_PORT" != "8009" ]; then 
        sed -i "s|:8009/|:$GROUPER_TOMCAT_AJP_PORT/|g" /etc/httpd/conf.d/grouper-www.conf
        results="$results $?"
      fi
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Set contexts in grouper-www.conf and other files, results: $results"
  fi

}

setupFilesTomcat_authn() {

    if [ "$GROUPER_WS_TOMCAT_AUTHN" = "true" ] 
      then
      
        if [ "$GROUPER_ORIGFILE_WEBAPP_WEB_XML" = "true" ]; then
          cp /opt/tier-support/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml
          echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) cp /opt/tier-support/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml , result: $?"
        else
          echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) /opt/grouper/grouperWebapp/WEB-INF/web.xml is not the original file so will not be edited"
        fi

        sed -i 's|tomcatAuthentication="false"|tomcatAuthentication="true"|g' /opt/tomee/conf/server.xml
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) sed -i 's|tomcatAuthentication=''false''|tomcatAuthentication=''true''|g' /opt/tomee/conf/server.xml, result: $?"

    fi

}

setupFilesTomcat_loggingSlf4j() {

  rm -f /opt/tomee/lib/slf4j-api*.jar
  echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_loggingSlf4j) rm -f /opt/tomee/lib/slf4j-api*.jar , result: $?"
  rm -f /opt/tomee/lib/slf4j-jdk*.jar
  echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_loggingSlf4j) rm -f /opt/tomee/lib/slf4j-jdk*.jar , result: $?"
  cp /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*.jar /opt/tomee/lib
  echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_loggingSlf4j) cp /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*.jar /opt/tomee/lib , result: $?"
  # tomee uses the jdk one
  cp /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-jdk*.jar /opt/tomee/lib
  echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_loggingSlf4j) cp /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-jdk*.jar /opt/tomee/lib , result: $?"
  # grouper uses the log4j one
  rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-jdk*.jar
  echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_loggingSlf4j) rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-jdk*.jar , result: $?"

}

setupFilesTomcat_supervisor() {

  if [ "$GROUPER_RUN_TOMEE" = "true" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]
    then
      cat /opt/tier-support/supervisord-tomee.conf >> /opt/tier-support/supervisord.conf
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_supervisor) Append supervisord-tomee.conf to supervisord.conf"
  fi

}

setupFilesTomcat_sessionTimeout() {

  if [ "$GROUPER_RUN_TOMEE" = "true" ] && [ "$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES" != "-2" ]
    then
    sed -i "s|<session-timeout>30</session-timeout>|<session-timeout>$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES</session-timeout>|g" /opt/tomee/conf/web.xml
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sessionTimeout) based on GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES, sed -i ''s|<session-timeout>30</session-timeout>|<session-timeout>$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES</session-timeout>|g'' /opt/tomee/conf/web.xml , result=$?"
  fi
}

setupFilesTomcat_unsetAll() {

  unset -f setupFilesTomcat
  unset -f setupFilesTomcat_authn
  unset -f setupFilesTomcat_context
  unset -f setupFilesTomcat_ports
  unset -f setupFilesTomcat_supervisor
  unset -f setupFilesTomcat_unsetAll
  unset -f setupFilesTomcat_accessLogs
  unset -f setupFilesTomcat_loggingSlf4j
  unset -f setupFilesTomcat_sessionTimeout
  unset -f setupFilesTomcat_turnOnAjp

}

setupFilesTomcat_exportAll() {

  export -f setupFilesTomcat
  export -f setupFilesTomcat_authn
  export -f setupFilesTomcat_context
  export -f setupFilesTomcat_ports
  export -f setupFilesTomcat_supervisor
  export -f setupFilesTomcat_unsetAll
  export -f setupFilesTomcat_accessLogs
  export -f setupFilesTomcat_loggingSlf4j
  export -f setupFilesTomcat_sessionTimeout
  export -f setupFilesTomcat_turnOnAjp
}

# export everything
setupFilesTomcat_exportAll

