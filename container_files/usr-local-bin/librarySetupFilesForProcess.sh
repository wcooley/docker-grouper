#!/bin/bash

setupFilesForProcess_hsqldb() {
  # construct the supervisord file based on FLAGS passed in or what was in CMD
  if [ "$GROUPER_RUN_HSQLDB" = "true" ]
    then
      cat /opt/tier-support/supervisord-hsqldb.conf >> /opt/tier-support/supervisord.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_hsqldb) cat /opt/tier-support/supervisord-hsqldb.conf >> /opt/tier-support/supervisord.conf , result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi
}

setupFilesForProcess_hsqldbVersions() {

    # tomee hsql must match the grouper one, and the version cannot be 2.3.2 since it is query bugs (unit tests fail)
    rm -f /opt/tomee/lib/hsqldb-*.jar
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_hsqldbVersions) rm -f /opt/tomee/lib/hsqldb-*.jar , result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
    cp /opt/grouper/grouperWebapp/WEB-INF/lib/hsqldb-*.jar /opt/tomee/lib/
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_hsqldbVersions) cp /opt/grouper/grouperWebapp/WEB-INF/lib/hsqldb-*.jar /opt/tomee/lib/ , result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
}

setupFilesForProcess_supervisor() {

  if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then
    # clear out existing supervisord config
    cat /opt/tier-support/supervisord-base.conf > /opt/tier-support/supervisord.conf
    echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_supervisor) Clear out supervisor.conf , result: $returnCode"
    returnCode=$?
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
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_supervisorFinal) Running processes as users in supervisord.conf, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        # comment out these lines
        sed -i "s|__GROUPER_RUN_PROCESSES_AS_USERS__|;|g" /opt/tier-support/supervisord.conf
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_supervisorFinal) Commenting out running processes as users in supervisord.conf, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
    fi
  fi
}

setupFilesForProcess_shib() {

  if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then
    if [ -f /etc/httpd/conf.d/shib.conf ]
      then
        mv /etc/httpd/conf.d/shib.conf /etc/httpd/conf.d/shib.conf.dontuse
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_shib) mv /etc/httpd/conf.d/shib.conf /etc/httpd/conf.d/shib.conf.dontuse , result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        
    fi
    
    if [ "$GROUPER_RUN_SHIB_SP" = "true" ]
      then
        export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH
        echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_shib) Appending supervisord-shibsp.conf to supervisord.conf"
        cat /opt/tier-support/supervisord-shibsp.conf >> /opt/tier-support/supervisord.conf
        returnCode=$?
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        if [ "$GROUPER_ORIGFILE_HTTPD_SHIB_CONF" = "true" ]; then
          cp /opt/tier-support/httpd-shib.conf /etc/httpd/conf.d/
          returnCode=$?
          echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_shib) cp /opt/tier-support/httpd-shib.conf /etc/httpd/conf.d/ , result: $returnCode"
          if [ $returnCode != 0 ]; then exit $returnCode; fi
        else
          echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_shib) /etc/httpd/conf.d/httpd-shib.conf is not the original file so will not be edited"
        fi
        if [ "$GROUPER_ORIGFILE_SHIB_CONF" = "true" ]; then
          mv /etc/httpd/conf.d/shib.conf.dontuse /etc/httpd/conf.d/shib.conf
          returnCode=$?
          echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_shib) mv /etc/httpd/conf.d/shib.conf.dontuse /etc/httpd/conf.d/shib.conf , result: $returnCode"
          if [ $returnCode != 0 ]; then exit $returnCode; fi
        else
          echo "grouperContainer; INFO: (librarySetupFilesForProcess.sh-setupFilesForProcess_shib) /etc/httpd/conf.d/shib.conf is not the original file so will not be edited"
        fi
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
