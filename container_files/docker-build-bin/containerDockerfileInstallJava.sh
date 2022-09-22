#!/bin/bash

# $1 ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
# $1 ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-linux-jdk.rpm
# $2 ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm
# $3 ARG JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
# $4 ARG GROUPER_VERSION=2.6.14

CORRETTO_URL_PERM=$1
CORRETTO_RPM=$2
JAVA_HOME=$3
GROUPER_VERSION=$4

curl -O -L $CORRETTO_URL_PERM
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) curl -O -L $CORRETTO_URL_PERM, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rpm --import /opt/container_files/java-corretto/corretto-signing-key.pub
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rpm --import /opt/container_files/java-corretto/corretto-signing-key.pub corretto-signing-key.pub, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rpm -K $CORRETTO_RPM
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rpm -K $CORRETTO_RPM, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rpm -i $CORRETTO_RPM
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rpm -i $CORRETTO_RPM, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -r $CORRETTO_RPM
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rm -r $CORRETTO_RPM, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi
