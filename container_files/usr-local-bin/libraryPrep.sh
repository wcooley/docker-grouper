#!/bin/sh

prep_quickstart() {
    
    
    
    if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then
      if [ -z "$GROUPER_RUN_HSQLDB" ]; then export GROUPER_RUN_HSQLDB=true; fi
      if [ -z "$GROUPER_SELF_SIGNED_CERT" ]; then export GROUPER_SELF_SIGNED_CERT=true; fi
      if [ -z "$GROUPER_START_DELAY_SECONDS" ]; then export GROUPER_START_DELAY_SECONDS='10'; fi
      if [ -z "$GROUPER_DATABASE_URL_FILE" ] && [ -z "$GROUPER_DATABASE_URL" ]; then export GROUPER_DATABASE_URL=jdbc:hsqldb:hsql://localhost:9001/grouper; fi
      if [ -z "$GROUPER_DATABASE_USERNAME_FILE" ] && [ -z "$GROUPER_DATABASE_USERNAME" ]; then export GROUPER_DATABASE_USERNAME=sa; fi
    fi
    if [ -z "$GROUPER_RUN_SHIB_SP" ]; then export GROUPER_RUN_SHIB_SP=false; fi
    if [ -z "$GROUPER_AUTO_DDL_UPTOVERSION" ]; then export GROUPER_AUTO_DDL_UPTOVERSION='v2.5.*'; fi
    if [ -z "$GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES" ]; then export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='0.0.0.0/0'; fi
    # wait for database to start
    if [ -z "$GROUPER_UI_GROUPER_AUTH" ]; then export GROUPER_UI_GROUPER_AUTH='true'; fi
    if [ -z "$GROUPER_WS_GROUPER_AUTH" ]; then export GROUPER_WS_GROUPER_AUTH='true'; fi
    if [ -z "$GROUPER_SCIM_GROUPER_AUTH" ] ; then export GROUPER_SCIM_GROUPER_AUTH=true; fi
    if [ -z "$GROUPER_QUICKSTART" ]; then export GROUPER_QUICKSTART=true; fi

}

prep_daemon() {
    
    if [ -z "$GROUPER_DAEMON" ]; then export GROUPER_DAEMON=true; fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then export GROUPER_RUN_TOMEE=true; fi
}

