#!/bin/bash

setupFilesTomcat() {
  setupFilesTomcat_logging
  setupFilesTomcat_loggingSlf4j
  setupFilesTomcat_supervisor
  setupFilesTomcat_authn
  setupFilesTomcat_context
  setupFilesTomcat_ports
  setupFilesTomcat_accessLogs
}

setupFilesTomcat_accessLogs() {

  if [ "$GROUPER_TOMCAT_LOG_ACCESS" != "true" ]; then
  
    patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.nologging.patch
  
  fi
}

setupFilesTomcat_ports() {

    if [ "$GROUPER_TOMCAT_HTTP_PORT" != "8080" ]; then 
      sed -i "s|8080|$GROUPER_TOMCAT_HTTP_PORT|g" /opt/tomee/conf/server.xml
    fi
    
    if [ "$GROUPER_TOMCAT_AJP_PORT" != "8009" ]; then 
      sed -i "s|8009|$GROUPER_TOMCAT_AJP_PORT|g" /opt/tomee/conf/server.xml
    fi

    if [ "$GROUPER_TOMCAT_SHUTDOWN_PORT" != "8005" ]; then 
      sed -i "s|8005|$GROUPER_TOMCAT_SHUTDOWN_PORT|g" /opt/tomee/conf/server.xml
    fi
}

setupFilesTomcat_context() {

  if [ -f /opt/tomee/conf/Catalina/localhost/grouper.xml ]
    then
      # ws only and scim only dont have cookies
      sed -i "s|__GROUPER_CONTEXT_COOKIES__|$GROUPER_CONTEXT_COOKIES|g" /opt/tomee/conf/Catalina/localhost/grouper.xml
      
      # setup context
      sed -i "s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g" /opt/tomee/conf/Catalina/localhost/grouper.xml
      
      # rename file if needed since that can matter with tomcat
      if [ "$GROUPER_TOMCAT_CONTEXT" != "grouper" ]
        then  
          mv /opt/tomee/conf/Catalina/localhost/grouper.xml "/opt/tomee/conf/Catalina/localhost/$GROUPER_TOMCAT_CONTEXT.xml"
      fi
    
  fi

  # setup the apache linkage to tomcat  
  if [ -f /etc/httpd/conf.d/grouper-www.conf ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]
    then
      sed -i "s|__GROUPER_APACHE_AJP_TIMEOUT_SECONDS__|$GROUPER_APACHE_AJP_TIMEOUT_SECONDS|g" /etc/httpd/conf.d/grouper-www.conf
      sed -i "s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      sed -i "s|__GROUPER_URL_CONTEXT__|$GROUPER_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      sed -i "s|__GROUPERWS_URL_CONTEXT__|$GROUPERWS_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      sed -i "s|__GROUPERSCIM_URL_CONTEXT__|$GROUPERSCIM_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      sed -i "s|__GROUPER_PROXY_PASS__|$GROUPER_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      sed -i "s|__GROUPER_PROXY_PASS__|$GROUPER_PROXY_PASS|g" /etc/httpd/conf.d/ssl-enabled.conf
      sed -i "s|__GROUPERSCIM_PROXY_PASS__|$GROUPERSCIM_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      sed -i "s|__GROUPERWS_PROXY_PASS__|$GROUPERWS_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      if [ "$GROUPER_TOMCAT_AJP_PORT" != "8009" ]; then 
        sed -i "s|:8009/|:$GROUPER_TOMCAT_AJP_PORT/|g" /etc/httpd/conf.d/grouper-www.conf
      fi
      
  fi

}

setupFilesTomcat_authn() {

    if [ "$GROUPER_WS_TOMCAT_AUTHN" = "true" ]
      then
        cp /opt/grouper/grouperWebapp/WEB-INF/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml
        cp /opt/grouper/grouperWebapp/WEB-INF/server.wsTomcatAuthn.xml /opt/tomee/conf/server.xml
    fi

}

setupFilesTomcat_logging() {

  if [ "$GROUPER_RUN_TOMEE" = "true" ] && [ "$GROUPER_LOG_TO_HOST" != "true" ]
    then
      setupPipe_tomcatLog
  fi

}

setupFilesTomcat_loggingSlf4j() {

  rm -v /opt/tomee/lib/slf4j-api*.jar
  rm -v /opt/tomee/lib/slf4j-jdk*.jar
  rm -v /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-jdk*.jar
  cp -v /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*.jar /opt/tomee/lib
  cp -v /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-log4j*.jar /opt/tomee/lib

}

setupFilesTomcat_supervisor() {

  if [ "$GROUPER_RUN_TOMEE" = "true" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]
    then
      cat /opt/tier-support/supervisord-tomee.conf >> /opt/tier-support/supervisord.conf
  fi

}


setupFilesTomcat_unsetAll() {

  unset -f setupFilesTomcat
  unset -f setupFilesTomcat_authn
  unset -f setupFilesTomcat_context
  unset -f setupFilesTomcat_logging
  unset -f setupFilesTomcat_ports
  unset -f setupFilesTomcat_supervisor
  unset -f setupFilesTomcat_unsetAll
  unset -f setupFilesTomcat_accessLogs
  unset -f setupFilesTomcat_loggingSlf4j

}

setupFilesTomcat_exportAll() {

  export -f setupFilesTomcat
  export -f setupFilesTomcat_authn
  export -f setupFilesTomcat_context
  export -f setupFilesTomcat_logging
  export -f setupFilesTomcat_ports
  export -f setupFilesTomcat_supervisor
  export -f setupFilesTomcat_unsetAll
  export -f setupFilesTomcat_accessLogs
  export -f setupFilesTomcat_loggingSlf4j
}

# export everything
setupFilesTomcat_exportAll

