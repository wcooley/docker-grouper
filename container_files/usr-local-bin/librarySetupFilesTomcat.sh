#!/bin/bash

setupFilesTomcat() {
  setupFilesTomcat_logging
  setupFilesTomcat_supervisor
  setupFilesTomcat_authn
  setupFilesTomcat_context
}

setupFilesTomcat_context() {

  if [ -f /opt/tomee/conf/Catalina/localhost/grouper.xml ]
    then
      # ws only and scim only dont have cookies
      if [ "$GROUPER_CONTEXT_COOKIES" = "false" ]
        then
           sed -i "s|__GROUPER_CONTEXT_COOKIES__|cookies="false"|g" /opt/tomee/conf/Catalina/localhost/grouper.xml
        else
           sed -i "s|__GROUPER_CONTEXT_COOKIES__||g" /opt/tomee/conf/Catalina/localhost/grouper.xml
      fi
      
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
  unset -f setupFilesTomcat_supervisor
  unset -f setupFilesTomcat_unsetAll

}

setupFilesTomcat_exportAll() {

  export -f setupFilesTomcat
  export -f setupFilesTomcat_authn
  export -f setupFilesTomcat_context
  export -f setupFilesTomcat_logging
  export -f setupFilesTomcat_supervisor
  export -f setupFilesTomcat_unsetAll

}

# export everything
setupFilesTomcat_exportAll

