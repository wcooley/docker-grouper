#!/bin/bash

# $1 ARG JAVA_VERSION=17
JAVA_VERSION=$1


rpm --import https://yum.corretto.aws/corretto.key
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rpm --import https://yum.corretto.aws/corretto.key, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

dnf --allowerasing install -y java-$JAVA_VERSION-amazon-corretto-devel
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) dnf install -y java-$JAVA_VERSION-amazon-corretto-devel, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi
