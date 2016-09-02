#!/bin/bash

log="/tmp/start.log"

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
      exit 0
  fi
else
  echo "Composed so waiting for MariaDB: " > $log
  /opt/wait-for-it/wait-for-it.sh $MYSQL_HOST:3306 -t 60 --strict --  /opt/bin/main.sh
  laststatus="$?"
  echo "Composed status: $laststatus"
  if [ "$laststatus" != "0" ]; then
      echo "Composed non-zero exit status: $laststatus" >> $log
      echo "Composed non-zero exit status: $laststatus"
      exit 1
  else
      exit 0
  fi
fi
