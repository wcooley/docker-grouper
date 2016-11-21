#!/bin/bash

log="/tmp/start-starting.log"
date >> $log
if [ -z ${COMPOSE+x} ]
then
  echo "Not composed so not waiting for MariaDB: " > $log
  /opt/bin/main.sh
  laststatus="$?"
  echo "Not composed status: $laststatus"
  if [ "$laststatus" != "0" ]; then
      echo "Not composed non-zero exit status: $laststatus" >> $log
      echo "Not composed non-zero exit status: $laststatus"
      /opt/autoexec/bin/firstrun.sh
      exit 1
  else
      echo "Grouper was configured" >>$log
      echo "Grouper was configured"
      echo "Starting tomcat and apache" >>$log
      echo "Starting tomcat and apache"
      /opt/autoexec/bin/firstrun.sh
      /usr/local/bin/httpd-shib-foreground &
      /opt/grouper/2.3.0/apache-tomcat-6.0.35/bin/catalina.sh run 
  fi
else
  echo "Composed so waiting for MariaDB: " > $log
  date >> $log
  echo "Testing connectivy to database before continue with install"
  mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h "$MYSQL_HOST" -e "use grouper; show tables;"
  laststatus="$?"
  echo "checking connectivity" >> $log
  while [ "$laststatus" != "0" ]; do
  mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h "$MYSQL_HOST" -e "use grouper; show tables;"
  laststatus="$?"
  sleep 5
  date >> $log
  echo "Trying to connect to mariadb container with $MYSQL_USER to database $MYSQL_DATABASE"
  echo "Trying to connect to mariadb container with $MYSQL_USER to database $MYSQL_DATABASE" >> $log
  done
  /opt/bin/main.sh
  laststatus="$?"
  echo "Composed status: $laststatus"
  echo "Composed status: $laststatus" >>$log
  if [ "$laststatus" != "0" ]; then
      echo "Composed non-zero exit status: $laststatus" >> $log
      echo "Composed non-zero exit status: $laststatus"
      /opt/autoexec/bin/firstrun.sh
      exit 1
  else
      echo "Grouper was configured" >>$log
      echo "Grouper was configured"
      echo "Starting tomcat and apache" >>$log
      echo "Starting tomcat and apache"
      /opt/autoexec/bin/firstrun.sh
      date >> $log
      /usr/local/bin/httpd-shib-foreground &
      /opt/grouper/2.3.0/apache-tomcat-6.0.35/bin/catalina.sh run &
      /opt/grouper/$version/grouper.apiBinary-$version/bin/gsh -loader
  fi
fi
