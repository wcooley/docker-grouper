#!/bin/bash

setupFilesTomcat() {
  setupFilesTomcat_serverXml
  setupFilesTomcat_remoteCidrValve
  setupFilesTomcat_remoteIpValve
  setupFilesTomcat_turnOnAjp
  setupFilesTomcat_turnOnHttp
  setupFilesTomcat_turnOnHttps
  setupFilesTomcat_authn
  setupFilesTomcat_context
  setupFilesTomcat_ports
  setupFilesTomcat_accessLogs
  setupFilesTomcat_sessionTimeout
  setupFilesTomcat_ssl
  setupFilesTomcat_sslCertsAnchors
  setupFilesTomcat_sslCertsClient
}

setupFilesTomcat_remoteIpValve() {

  if [ "$GROUPER_TOMCAT_REMOTE_IP_VALVE" = "true" ]; then 
    if [ $(grep -c '<!--GROUPER_TOMCAT_REMOTE_IP_VALVE-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      # <Valve className="org.apache.catalina.valves.RemoteIpValve" internalProxies="192\.168\.0\.10|192\.168\.0\.11" remoteIpHeader="x-forwarded-for" proxiesHeader="x-forwarded-by" trustedProxies="proxy1|proxy2" />
      # <Valve className="org.apache.catalina.valves.RemoteIpValve" __GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES__ __GROUPER_TOMCAT_REMOTE_IP_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES__ __GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE__ __GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT__ __GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT__ />
    
      sed -i 's|<!--GROUPER_TOMCAT_REMOTE_IP_VALVE-->|<Valve className="org.apache.catalina.valves.RemoteIpValve" __GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES__ __GROUPER_TOMCAT_REMOTE_IP_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES__ __GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE__ __GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT__ __GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT__ />|g' /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) Apply remote IP valve: sed -i 's|<!--GROUPER_TOMCAT_REMOTE_IP_VALVE-->|<Valve className="org.apache.catalina.valves.RemoteIpValve" __GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES__ __GROUPER_TOMCAT_REMOTE_IP_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES__ __GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER__ __GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE__ __GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT__ __GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT__ />|g' /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES__|internalProxies=\"$GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES__|internalProxies=\\\"$GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_INTERNAL_PROXIES__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_HEADER" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_HEADER__|remoteIpHeader=\"$GROUPER_TOMCAT_REMOTE_IP_HEADER\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_HEADER__|remoteIpHeader=\\\"$GROUPER_TOMCAT_REMOTE_IP_HEADER\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_HEADER__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_HEADER__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER__|proxiesHeader=\"$GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER__|proxiesHeader=\\\"$GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_PROXIES_HEADER__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES__|trustedProxies=\"$GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES__|trustedProxies=\\\"$GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_TRUSTED_PROXIES__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
        
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER__|protocolHeader=\"$GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER__|protocolHeader=\\\"$GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
        
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE__|protocolHeaderHttpsValue=\"$GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE__|protocolHeaderHttpsValue=\\\"$GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_PROTOCOL_HEADER_HTTPS_VALUE__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
        
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT__|httpServerPort=\"$GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT__|httpServerPort=\\\"$GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_HTTP_SERVER_PORT__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
        
      if [ ! -z "$GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT" ]; then 
        sed -i "s|__GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT__|httpsServerPort=\"$GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT\"|g" /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i \"s|__GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT__|httpsServerPort=\\\"$GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT\\\"|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT__||g' /opt/tomcat/conf/server.xml 
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) sed -i 's|__GROUPER_TOMCAT_REMOTE_IP_HTTPS_SERVER_PORT__||g' /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteIpValve) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_GROUPER_TOMCAT_REMOTE_IP_VALVE--> so will not have remote IP valve applied"
    fi
    
  fi

}

