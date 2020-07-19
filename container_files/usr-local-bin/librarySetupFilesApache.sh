#!/bin/bash

setupFilesApache_indexes() {
    if [ "$GROUPER_APACHE_DIRECTORY_INDEXES" = "false" ]
      then
        # take out the directory indexes from the docroot
        cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.pre_noindexes
        patch /etc/httpd/conf/httpd.conf /etc/httpd/conf.d/httpd.conf.noindexes.patch
    fi
}

setupFilesApache_selfSignedCert() {
    if [ "$GROUPER_RUN_APACHE" = "true" ] && [ "$GROUPER_SELF_SIGNED_CERT" = "true" ] && [ "$GROUPER_USE_SSL" = "true" ]
       then
         cp -v /opt/tier-support/ssl-enabled.conf /etc/httpd/conf.d/
    fi
}

setupFilesApache_ssl() {
    if [ "$GROUPER_RUN_APACHE" = "true" ] && [ "$GROUPER_USE_SSL" != "true" ]
       then
       if [ -f /etc/httpd/conf.d/ssl.conf ]
         then
           mv -v /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.dontuse
       fi
       if [ -f /etc/httpd/conf.d/ssl-enabled.conf ]
         then
           mv -v /etc/httpd/conf.d/ssl-enabled.conf /etc/httpd/conf.d/ssl-enabled.conf.dontuse
       fi
    fi
}



setupFilesApache_serverName() {
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ ! -z "$GROUPER_APACHE_SERVER_NAME" ] && [ "$GROUPER_APACHE_SERVER_NAME" != "" ] && [ -f /etc/httpd/conf.d/grouper-www.conf ]
    then
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "ServerName $GROUPER_APACHE_SERVER_NAME" >> /etc/httpd/conf.d/grouper-www.conf
      echo "UseCanonicalName On" >> /etc/httpd/conf.d/grouper-www.conf
      echo >> /etc/httpd/conf.d/grouper-www.conf
  fi

}


setupFilesApache_logging() {
  if [ "$GROUPER_RUN_APACHE" = "true" ]
    then
      setupPipe_httpdLog
  fi

}

setupFilesApache_supervisor() {
  if [ "$GROUPER_RUN_APACHE" = "true" ]
    then
      cat /opt/tier-support/supervisord-httpd.conf >> /opt/tier-support/supervisord.conf
  fi

}

setupFilesApache_ports() {

  # filter the ssl config for ssl port
  
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ -f /etc/httpd/conf.d/ssl-enabled.conf ]
    then
      sed -i "s|__GROUPER_APACHE_SSL_PORT__|$GROUPER_APACHE_SSL_PORT|g" /etc/httpd/conf.d/ssl-enabled.conf
  fi
  
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ "$GROUPER_APACHE_NONSSL_PORT" != "80" ]
    then
      sed -i "s|Listen 80|Listen $GROUPER_APACHE_NONSSL_PORT|g" /etc/httpd/conf/httpd.conf
  fi

}

setupFilesApache() {
  setupFilesApache_logging
  setupFilesApache_supervisor
  setupFilesApache_selfSignedCert
  setupFilesApache_ports
  setupFilesApache_ssl
  setupFilesApache_serverName
  setupFilesApache_indexes
}

setupFilesApache_unsetAll() {
  unset -f setupFilesApache
  unset -f setupFilesApache_indexes
  unset -f setupFilesApache_logging
  unset -f setupFilesApache_ports
  unset -f setupFilesApache_selfSignedCert
  unset -f setupFilesApache_ssl
  unset -f setupFilesApache_supervisor
  unset -f setupFilesApache_unsetAll
  unset -f setupFilesApache_serverName
}

setupFilesApache_exportAll() {
  export -f setupFilesApache
  export -f setupFilesApache_indexes
  export -f setupFilesApache_logging
  export -f setupFilesApache_ports
  export -f setupFilesApache_selfSignedCert
  export -f setupFilesApache_ssl
  export -f setupFilesApache_supervisor
  export -f setupFilesApache_unsetAll
  export -f setupFilesApache_serverName
}

# export everything
setupFilesApache_exportAll


