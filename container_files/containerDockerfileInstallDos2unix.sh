#!/bin/bash

lines=$(find $1 -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1 | wc -l)
if [ $lines -ne 0 ]; then 
  dos2unix $(find $1 -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallDos2unix.sh) dos2unix \$(find $1 -type f -name \"*.sh\" -exec file \"{}\" \";\"   | grep CRLF | cut -d: -f1), result: $returnCode"
fi
