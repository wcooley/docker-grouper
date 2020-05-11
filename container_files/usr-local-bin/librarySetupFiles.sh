#!/bin/sh

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
        cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.grouperContainerHost.properties /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties
    fi

}

setupFiles_loggingPrefix() {
    sed -i "s|__GROUPER_LOG_PREFIX__|$GROUPER_LOG_PREFIX|g" /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties
}

setupFiles_chownDirs() {
    # do this last
    if [ "$GROUPER_CHOWN_DIRS" = "true" ]
      then
        chown -R tomcat:tomcat /opt/grouper/grouperWebapp
        chown -R tomcat:tomcat /opt/tomee
    fi
}

setupFiles_storeEnvVars() {

  echo "#!/bin/sh" > /opt/grouper/grouperEnv.sh
  echo "" >> /opt/grouper/grouperEnv.sh

  # go through env vars, should start with GROUPER and have an equals sign in there
  env | grep "^GROUPER" | grep "=" >> /opt/grouper/grouperEnv.sh

  sed -i "s|^GROUPER|export GROUPER|g" /opt/grouper/grouperEnv.sh

  if [ ! -f /home/tomcat/.bashrc ]
    then
      echo "Why doesnt /home/tomcat/.bashrc exist????"
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
        echo "Why doesnt /etc/bashrc exist????"
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
}

setupFiles() {

  if [ "$GROUPER_SETUP_FILES_COMPLETE" = "true" ]
    then
      return
  fi

  # do this first
  setupFiles_storeEnvVars
  
  setupFiles_rsyncSlashRoot

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
  
  setupFiles_unsetAll
  setupFilesApache_unsetAll
  setupFilesForComponent_unsetAll
  setupFilesForProcess_unsetAll
  setupFilesTomcat_unsetAll
  setupPipe_unsetAll
  grouperScriptHooks_unsetAll
  
}

setupFiles_unsetAll() {
  unset -f setupFiles
  unset -f setupFiles_chownDirs
  unset -f setupFiles_linkGrouperSecrets
  unset -f setupFiles_localLogging
  unset -f setupFiles_loggingPrefix
  unset -f setupFiles_rsyncSlashRoot
  unset -f setupFiles_storeEnvVars
  unset -f setupFiles_unsetAll
}

setupFiles_exportAll() {
  export -f setupFiles
  export -f setupFiles_chownDirs
  export -f setupFiles_linkGrouperSecrets
  export -f setupFiles_localLogging
  export -f setupFiles_loggingPrefix
  export -f setupFiles_rsyncSlashRoot
  export -f setupFiles_storeEnvVars
  export -f setupFiles_unsetAll
}

# export everything
setupFiles_exportAll


