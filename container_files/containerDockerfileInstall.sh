#!/bin/bash

# $1 ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
# $2 ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm
# $3 ARG JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
# $4 ARG GROUPER_VERSION=2.6.14

chmod 775 $(find /opt/container_files -type d)
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod 775 \$(find /opt/container_files -type d), result: $returnCode"

chmod 664 $(find /opt/container_files -type f)
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod 664 \$(find /opt/container_files -type f), result: $returnCode"

chmod 775 $(find /opt/container_files -type f -name "*.sh")
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod 775 \$(find /opt/container_files -type f -name \"*.sh\"), result: $returnCode"

mkdir -p /opt/grouper/grouperWebapp/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/grouperWebapp/, result: $returnCode"

mkdir -p /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/, result: $returnCode"

mv /opt/grouper/$4/grouperInstaller.jar /opt/grouper/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$4/grouperInstaller.jar /opt/grouper/, result: $returnCode"

mv /opt/grouper/$4/container/tomee/* /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$4/container/tomee/* /opt/tomee/, result: $returnCode"

mkdir -p /opt/tomee/temp
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/temp, result: $returnCode"

mkdir -p /opt/tomee/work
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/work, result: $returnCode"

mv /opt/grouper/$4/container/webapp/* /opt/grouper/grouperWebapp/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$4/container/webapp/* /opt/grouper/grouperWebapp/, result: $returnCode"

rm -rf /opt/grouper/$4
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -rf /opt/grouper/$4, result: $returnCode"

rm -rf /opt/tomee/webapps/docs/ /opt/tomee/webapps/host-manager/ /opt/tomee/webapps/manager/ /opt/tomee/logs/* /opt/tomee/temp/* /opt/tomee/work/* /opt/tomee/conf/logging.properties
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -rf /opt/tomee/webapps/docs/ /opt/tomee/webapps/host-manager/ /opt/tomee/webapps/manager/ /opt/tomee/logs/* /opt/tomee/temp/* /opt/tomee/work/*\ /opt/tomee/conf/logging.properties, result: $returnCode"

cp -R /opt/container_files/api/* /opt/grouper/grouperWebapp/WEB-INF/classes/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp -R /opt/container_files/api/* /opt/grouper/grouperWebapp/WEB-INF/classes/, result: $returnCode"

cp -R /opt/container_files/tomee/* /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp -R /opt/container_files/tomee/* /opt/tomee/, result: $returnCode"

mkdir -p /opt/tomee/conf/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/conf/Catalina/localhost/, result: $returnCode"

ln -sf /usr/share/zoneinfo/UTC /etc/localtime
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) ln -sf /usr/share/zoneinfo/UTC /etc/localtime, result: $returnCode"

rm -f /etc/alternatives/java
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /etc/alternatives/java, result: $returnCode"

ln -s $3/bin/java /etc/alternatives/java
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) ln -s $3/bin/java /etc/alternatives/java, result: $returnCode"

mv /opt/container_files/tier-support /opt
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/tier-support /opt, result: $returnCode"

mv /opt/container_files/usr-local-bin/* /usr/local/bin/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/usr-local-bin/* /usr/local/bin/, result: $returnCode"

mv /opt/container_files/httpd/* /etc/httpd/conf.d/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/httpd/* /etc/httpd/conf.d/, result: $returnCode"

mv /opt/container_files/shibboleth/* /etc/shibboleth/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/shibboleth/* /etc/shibboleth/, result: $returnCode"

cp /dev/null /etc/httpd/conf.d/ssl.conf
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /dev/null /etc/httpd/conf.d/ssl.conf, result: $returnCode"

rm -f /opt/tomee/bin/log4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/tomee/bin/log4j-*, result: $returnCode"

mv /opt/tier-support/log4j_fix/tomeeBin/log4j-* /opt/tomee/bin/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/tomeeBin/log4j-* /opt/tomee/bin/, result: $returnCode"

rm -f /opt/tomee/lib/slf4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/tomee/lib/slf4j-*, result: $returnCode"

mv /opt/tier-support/log4j_fix/tomeeLib/slf4j-* /opt/tomee/lib/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/tomeeLib/slf4j-* /opt/tomee/lib/, result: $returnCode"

rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*, result: $returnCode"

mv /opt/tier-support/log4j_fix/webinfLib/* /opt/grouper/grouperWebapp/WEB-INF/lib/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/webinfLib/* /opt/grouper/grouperWebapp/WEB-INF/lib/, result: $returnCode"

touch /opt/grouper/grouperEnv.sh
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) touch /opt/grouper/grouperEnv.sh, result: $returnCode"

mkdir -p /opt/tomee/work/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/work/Catalina/localhost/, result: $returnCode"

mkdir -p /opt/grouper/certs/client
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/certs/client, result: $returnCode"

mkdir -p /opt/grouper/certs/anchors
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/certs/anchors, result: $returnCode"

mv /opt/container_files/certs/* /opt/grouper/certs/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/certs/* /opt/grouper/certs/, result: $returnCode"

echo 'umask 002' >> /home/tomcat/.bashrc
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) echo 'umask 002' >> /home/tomcat/.bashrc, result: $returnCode"

mkdir -p /opt/tier-support/originalFiles
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tier-support/originalFiles, result: $returnCode"

cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

cp /etc/httpd/conf/httpd.conf /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf/httpd.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

cp /etc/httpd/conf.d/ssl-enabled.conf /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf.d/ssl-enabled.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

cp /etc/httpd/conf.d/httpd-shib.conf /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf.d/httpd-shib.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

cp /etc/httpd/conf.d/shib.conf /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf.d/shib.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

cp /opt/tomee/conf/server.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/tomee/conf/server.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

cp /opt/tomee/conf/Catalina/localhost/grouper.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/tomee/conf/Catalina/localhost/grouper.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

cp /opt/grouper/grouperWebapp/WEB-INF/web.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/grouper/grouperWebapp/WEB-INF/web.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"

/opt/container_files/containerDockerfileInstallPermissions.sh tomcat root
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) /opt/container_files/containerDockerfileInstallPermissions.sh tomcat root, result: $returnCode"

