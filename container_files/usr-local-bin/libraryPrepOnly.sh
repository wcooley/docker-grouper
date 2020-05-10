#!/bin/sh

prepOnly_component() {
    if [ "$GROUPER_WS" = "true" ] && [ "$GROUPER_UI" != "true" ] && [ "$GROUPER_SCIM" != "true" ] && [ "$GROUPER_DAEMON" != "true" ]
       then
         if [ -z "$GROUPER_WS_ONLY" ] ; then export GROUPER_WS_ONLY=true; fi
    fi

    if [ "$GROUPER_WS" != "true" ] && [ "$GROUPER_UI" != "true" ] && [ "$GROUPER_SCIM" = "true" ] && [ "$GROUPER_DAEMON" != "true" ]
       then
         if [ -z "$GROUPER_SCIM_ONLY" ] ; then export GROUPER_SCIM_ONLY=true; fi
    fi

    if [ "$GROUPER_WS" != "true" ] && [ "$GROUPER_UI" = "true" ] && [ "$GROUPER_SCIM" != "true" ] && [ "$GROUPER_DAEMON" != "true" ]
       then
         if [ -z "$GROUPER_UI_ONLY" ] ; then export GROUPER_UI_ONLY=true; fi
    fi
              
    if [ "$GROUPER_WS" != "true" ] && [ "$GROUPER_UI" != "true" ] && [ "$GROUPER_SCIM" != "true" ] && [ "$GROUPER_DAEMON" = "true" ]
      then
         if [ -z "$GROUPER_DAEMON_ONLY" ] ; then export GROUPER_DAEMON_ONLY=true; fi
    fi 
}

prepOnly_ui() {
    if [ "$GROUPER_UI_ONLY" = "true" ]
       then
         if [ -z "$GROUPER_LOG_PREFIX" ]; then export GROUPER_LOG_PREFIX=grouper-ui; fi
    fi
}

prepOnly_ws() {
    if [ "$GROUPER_WS_ONLY" = "true" ]
       then
         if [ -z "$GROUPER_LOG_PREFIX" ]; then export GROUPER_LOG_PREFIX=grouper-ws; fi
         if [ -z "$GROUPER_CONTEXT_COOKIES" ]; then export GROUPER_CONTEXT_COOKIES=false; fi
         # default to whatever ws context is
         if [ -z "$GROUPER_TOMCAT_CONTEXT" ] ; then export GROUPER_TOMCAT_CONTEXT="$GROUPERWS_URL_CONTEXT"; fi
    fi
}

prepOnly_scim() {
   if [ "$GROUPER_SCIM_ONLY" = "true" ]
       then
         if [ -z "$GROUPER_LOG_PREFIX" ]; then export GROUPER_LOG_PREFIX=grouper-scim; fi
         if [ -z "$GROUPER_CONTEXT_COOKIES" ]; then export GROUPER_CONTEXT_COOKIES=false; fi
         # default to whatever scim context is
         if [ -z "$GROUPER_TOMCAT_CONTEXT" ] ; then export GROUPER_TOMCAT_CONTEXT="$GROUPERSCIM_URL_CONTEXT"; fi
    fi
}

prepOnly_daemon() {
    if [ "$GROUPER_DAEMON_ONLY" = "true" ]
      then
       if [ -z "$GROUPER_LOG_PREFIX" ]; then export GROUPER_LOG_PREFIX=grouper-daemon; fi
    fi 
}

prepOnly() {
    prepOnly_component
    
    prepOnly_ws

    prepOnly_scim

    prepOnly_ui
              
    prepOnly_daemon

}

prepOnly_unsetAll() {
  unset -f prepOnly
  unset -f prepOnly_component
  unset -f prepOnly_daemon
  unset -f prepOnly_scim
  unset -f prepOnly_ui
  unset -f prepOnly_unsetAll
  unset -f prepOnly_ws
}

prepOnly_exportAll() {
  export -f prepOnly
  export -f prepOnly_component
  export -f prepOnly_daemon
  export -f prepOnly_scim
  export -f prepOnly_ui
  export -f prepOnly_unsetAll
  export -f prepOnly_ws
}

# export everything
prepOnly_exportAll