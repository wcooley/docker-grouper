#!/bin/bash

setupFiles_linkGrouperSecrets() {
    for filepath in /run/secrets/*; do
        local label_file=`basename $filepath`
        local file=$(echo $label_file| cut -d'_' -f 2)

        if [[ $label_file == grouper_* ]]; then
            ln -sf /run/secrets/$label_file /opt/grouper/grouperWebapp/WEB-INF/classes/$file
        elif [[ $label_file == shib_* ]]; then
            ln -sf /run/secrets/$label_file /etc/shibboleth/$file
        elif [[ $label_file == httpd_* ]]; then
            ln -sf /run/secrets/$label_file /etc/httpd/conf.d/$file
        elif [ "$label_file" == "host-key.pem" ]; then
            ln -sf /run/secrets/host-key.pem /etc/pki/tls/private/host-key.pem
        fi
    done
}

setupFiles_rsyncSlashRoot() {
    if [ -d "/opt/grouper/slashRoot" ]; then
        # Copy any files into the root filesystem
        rsync -l -r -v /opt/grouper/slashRoot/ /
    fi

}

setupFiles_localLogging() {
  if [ "$GROUPER_LOG_TO_HOST" = "true" ]
    then
      if [ "$GROUPER_ORIGFILE_LOG4J_PROPERTIES" = "true" ]; then
        cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.grouperContainerHost.properties /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties
        echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles_localLogging) cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.grouperContainerHost.properties /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties, result: $?"
      else
        echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles_localLogging) /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties is not the original file so will not be edited"
      fi
  fi

}

setupFiles_loggingPrefix() {
    sed -i "s|__GROUPER_LOG_PREFIX__|$GROUPER_LOG_PREFIX|g" /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties
    echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles_loggingPrefix) Changing log prefix to $GROUPER_LOG_PREFIX in log4j.properties, result: $?"
}

setupFiles_chownDirs() {
    # do this last
    if [ "$GROUPER_CHOWN_DIRS" = "true" ]
      then
        chown -R tomcat:tomcat /opt/grouper/grouperWebapp
        echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles_chownDirs) chown -R tomcat:tomcat /opt/grouper/grouperWebapp, result: $?"
        chown -R tomcat:tomcat /opt/tomee
        echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles_chownDirs) chown -R tomcat:tomcat /opt/tomee, result: $?"
    fi
}

setupFiles_storeEnvVars() {

  echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles_storeEnvVars) Start store env vars in /opt/grouper/grouperEnv.sh"

  echo "#!/bin/sh" > /opt/grouper/grouperEnv.sh
  echo "" >> /opt/grouper/grouperEnv.sh

  # go through env vars, should start with GROUPER and have an equals sign in there
  env | grep "^GROUPER" | grep "=" | sort >> /opt/grouper/grouperEnv.sh

  sed -i "s|^GROUPER|export GROUPER|g" /opt/grouper/grouperEnv.sh

  if [ ! -f /home/tomcat/.bashrc ]
    then
      echo "grouperContainer; ERROR: (librarySetupFiles.sh-setupFiles_storeEnvVars) Why doesnt /home/tomcat/.bashrc exist????"
      exit 1
  fi  
  if ! grep -q grouperEnv /home/tomcat/.bashrc
    then
      echo "" >> /home/tomcat/.bashrc  
      echo ". /opt/grouper/grouperEnv.sh" >> /home/tomcat/.bashrc
      echo "" >> /home/tomcat/.bashrc  
  fi

  # if we own this file (i.e. running as root)  
  if [[ -O "/etc/bashrc" ]]; then
    # we need these global  
    if [ ! -f /etc/bashrc ]
      then
        echo "grouperContainer; ERROR: (librarySetupFiles.sh-setupFiles_storeEnvVars) Why doesnt /etc/bashrc exist????"
        exit 1
    fi  
    if ! grep -q GROUPER_GSH_CHECK_USER /etc/bashrc
       then 
        echo "" >> /etc/bashrc  
        echo "export GROUPER_GSH_CHECK_USER=$GROUPER_GSH_CHECK_USER" >> /etc/bashrc  
        echo "export GROUPER_GSH_USER=$GROUPER_GSH_USER" >> /etc/bashrc  
        echo "export JAVA_HOME=$JAVA_HOME" >> /etc/bashrc  
        echo "export PATH=$JAVA_HOME/bin:\$PATH" >> /etc/bashrc  
        echo "" >> /etc/bashrc  
    fi    
  fi 
  echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles_storeEnvVars) End store env vars in /opt/grouper/grouperEnv.sh"
}

setupFiles_originalFile() {
  fullPath=$1
  fileName="$(basename $fullPath)"
  originalFilePath="/opt/tier-support/originalFiles/$fileName"
  if [ -f "$fullPath" ]; then
    if [ -f "$originalFilePath" ]; then
      if cmp "$fullPath" "$originalFilePath" >/dev/null 2>&1
      then
        # true, same
        return 0
      else
        # false, different
        return 1
      fi
    else
      # false, different
      return 1
    fi
  fi
  # didnt exist and still doesnt... same?
  return 0
}


setupFiles_analyzeOriginalFiles() {

    setupFiles_originalFile /opt/tomee/conf/Catalina/localhost/grouper.xml
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_GROUPER_XML" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_GROUPER_XML=true; fi
    if [ -z "$GROUPER_ORIGFILE_GROUPER_XML" ] ; then export GROUPER_ORIGFILE_GROUPER_XML=false; fi
      
    setupFiles_originalFile /opt/tomee/conf/server.xml
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_SERVER_XML" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_SERVER_XML=true; fi
    if [ -z "$GROUPER_ORIGFILE_SERVER_XML" ] ; then export GROUPER_ORIGFILE_SERVER_XML=false; fi

    setupFiles_originalFile /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_LOG4J_PROPERTIES" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_LOG4J_PROPERTIES=true; fi
    if [ -z "$GROUPER_ORIGFILE_LOG4J_PROPERTIES" ] ; then export GROUPER_ORIGFILE_LOG4J_PROPERTIES=false; fi

    setupFiles_originalFile /etc/httpd/conf/httpd.conf
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_HTTPD_CONF" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_HTTPD_CONF=true; fi
    if [ -z "$GROUPER_ORIGFILE_HTTPD_CONF" ] ; then export GROUPER_ORIGFILE_HTTPD_CONF=false; fi

    setupFiles_originalFile /etc/httpd/conf.d/ssl-enabled.conf
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_SSL_ENABLED_CONF" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_SSL_ENABLED_CONF=true; fi
    if [ -z "$GROUPER_ORIGFILE_SSL_ENABLED_CONF" ] ; then export GROUPER_ORIGFILE_SSL_ENABLED_CONF=false; fi

    setupFiles_originalFile /etc/httpd/conf.d/httpd-shib.conf
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_HTTPD_SHIB_CONF" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_HTTPD_SHIB_CONF=true; fi
    if [ -z "$GROUPER_ORIGFILE_HTTPD_SHIB_CONF" ] ; then export GROUPER_ORIGFILE_HTTPD_SHIB_CONF=false; fi

    setupFiles_originalFile /etc/httpd/conf.d/shib.conf
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_SHIB_CONF" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_SHIB_CONF=true; fi
    if [ -z "$GROUPER_ORIGFILE_SHIB_CONF" ] ; then export GROUPER_ORIGFILE_SHIB_CONF=false; fi

    setupFiles_originalFile /opt/tomee/conf/Catalina/localhost/grouper.xml
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_GROUPER_XML" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_GROUPER_XML=true; fi
    if [ -z "$GROUPER_ORIGFILE_GROUPER_XML" ] ; then export GROUPER_ORIGFILE_GROUPER_XML=false; fi

    setupFiles_originalFile /opt/grouper/grouperWebapp/WEB-INF/web.xml
    original_file=$?
    if [ -z "$GROUPER_ORIGFILE_WEBAPP_WEB_XML" ] && [[ $original_file -eq 0 ]]
      then export GROUPER_ORIGFILE_WEBAPP_WEB_XML=true; fi
    if [ -z "$GROUPER_ORIGFILE_WEBAPP_WEB_XML" ] ; then export GROUPER_ORIGFILE_WEBAPP_WEB_XML=false; fi

}

setupFiles() {

  if [ "$GROUPER_SETUP_FILES_COMPLETE" = "true" ]
    then
      echo "grouperContainer; INFO: (librarySetupFiles.sh-setupFiles) GROUPER_SETUP_FILES_COMPLETE=true, skipping setting up files (including not syncing slashRoot again)"
      setupFiles_unsetAllAndFromFiles
      return
  fi

  setupFiles_rsyncSlashRoot
  
  setupFiles_analyzeOriginalFiles

  # do this first
  setupFiles_storeEnvVars
  
  setupFiles_linkGrouperSecrets

  # this needs to be first
  setupFilesForProcess_supervisor

  setupFilesApache

  setupFilesTomcat
  
  setupFilesForProcess
  
  # this needs to be last
  setupFilesForProcess_supervisorFinal
  
  setupFilesForComponent
  
  setupFiles_localLogging

  setupFiles_loggingPrefix

  grouperScriptHooks_setupFilesPost
  
  # do this last
  setupFiles_chownDirs

  grouperScriptHooks_setupFilesPostChown

  export GROUPER_SETUP_FILES_COMPLETE=true
  echo 'export GROUPER_SETUP_FILES_COMPLETE=true' >> /opt/grouper/grouperEnv.sh
  
  setupFiles_unsetAllAndFromFiles
}

setupFiles_unsetAllAndFromFiles() {
  setupFiles_unsetAll
  setupFilesApache_unsetAll
  setupFilesForComponent_unsetAll
  setupFilesForProcess_unsetAll
  setupFilesTomcat_unsetAll
  grouperScriptHooks_unsetAll
}


setupFiles_unsetAll() {
  unset -f setupFiles
  unset -f setupFiles_analyzeOriginalFiles
  unset -f setupFiles_chownDirs
  unset -f setupFiles_linkGrouperSecrets
  unset -f setupFiles_localLogging
  unset -f setupFiles_loggingPrefix
  unset -f setupFiles_originalFile
  unset -f setupFiles_rsyncSlashRoot
  unset -f setupFiles_storeEnvVars
  unset -f setupFiles_unsetAll
  unset -f setupFiles_unsetAllAndFromFiles
}

setupFiles_exportAll() {
  export -f setupFiles
  export -f setupFiles_analyzeOriginalFiles
  export -f setupFiles_chownDirs
  export -f setupFiles_linkGrouperSecrets
  export -f setupFiles_localLogging
  export -f setupFiles_loggingPrefix
  export -f setupFiles_originalFile
  export -f setupFiles_rsyncSlashRoot
  export -f setupFiles_storeEnvVars
  export -f setupFiles_unsetAll
  export -f setupFiles_unsetAllAndFromFiles
}

# export everything
setupFiles_exportAll


