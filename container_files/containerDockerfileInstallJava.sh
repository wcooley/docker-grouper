#!/bin/bash

# $1 ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
# $2 ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm
# $3 ARG JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
# $4 ARG GROUPER_VERSION=2.6.14

curl -O -L $1
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) curl -O -L $1, result: $returnCode"

rpm --import /opt/container_files/java-corretto/corretto-signing-key.pub
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rpm --import /opt/container_files/java-corretto/corretto-signing-key.pub corretto-signing-key.pub, result: $returnCode"

rpm -K $2
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rpm -K $2, result: $returnCode"

rpm -i $2
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rpm -i $2, result: $returnCode"

rm -r $2
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rm -r $2, result: $returnCode"