setupFilesTomcat_remoteCidrValve() {

  if [ ! -z "$GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW" ]; then 
    if [ $(grep -c '<!--GROUPER_TOMCAT_REMOTE_CIDR_VALVE-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      sed -i 's|<!--GROUPER_TOMCAT_REMOTE_CIDR_VALVE-->|<Valve className="org.apache.catalina.valves.RemoteCIDRValve" allow="__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__" usePeerAddress="true" />|g' /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteCidrValve) Apply remote CIDR valve: sed -i 's|<!--GROUPER_TOMCAT_REMOTE_CIDR_VALVE-->|<Valve className=\"org.apache.catalina.valves.RemoteCIDRValve\" allow=\"__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__\"  usePeerAddress=\"true\" />|g' /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      sed -i "s|__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__|$GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW|g" /opt/tomcat/conf/server.xml
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteCidrValve) Apply remote CIDR valve value: sed -i \"s|__GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW__|$GROUPER_TOMCAT_REMOTE_CIDR_VALVE_ALLOW|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_remoteCidrValve) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_TOMCAT_REMOTE_CIDR_VALVE--> so will not have remote CIDR valve applied"
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

  if [ "$GROUPER_TOMCAT_AJP_PORT" != "-1" ]; then

    if [ $(grep -c '<!--GROUPER_AJP_CONNECTOR-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      sed -i 's|<!--GROUPER_AJP_CONNECTOR-->|<Connector address="0.0.0.0" secretRequired="false" secure="true"  scheme="https"  URIEncoding="UTF-8"  tomcatAuthentication="false"  port="8009" protocol="AJP/1.3" redirectPort="8443" maxParameterCount="10000" />|g' /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) Apply AJP: sed -i 's|<!--GROUPER_AJP_CONNECTOR-->|<Connector address=\"0.0.0.0\" secretRequired=\"false\" secure=\"true\"  scheme=\"https\"  URIEncoding=\"UTF-8\"  tomcatAuthentication=\"false\"  port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" maxParameterCount=\"10000\" />|g' /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_AJP_CONNECTOR--> so will not have AJP connector applied"
    fi
  else 
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) GROUPER_TOMCAT_AJP_PORT is set to -1, so will not have AJP connector applied"
  fi  
}

  
  

setupFilesTomcat_turnOnHttp() {

  if [ "$GROUPER_TOMCAT_HTTP_PORT" != "-1" ]; then

    if [ $(grep -c '<!--GROUPER_HTTP_CONNECTOR-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      sed -i 's|<!--GROUPER_HTTP_CONNECTOR-->|<Connector address="0.0.0.0" secure="true" scheme="https" URIEncoding="UTF-8" tomcatAuthentication="false" port="8080" protocol="HTTP/1.1" redirectPort="8443" maxParameterCount="10000" />|g' /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttp) Apply HTTP: sed -i 's|<!--GROUPER_HTTP_CONNECTOR-->|<Connector address=\"0.0.0.0\" secure=\"true\" scheme=\"https\" URIEncoding=\"UTF-8\" tomcatAuthentication=\"false\" port=\"8080\" protocol=\"HTTP/1.1\" redirectPort=\"8443\" maxParameterCount=\"10000\" />|g' /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttp) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_HTTP_CONNECTOR--> so will not have HTTP connector applied"
    fi
  else 
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttp) GROUPER_TOMCAT_HTTP_PORT is set to -1, so will not have HTTP connector applied"
  fi  
}

setupFilesTomcat_turnOnHttps() {

  if [ "$GROUPER_TOMCAT_HTTPS_PORT" != "-1" ]; then

    if [ $(grep -c '<!--GROUPER_HTTPS_CONNECTOR-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      sed -i "s|<\!--GROUPER_HTTPS_CONNECTOR-->|<Connector address=\"0.0.0.0\" secure=\"true\" scheme=\"https\" URIEncoding=\"UTF-8\" compression=\"on\" tomcatAuthentication=\"false\" port=\"8443\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\" maxParameterCount=\"10000\" SSLEnabled=\"true\" ><SSLHostConfig protocols=\"TLSv1.2\"><Certificate certificateFile=\"$GROUPER_SSL_CERT_FILE\" certificateKeyFile=\"$GROUPER_SSL_KEY_FILE\" __GROUPER_SSL_CHAIN_FILE__ /></SSLHostConfig></Connector>|g" /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttps) Apply HTTPS: sed -i \"s|<\\!--GROUPER_HTTPS_CONNECTOR-->|<Connector address=\\\"0.0.0.0\\\" secure=\\\"true\\\" scheme=\\\"https\\\" URIEncoding=\\\"UTF-8\\\" compression=\\\"on\\\" tomcatAuthentication=\\\"false\\\" port=\\\"8443\\\" protocol=\\\"org.apache.coyote.http11.Http11NioProtocol\\\" maxParameterCount=\\\"10000\\\" keyAlias=\\\"$GROUPER_TOMCAT_HTTPS_ALIAS\\\" SSLEnabled=\\\"true\\\"  ><SSLHostConfig protocols=\\\"TLSv1.2\\\"><Certificate certificateFile=\\\"$GROUPER_SSL_CERT_FILE\\\" certificateKeyFile=\\\"$GROUPER_SSL_KEY_FILE\\\" __GROUPER_SSL_CHAIN_FILE__ /></SSLHostConfig></Connector>|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttps) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_HTTPS_CONNECTOR--> so will not have HTTPS connector applied"
    fi
    
    if [ "$GROUPER_SSL_USE_CHAIN_FILE" = "true" ]; then

      sed -i "s|__GROUPER_SSL_CHAIN_FILE__|certificateChainFile=\"$GROUPER_SSL_CHAIN_FILE\"|g" /opt/tomcat/conf/server.xml
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttps) Setting chain: sed -i \"s|__GROUPER_SSL_CHAIN_FILE__|certificateChainFile=\\\"$GROUPER_SSL_CHAIN_FILE\\\"|g\" /opt/tomcat/conf/server.xml , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
  
    else
      sed -i "s|__GROUPER_SSL_CHAIN_FILE__||g" /opt/tomcat/conf/server.xml
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttps) No chain setting: sed -i \"s|__GROUPER_SSL_CHAIN_FILE__||g\" /opt/tomcat/conf/server.xml , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  
    fi

    
  else 
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnHttps) GROUPER_TOMCAT_HTTPS_PORT is set to -1, so will not have AJP connector applied"
  fi  
}

setupFilesTomcat_accessLogs() {
  
  if [ "$GROUPER_TOMCAT_LOG_ACCESS" = "true" ]; then
    if [ $(grep -c '<!--GROUPER_LOGGING_VALVE-->' /opt/tomcat/conf/server.xml) -ge 1 ]; then
    
      sed -i "s|<!--GROUPER_LOGGING_VALVE-->|<Valve className=\"org.apache.catalina.valves.AccessLogValve\" requestAttributesEnabled=\"$GROUPER_TOMCAT_REMOTE_IP_VALVE\" directory=\"$GROUPER_TOMCAT_LOG_ACCESS_DIRECTORY\" prefix=\"tomcat_access_log\" rotatable=\"false\" pattern=\"%h %l %u %t \&quot;%r\&quot; %s %b\" />|g" /opt/tomcat/conf/server.xml 
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) Apply access logs: sed -i \"s|<!--GROUPER_LOGGING_VALVE-->|<Valve className=\\\"org.apache.catalina.valves.AccessLogValve\\\" directory=\\\"GROUPER_TOMCAT_LOG_ACCESS_DIRECTORY\\\" prefix=\\\"tomcat_access_log\\\" rotatable=\\\"false\\\" pattern=\\\"%h %l %u %t &quot;%r&quot; %s %b\\\" />|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi

    else
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) /opt/tomcat/conf/server.xml does not contain <!--GROUPER_LOGGING_VALVE--> so will not have access logs applied"
    fi
  fi
  
}

