#!/bin/bash

# $1 ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
# $2 ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm
# $3 ARG JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
# $4 ARG GROUPER_VERSION=2.6.14

mv /opt/container_files/tier-support /opt
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) mv /opt/container_files/tier-support /opt, result: $returnCode"

mkdir -p /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) , result: $returnCode"

wget -q -O /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar https://oss.sonatype.org/service/local/repositories/releases/content/edu/internet2/middleware/grouper/grouper-installer/$GROUPER_VERSION/grouper-installer-$GROUPER_VERSION.jar
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) wget -q -O /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar https://oss.sonatype.org/service/local/repositories/releases/content/edu/internet2/middleware/grouper/grouper-installer/$GROUPER_VERSION/grouper-installer-$GROUPER_VERSION.jar, result: $returnCode"

mv /opt/container_files/grouper.installer.properties /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) mv /opt/container_files/grouper.installer.properties /opt/grouper/$GROUPER_VERSION, result: $returnCode"

# Temporary morphString file used for building, not used in production
mv /opt/container_files/morphString.properties /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) mv /opt/container_files/morphString.properties /opt/grouper/$GROUPER_VERSION, result: $returnCode"

cd /opt/grouper/$GROUPER_VERSION/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) cd /opt/grouper/$GROUPER_VERSION/, result: $returnCode"

$JAVA_HOME/bin/java -cp :grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) $JAVA_HOME/bin/java -cp :grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller, result: $returnCode"

