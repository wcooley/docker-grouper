#!/bin/sh

dest=/opt/grouper/grouperWebapp/WEB-INF/

if [ -d "/opt/grouper/slashRoot" ]; then
    # Copy any files into the root filesystem
    rsync -l -r -v /opt/grouper/slashRoot/ /
fi

setupPipe() {
    if [ -e $1 ]; then
        rm $1
    fi
    mkfifo -m 666 $1
}

setupLoggingPipe() {
    # Make a "console" logging pipe that anyone can write too regardless of who owns the process.
    setupPipe /tmp/logpipe
    cat <> /tmp/logpipe &
}

# Make loggers pipes for the supervisord connected apps' console, so that we can prepend the streams.
setupGrouperLogPipe() {
    setupPipe /tmp/loggrouper
    (cat <> /tmp/loggrouper | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "grouper;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
}

setupHttpdLogPipe() {
    setupPipe /tmp/loghttpd
    (cat <> /tmp/loghttpd  | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "httpd;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
}

setupShibdLogPipe() {
    setupPipe /tmp/logshibd
    (cat <> /tmp/logshibd | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "shibd;console;%s;%s;%s", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
}

setupTomcatLogPipe() {
    setupPipe /tmp/logtomcat
    (cat <> /tmp/logtomcat | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "tomee;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
}

setupHsqldbLogPipe() {
    setupPipe /tmp/loghsqldb
    (cat <> /tmp/loghsqldb | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "hsqldb;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
}

setupSupervisordLogPipe() {
    setupPipe /tmp/logsuperd
    (cat <> /tmp/logsuperd | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "supervisord;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
}

linkGrouperSecrets() {
    for filepath in /run/secrets/*; do
        local label_file=`basename $filepath`
        local file=$(echo $label_file| cut -d'_' -f 2)

        if [[ $label_file == grouper_* ]]; then
            ln -sf /run/secrets/$label_file $dest/classes/$file
        elif [[ $label_file == shib_* ]]; then
            ln -sf /run/secrets/$label_file /etc/shibboleth/$file
        elif [[ $label_file == httpd_* ]]; then
            ln -sf /run/secrets/$label_file /etc/httpd/conf.d/$file
        elif [ "$label_file" == "host-key.pem" ]; then
            ln -sf /run/secrets/host-key.pem /etc/pki/tls/private/host-key.pem
        fi
    done
}

prepQuickstart() {
    
    if [ -z "$RUN_HSQLDB" ]; then export RUN_HSQLDB=true; fi
    if [ -z "$RUN_SHIB_SP" ]; then export RUN_SHIB_SP=false; fi
    if [ -z "$SELF_SIGNED_CERT" ]; then export SELF_SIGNED_CERT=true; fi
    if [ -z "$GROUPER_AUTO_DDL_UPTOVERSION" ]; then export GROUPER_AUTO_DDL_UPTOVERSION='v2.5.*'; fi
    if [ -z "$GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES" ]; then export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='0.0.0.0/0'; fi
    # wait for database to start
    if [ -z "$GROUPER_START_DELAY_SECONDS" ]; then export GROUPER_START_DELAY_SECONDS='10'; fi
    if [ -z "$GROUPER_UI_GROUPER_AUTH" ]; then export GROUPER_UI_GROUPER_AUTH='true'; fi
    if [ -z "$GROUPER_WS_GROUPER_AUTH" ]; then export GROUPER_WS_GROUPER_AUTH='true'; fi
    if [ -z "$GROUPER_SCIM_GROUPER_AUTH" ] ; then export GROUPER_SCIM_GROUPER_AUTH=true; fi

    if [ ! -z "$GROUPERSYSTEM_QUICKSTART_PASS" ]
      then
        if [ "$GROUPER_UI_GROUPER_AUTH" = 'true' ]
          then
            echo '' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.base.properties
            echo 'grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig = ${java.lang.System.getenv().get('"'"'GROUPERSYSTEM_QUICKSTART_PASS'"'"')}' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties
        fi
        if [ "$GROUPER_WS_GROUPER_AUTH" = 'true' ]
          then         
            echo '' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.base.properties
            echo 'grouperPasswordConfigOverride_WS_GrouperSystem_pass.elConfig = ${java.lang.System.getenv().get('"'"'GROUPERSYSTEM_QUICKSTART_PASS'"'"')}' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties
        fi
    fi

}

prepDaemon() {
    
    if [ -z "$GROUPER_DAEMON" ]; then export GROUPER_DAEMON=true; fi
    if [ -z "$RUN_TOMEE" ]; then export RUN_TOMEE=true; fi
}

prepSCIM() {
    if [ -z "$GROUPER_SCIM" ]; then export GROUPER_SCIM=true; fi
    if [ -z "$RUN_APACHE" ]; then export RUN_APACHE=true; fi
    if [ -z "$RUN_TOMEE" ]; then export RUN_TOMEE=true; fi
}

prepUI() {
    if [ -z "$GROUPER_UI" ]; then export GROUPER_UI=true; fi
    if [ -z "$RUN_APACHE" ]; then export RUN_APACHE=true; fi
    if [ -z "$RUN_SHIB_SP" ]; then export RUN_SHIB_SP=true; fi
    if [ -z "$RUN_TOMEE" ]; then export RUN_TOMEE=true; fi
}

prepWS() {

    if [ -z "$GROUPER_WS" ]; then export GROUPER_WS=true; fi
    if [ -z "$RUN_APACHE" ]; then export RUN_APACHE=true; fi
    if [ -z "$RUN_TOMEE" ]; then export RUN_TOMEE=true; fi
}


prepConf() {
    linkGrouperSecrets $dest/classes
}


finishPrep() {

    setupLoggingPipe
    setupGrouperLogPipe
    setupSupervisordLogPipe

    # clear out existing supervisord config
    cat /opt/tier-support/supervisord-base.conf > /opt/tier-support/supervisord.conf

    # default a lot of env variables
    # morph defaults to null
    if [ -z "$GROUPER_DATABASE_URL_FILE" ] && [ -z "$GROUPER_DATABASE_URL" ] ; then export GROUPER_DATABASE_URL=jdbc:hsqldb:hsql://localhost:9001/grouper; fi
    if [ -z "$GROUPER_DATABASE_USERNAME_FILE" ] && [ -z "$GROUPER_DATABASE_USERNAME" ] ; then export GROUPER_DATABASE_USERNAME=sa; fi
    # database password defaults to null
    if [ -z "$GROUPER_UI_GROUPER_AUTH" ] ; then export GROUPER_UI_GROUPER_AUTH=false; fi
    if [ -z "$GROUPER_WS_GROUPER_AUTH" ] ; then export GROUPER_WS_GROUPER_AUTH=false; fi
    if [ -z "$GROUPER_SCIM_GROUPER_AUTH" ] ; then export GROUPER_SCIM_GROUPER_AUTH=false; fi
    if [ -z "$GROUPER_CHOWN_DIRS" ] ; then export GROUPER_CHOWN_DIRS=true; fi
    
    if [ "$GROUPER_LOG_TO_HOST" = "true" ]
      then
        cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.grouperContainerHost.properties /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties
    fi
    if [ "$GROUPER_WS_TOMCAT_AUTHN" = "true" ]
      then
        cp /opt/grouper/grouperWebapp/WEB-INF/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml
        cp /opt/grouper/grouperWebapp/WEB-INF/server.wsTomcatAuthn.xml /opt/tomee/conf/server.xml
    fi

    # do this last
    if [ "$GROUPER_CHOWN_DIRS" = "true" ]
      then
        chown -R tomcat:tomcat /opt/grouper/grouperWebapp
    fi


    # construct the supervisord file based on FLAGS passed in or what was in CMD

    if [ "$RUN_HSQLDB" = "true" ]
      then
        setupHsqldbLogPipe
        cat /opt/tier-support/supervisord-hsqldb.conf >> /opt/tier-support/supervisord.conf
    fi

    if [ "$RUN_APACHE" = "true" ]
      then
        setupHttpdLogPipe
        cat /opt/tier-support/supervisord-httpd.conf >> /opt/tier-support/supervisord.conf
    fi


    if [ "$RUN_TOMEE" = "true" ]
      then
        setupTomcatLogPipe
        cat /opt/tier-support/supervisord-tomee.conf >> /opt/tier-support/supervisord.conf
    fi
    
    if [ -f /etc/httpd/conf.d/shib.conf ]
      then
        mv /etc/httpd/conf.d/shib.conf /etc/httpd/conf.d/shib.conf.dontuse
    fi
    
    if [ "$RUN_SHIB_SP" = "true" ]
      then
        setupShibdLogPipe
        export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH
        cat /opt/tier-support/supervisord-shibsp.conf >> /opt/tier-support/supervisord.conf
        cp /opt/tier-support/httpd-shib.conf /etc/httpd/conf.d/
        mv /etc/httpd/conf.d/shib.conf.dontuse /etc/httpd/conf.d/shib.conf
    fi

    # copy files to their appropriate locations based on passed in flags
    if [ "$GROUPER_WS" = "true" ]
       then
         cp -r $dest/libWs/* $dest/lib/
    fi

    if [ "$GROUPER_SCIM" = "true" ]
       then
         cp -r $dest/libScim/* $dest/lib/
    fi

    if [ "$GROUPER_UI" = "true" ]
      then
      if [ -z "$GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES" ]; then export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='127.0.0.1/32'; fi
    fi

    if [ "$GROUPER_UI" = "true" ] || [ "$GROUPER_DAEMON" = "true" ]
       then
         cp -r $dest/libUiAndDaemon/* $dest/lib/
    fi
    
    if [ "$SELF_SIGNED_CERT" = "true" ]
       then
          cp /opt/tier-support/ssl-enabled.conf /etc/httpd/conf.d/
    fi
    
    if [ -z "$GROUPER_MAX_MEMORY" ]
       then
          export GROUPER_MAX_MEMORY=1500m
    fi
    
    
}