setupFilesTomcat_ports() {

      if [ "$GROUPER_TOMCAT_HTTP_PORT" != "8080" ] && [ "$GROUPER_TOMCAT_HTTP_PORT" != "-1" ] ; then 
        sed -i "s|8080|$GROUPER_TOMCAT_HTTP_PORT|g" /opt/tomcat/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change http port: sed -i \"s|8080|$GROUPER_TOMCAT_HTTP_PORT|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ "$GROUPER_TOMCAT_HTTPS_PORT" != "8443" ]; then 
        sed -i "s|8443|$GROUPER_TOMCAT_HTTPS_PORT|g" /opt/tomcat/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change https port: sed -i \"s|8443|$GROUPER_TOMCAT_HTTPS_PORT|g\" /opt/tomcat/conf/server.xml, result: $returnCode"
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
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) There are anchor certs in /opt/grouper/certs/anchors/ to process but not running as root so you might need to run this in derived image: /usr/bin/cp -v /opt/grouper/certs/anchors/* /etc/pki/ca-trust/source/anchors; /bin/update-ca-trust"
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
        /usr/lib/jvm/java/bin/keytool -import -trustcacerts -noprompt -cacerts -storepass changeit -alias "$fileNameNoExtension" -file "$fileName"

        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsAnchors) /usr/lib/jvm/java/bin/keytool -import -trustcacerts -noprompt -cacerts -storepass changeit -alias \"$fileNameNoExtension\" -file \"$fileName\" , result=$returnCode"
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
        /usr/lib/jvm/java/bin/keytool -import -noprompt -cacerts -storepass changeit -alias "$fileNameNoExtension" -file "$fileName"

        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sslCertsClient) /usr/lib/jvm/java/bin/keytool -import -noprompt -cacerts -storepass changeit -alias \"$fileNameNoExtension\" -file \"$fileName\" , result=$returnCode"
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
  unset -f setupFilesTomcat_remoteIpValve
  unset -f setupFilesTomcat_serverXml
  unset -f setupFilesTomcat_ssl
  unset -f setupFilesTomcat_sslCertsAnchors
  unset -f setupFilesTomcat_sslCertsClient
  unset -f setupFilesTomcat_unsetAll
  unset -f setupFilesTomcat_accessLogs
  unset -f setupFilesTomcat_sessionTimeout
  unset -f setupFilesTomcat_turnOnAjp
  unset -f setupFilesTomcat_turnOnHttp
  unset -f setupFilesTomcat_turnOnHttps

}

setupFilesTomcat_exportAll() {

  export -f setupFilesTomcat
  export -f setupFilesTomcat_authn
  export -f setupFilesTomcat_context
  export -f setupFilesTomcat_ports
  export -f setupFilesTomcat_remoteCidrValve
  export -f setupFilesTomcat_remoteIpValve
  export -f setupFilesTomcat_serverXml
  export -f setupFilesTomcat_ssl
  export -f setupFilesTomcat_sslCertsAnchors
  export -f setupFilesTomcat_sslCertsClient
  export -f setupFilesTomcat_unsetAll
  export -f setupFilesTomcat_accessLogs
  export -f setupFilesTomcat_sessionTimeout
  export -f setupFilesTomcat_turnOnAjp
  export -f setupFilesTomcat_turnOnHttp
  export -f setupFilesTomcat_turnOnHttps
  
}

# export everything
setupFilesTomcat_exportAll

