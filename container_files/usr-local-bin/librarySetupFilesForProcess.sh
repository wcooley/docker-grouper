#!/bin/bash

setupFilesForProcess_hsqldb() {
  # construct the supervisord file based on FLAGS passed in or what was in CMD

  if [ "$GROUPER_RUN_HSQLDB" = "true" ]
    then
      setupPipe_hsqldbLog
      cat /opt/tier-support/supervisord-hsqldb.conf >> /opt/tier-support/supervisord.conf
  fi

}

setupFilesForProcess_hsqldbVersions() {

    # tomee hsql must match the grouper one, and the version cannot be 2.3.2 since it is query bugs (unit tests fail)
    rm -v /opt/tomee/lib/hsqldb-*.jar
    cp -v /opt/grouper/grouperWebapp/WEB-INF/lib/hsqldb-*.jar /opt/tomee/lib/

}

setupFilesForProcess_supervisor() {

  if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then
    # clear out existing supervisord config
    cat /opt/tier-support/supervisord-base.conf > /opt/tier-support/supervisord.conf
  fi
}

setupFilesForProcess() {

  setupFilesForProcess_hsqldbVersions

  setupFilesForProcess_hsqldb

  setupFilesForProcess_shib
  
}

setupFilesForProcess_supervisorFinal() {

  if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then
    if [ "$GROUPER_RUN_PROCESSES_AS_USERS" = "true" ]
      then
        # let these lines live
        sed -i "s|__GROUPER_RUN_PROCESSES_AS_USERS__||g" /opt/tier-support/supervisord.conf
      else
        # comment out these lines
        sed -i "s|__GROUPER_RUN_PROCESSES_AS_USERS__|;|g" /opt/tier-support/supervisord.conf
    fi
  fi
}

setupFilesForProcess_shib() {

  if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then
    if [ -f /etc/httpd/conf.d/shib.conf ]
      then
        mv -v /etc/httpd/conf.d/shib.conf /etc/httpd/conf.d/shib.conf.dontuse
    fi
    
    if [ "$GROUPER_RUN_SHIB_SP" = "true" ]
      then
        if [ "$GROUPER_SHIB_LOG_USE_PIPE" = "true" ]
          then
            setupPipe_shibdLog
        fi
        export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH
        cat /opt/tier-support/supervisord-shibsp.conf >> /opt/tier-support/supervisord.conf
        cp -v /opt/tier-support/httpd-shib.conf /etc/httpd/conf.d/
        mv -v /etc/httpd/conf.d/shib.conf.dontuse /etc/httpd/conf.d/shib.conf
    fi
  fi

}

setupFilesForProcess_unsetAll() {

  unset -f setupFilesForProcess
  unset -f setupFilesForProcess_hsqldb
  unset -f setupFilesForProcess_hsqldbVersions
  unset -f setupFilesForProcess_shib
  unset -f setupFilesForProcess_supervisor
  unset -f setupFilesForProcess_supervisorFinal
  unset -f setupFilesForProcess_unsetAll
  
}

setupFilesForProcess_exportAll() {

  export -f setupFilesForProcess
  export -f setupFilesForProcess_hsqldb
  export -f setupFilesForProcess_hsqldbVersions
  export -f setupFilesForProcess_shib
  export -f setupFilesForProcess_supervisor
  export -f setupFilesForProcess_supervisorFinal
  export -f setupFilesForProcess_unsetAll
}

# export everything
setupFilesForProcess_exportAll
