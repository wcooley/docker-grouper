#!/bin/sh

dest=/opt/grouper/grouperWebapp/WEB-INF/

if [ -d "/opt/grouper/slashRoot" ]; then
    # Copy any files into the root filesystem
    rsync -l -r -v /opt/grouper/slashRoot/ /
fi

if [ -d "/opt/grouper/lib" ]; then
    cp -r /opt/grouper/lib/* $dest/libUiAndDaemon/
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

prepDaemon() {
    export GROUPER_DAEMON=true
    export RUN_TOMEE=true

    setupLoggingPipe
    setupGrouperLogPipe
    cp /opt/tier-support/grouper.xml /opt/tomee/conf/Catalina/localhost/
    finishPrep
}

prepSCIM() {
    export GROUPER_SCIM=true
    export RUN_APACHE=true
    export RUN_TOMEE=true

    setupLoggingPipe
    setupGrouperLogPipe
    setupHttpdLogPipe
    setupTomcatLogPipe

    
    cp /opt/tier-support/grouper.xml /opt/tomee/conf/Catalina/localhost/
    finishPrep
}

prepUI() {
    export GROUPER_UI=true
    export RUN_APACHE=true
    export RUN_SHIB_SP=true
    export RUN_TOMEE=true

    setupLoggingPipe
    setupGrouperLogPipe
    setupHttpdLogPipe
    setupShibdLogPipe
    setupTomcatLogPipe
    setupSupervisordLogPipe

    cp /opt/tier-support/grouper.xml /opt/tomee/conf/Catalina/localhost/
    finishPrep
}

prepWS() {

    export GROUPER_WS=true
    export RUN_APACHE=true
    export RUN_TOMEE=true
    setupLoggingPipe
    setupGrouperLogPipe
    setupHttpdLogPipe
    setupTomcatLogPipe
    setupSupervisordLogPipe

    cp /opt/tier-support/grouper.xml /opt/tomee/conf/Catalina/localhost/
    finishPrep
}


prepConf() {
    linkGrouperSecrets $dest/classes
    
    if [ -d "/opt/grouper/conf" ]; then
        cp -r /opt/grouper/conf/* $dest/classes/
    fi
}


finishPrep() {
    # construct the supervisord file based on FLAGS passed in or what was in CMD
    if [ "$RUN_APACHE" = "true" ]
      then
        cat /opt/tier-support/supervisord-httpd.conf >> /opt/tier-support/supervisord-base.conf
    fi


    if [ "$RUN_TOMEE" = "true" ]
      then
        cat /opt/tier-support/supervisord-tomee.conf >> /opt/tier-support/supervisord-base.conf
    fi

    if [ "$RUN_SHIB_SP" = "true" ]
      then
        cat /opt/tier-support/supervisord-shibsp.conf >> /opt/tier-support/supervisord-base.conf
    fi

    cat /opt/tier-support/supervisord-base.conf > /opt/tier-support/supervisord.conf


    # copy files to their appropriate locations based on passed in flags
    if [ "GROUPER_WS" = "true" ]
       then
         cp -r $dest/libWs/* $dest/lib/
    fi

    if [ "GROUPER_SCIM" = "true" ]
       then
         cp -r $dest/libScim/* $dest/lib/
    fi

    if [ "GROUPER_UI" = "true" ] || [ "GROUPER_DAEMON" = "true" ]
       then
         cp -r $dest/libUiAndDaemon/* $dest/lib/
    fi
}