prep_scim() {
    if [ -z "$GROUPER_SCIM" ]; then export GROUPER_SCIM=true; fi
    if [ -z "$GROUPER_RUN_APACHE" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then export GROUPER_RUN_APACHE=true; fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then export GROUPER_RUN_TOMEE=true; fi
}

prep_ui() {
    if [ -z "$GROUPER_UI" ]; then export GROUPER_UI=true; fi
    if [ -z "$GROUPER_RUN_APACHE" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then export GROUPER_RUN_APACHE=true; fi
    if [ -z "$GROUPER_RUN_SHIB_SP" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then export GROUPER_RUN_SHIB_SP=true; fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then export GROUPER_RUN_TOMEE=true; fi
}

prep_runUi() {
  if [ -z "$GROUPER_PROXY_PASS" ]
    then
      if [ "$GROUPER_UI" == 'true' ]
        then
          export GROUPER_PROXY_PASS=
        else
          export GROUPER_PROXY_PASS=#
      fi
    
  fi
}
prep_runWs() {
  if [ -z "$GROUPERWS_PROXY_PASS" ]
    then
      if [ "$GROUPER_WS" == 'true' ]
        then
          export GROUPERWS_PROXY_PASS=
        else
          export GROUPERWS_PROXY_PASS=#
      fi
    
  fi
}
prep_runScim() {
  if [ -z "$GROUPERSCIM_PROXY_PASS" ]
    then
      if [ "$GROUPER_SCIM" == 'true' ]
        then
          export GROUPERSCIM_PROXY_PASS=
        else
          export GROUPERSCIM_PROXY_PASS=#
      fi
    
  fi
}


prep_ws() {

    if [ -z "$GROUPER_WS" ]; then export GROUPER_WS=true; fi
    if [ -z "$GROUPER_RUN_APACHE" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then export GROUPER_RUN_APACHE=true; fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then export GROUPER_RUN_TOMEE=true; fi
}

prep_conf() {
    
    prep_initDeprecatedEnvVars
    setupPipe_logging
    setupPipe_supervisordLog
    setupPipe_grouperLog
    grouperScriptHooks_prepConfPost

}

prep_initDeprecatedEnvVars() {

  if [ ! -z "$RUN_APACHE" ] && [ -z "$GROUPER_RUN_APACHE" ]
    then 
      export GROUPER_RUN_APACHE="$RUN_APACHE"
  fi

  if [ ! -z "$RUN_SHIB_SP" ] && [ -z "$GROUPER_RUN_SHIB_SP" ]
    then 
      export GROUPER_RUN_SHIB_SP="$RUN_SHIB_SP"
  fi

  if [ ! -z "$RUN_TOMEE" ] && [ -z "$GROUPER_RUN_TOMEE" ]
    then 
      export GROUPER_RUN_TOMEE="$RUN_TOMEE"
  fi

  if [ ! -z "$RUN_HSQLDB" ] && [ -z "$GROUPER_RUN_HSQLDB" ]
    then 
      export GROUPER_RUN_HSQLDB="$RUN_HSQLDB"
  fi

  if [ ! -z "$SELF_SIGNED_CERT" ] && [ -z "$GROUPER_SELF_SIGNED_CERT" ]
    then 
      export GROUPER_SELF_SIGNED_CERT="$SELF_SIGNED_CERT"
  fi

}

prep_finishBegin() {
    # default a lot of env variables
    # morph defaults to null
    # database password defaults to null
    if [ -z "$GROUPER_UI_GROUPER_AUTH" ] ; then export GROUPER_UI_GROUPER_AUTH=false; fi
    if [ -z "$GROUPER_WS_GROUPER_AUTH" ] ; then export GROUPER_WS_GROUPER_AUTH=false; fi
    if [ -z "$GROUPER_SCIM_GROUPER_AUTH" ] ; then export GROUPER_SCIM_GROUPER_AUTH=false; fi
    if [ -z "$GROUPER_CHOWN_DIRS" ] ; then export GROUPER_CHOWN_DIRS=true; fi
    if [ -z "$GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES" ]; then export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='127.0.0.1/32'; fi
    # GROUPER_AUTO_DDL_UPTOVERSION defaults to null
    # GROUPER_START_DELAY_SECONDS defaults to null
    if [ -z "$GROUPER_UI" ] ; then export GROUPER_UI=false; fi
    if [ -z "$GROUPER_SCIM" ] ; then export GROUPER_SCIM=false; fi
    if [ -z "$GROUPER_WS" ] ; then export GROUPER_WS=false; fi
    if [ -z "$GROUPER_DAEMON" ] ; then export GROUPER_DAEMON=false; fi
    if [ -z "$GROUPER_USE_SSL" ]; then export GROUPER_USE_SSL=true; fi
    if [ -z "$GROUPER_RUN_PROCESSES_AS_USERS" ]; then export GROUPER_RUN_PROCESSES_AS_USERS=true; fi

    # do these before the "only" component
    if [ -z "$GROUPER_URL_CONTEXT" ] ; then export GROUPER_URL_CONTEXT=grouper; fi
    if [ -z "$GROUPERWS_URL_CONTEXT" ] ; then export GROUPERWS_URL_CONTEXT=grouper-ws; fi
    if [ -z "$GROUPERSCIM_URL_CONTEXT" ] ; then export GROUPERSCIM_URL_CONTEXT=grouper-ws-scim; fi
    if [ -z "$GROUPER_APACHE_AJP_TIMEOUT_SECONDS" ] ; then export GROUPER_APACHE_AJP_TIMEOUT_SECONDS=3600; fi
    
    
    if [ -z "$GROUPER_APACHE_SSL_PORT" ] ; then export GROUPER_APACHE_SSL_PORT=443; fi
    if [ -z "$GROUPER_APACHE_NONSSL_PORT" ] ; then export GROUPER_APACHE_NONSSL_PORT=80; fi
    
    if [ -z "$GROUPER_GSH_CHECK_USER" ] ; then export GROUPER_GSH_CHECK_USER=true; fi
    if [ -z "$GROUPER_GSH_USER" ] ; then export GROUPER_GSH_USER=tomcat; fi
    
     if [ -z "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" ]; then export GROUPER_RUN_TOMCAT_NOT_SUPERVISOR=false; fi
    
}

prep_finishEnd() {

    # defaults after the "only" part
    if [ -z "$GROUPER_TOMCAT_CONTEXT" ] ; then export GROUPER_TOMCAT_CONTEXT=grouper; fi
    if [ -z "$GROUPER_LOG_PREFIX" ]; then export GROUPER_LOG_PREFIX=grouper; fi
    if [ -z "$GROUPER_MAX_MEMORY" ]; then export GROUPER_MAX_MEMORY=1500m; fi

}

prep_finish() {

    grouperScriptHooks_prepComponentPost

    prep_finishBegin

    prepOnly    

    prep_runScim
    prep_runUi
    prep_runWs

    prep_finishEnd
    
    grouperScriptHooks_finishPrepPost
        
    prep_unsetAll
    prepOnly_unsetAll
}

prep_unsetAll() {
  unset -f prep_conf
  unset -f prep_daemon
  unset -f prep_finish
  unset -f prep_finishBegin
  unset -f prep_finishEnd
  unset -f prep_initDeprecatedEnvVars
  unset -f prep_quickstart
  unset -f prep_runScim
  unset -f prep_runUi
  unset -f prep_runWs
  unset -f prep_scim
  unset -f prep_unsetAll
  unset -f prep_ui
  unset -f prep_ws
  
}

prep_exportAll() {
  export -f prep_conf
  export -f prep_daemon
  export -f prep_finish
  export -f prep_finishBegin
  export -f prep_finishEnd
  export -f prep_initDeprecatedEnvVars
  export -f prep_quickstart
  export -f prep_runScim
  export -f prep_runUi
  export -f prep_runWs
  export -f prep_scim
  export -f prep_unsetAll
  export -f prep_ui
  export -f prep_ws
}

# export everything
prep_exportAll

