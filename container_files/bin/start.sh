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
      exit 1
  else
      echo "Grouper was configured"
      exit 0
  fi
else
  echo "Composed so waiting for MariaDB: " > $log
  echo "Testing connectivy to database before continue with install"
  mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h "$MYSQL_HOST" -e "use grouper; show tables;"
  laststatus="$?"
  while [ "$laststatus" != "0" ]; do
  mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h "$MYSQL_HOST" -e "use grouper; show tables;"
  laststatus="$?"
  sleep 5
  echo "Trying to connect to mariadb container with $MYSQL_USER to database $MYSQL_DATABASE"
  done
  /opt/bin/main.sh
  laststatus="$?"
  echo "Composed status: $laststatus"
  if [ "$laststatus" != "0" ]; then
      echo "Composed non-zero exit status: $laststatus" >> $log
      echo "Composed non-zero exit status: $laststatus"
      exit 1
  else
      echo "Grouper was configured"
      exit 0
  fi
fi
