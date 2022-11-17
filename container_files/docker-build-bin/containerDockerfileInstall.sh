#!/bin/bash

# $1 ARG JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
# $2 ARG GROUPER_VERSION=2.6.14
JAVA_HOME=$1
GROUPER_VERSION=$2

chmod 775 $(find /opt/container_files -type d)
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod 775 \$(find /opt/container_files -type d), result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

chmod 664 $(find /opt/container_files -type f)
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod 664 \$(find /opt/container_files -type f), result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

chmod 775 $(find /opt/container_files -type f -name "*.sh")
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod 775 \$(find /opt/container_files -type f -name \"*.sh\"), result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/grouper/grouperWebapp/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/grouperWebapp/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/grouper/logs/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/logs/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

chown -R tomcat.root /opt/grouper/logs/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chown tomcat.root /opt/grouper/logs/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

chmod -R g+rwxs /opt/grouper/logs/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod g+rwxs /opt/grouper/logs/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar /opt/grouper/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar /opt/grouper/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/grouper/$GROUPER_VERSION/container/tomee/* /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$GROUPER_VERSION/container/tomee/* /opt/tomee/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomee/temp
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/temp, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomee/work
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/work, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/grouper/$GROUPER_VERSION/container/webapp/* /opt/grouper/grouperWebapp/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$GROUPER_VERSION/container/webapp/* /opt/grouper/grouperWebapp/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -rf /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -rf /opt/grouper/$GROUPER_VERSION, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -rf /opt/tomee/webapps/docs/ /opt/tomee/webapps/host-manager/ /opt/tomee/webapps/manager/ /opt/tomee/logs/* /opt/tomee/temp/* /opt/tomee/work/* /opt/tomee/conf/logging.properties
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -rf /opt/tomee/webapps/docs/ /opt/tomee/webapps/host-manager/ /opt/tomee/webapps/manager/ /opt/tomee/logs/* /opt/tomee/temp/* /opt/tomee/work/*\ /opt/tomee/conf/logging.properties, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp -R /opt/container_files/grouperWebapp/* /opt/grouper/grouperWebapp
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp -R /opt/container_files/grouperWebapp/* /opt/grouper/grouperWebapp, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp -R /opt/container_files/tomee/* /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp -R /opt/container_files/tomee/* /opt/tomee/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomee/conf/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/conf/Catalina/localhost/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

ln -sf /usr/share/zoneinfo/UTC /etc/localtime
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) ln -sf /usr/share/zoneinfo/UTC /etc/localtime, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -f /etc/alternatives/java
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /etc/alternatives/java, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

ln -s $JAVA_HOME/bin/java /etc/alternatives/java
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) ln -s $JAVA_HOME/bin/java /etc/alternatives/java, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/container_files/usr-local-bin/* /usr/local/bin/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/usr-local-bin/* /usr/local/bin/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/container_files/httpd/* /etc/httpd/conf.d/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/httpd/* /etc/httpd/conf.d/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/container_files/shibboleth/* /etc/shibboleth/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/shibboleth/* /etc/shibboleth/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /dev/null /etc/httpd/conf.d/ssl.conf
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /dev/null /etc/httpd/conf.d/ssl.conf, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -f /opt/tomee/bin/log4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/tomee/bin/log4j-*, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/tier-support/log4j_fix/tomeeBin/log4j-* /opt/tomee/bin/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/tomeeBin/log4j-* /opt/tomee/bin/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -f /opt/tomee/lib/slf4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/tomee/lib/slf4j-*, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/tier-support/log4j_fix/tomeeLib/slf4j-* /opt/tomee/lib/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/tomeeLib/slf4j-* /opt/tomee/lib/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/tier-support/log4j_fix/webinfLib/* /opt/grouper/grouperWebapp/WEB-INF/lib/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/webinfLib/* /opt/grouper/grouperWebapp/WEB-INF/lib/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

touch /opt/grouper/grouperEnv.sh
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) touch /opt/grouper/grouperEnv.sh, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomee/work/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomee/work/Catalina/localhost/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/grouper/certs/client
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/certs/client, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/grouper/certs/anchors
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/certs/anchors, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/container_files/certs/* /opt/grouper/certs/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/certs/* /opt/grouper/certs/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

echo 'umask 002' >> /home/tomcat/.bashrc
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) echo 'umask 002' >> /home/tomcat/.bashrc, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tier-support/originalFiles
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tier-support/originalFiles, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /etc/httpd/conf/httpd.conf /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf/httpd.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /etc/httpd/conf.d/ssl-enabled.conf /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf.d/ssl-enabled.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

if [ -f /etc/httpd/conf.d/httpd-shib.conf ]; then
  cp /etc/httpd/conf.d/httpd-shib.conf /opt/tier-support/originalFiles 2>/dev/null
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf.d/httpd-shib.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

if [ -f /etc/httpd/conf.d/shib.conf ]; then
  cp /etc/httpd/conf.d/shib.conf /opt/tier-support/originalFiles 2>/dev/null
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /etc/httpd/conf.d/shib.conf /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

cp /opt/tomee/conf/server.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/tomee/conf/server.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /opt/tomee/conf/Catalina/localhost/grouper.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/tomee/conf/Catalina/localhost/grouper.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /opt/grouper/grouperWebapp/WEB-INF/web.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/grouper/grouperWebapp/WEB-INF/web.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

/opt/container_files/docker-build-bin/containerDockerfileInstallPermissions.sh tomcat root
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) /opt/container_files/docker-build-bin/containerDockerfileInstallPermissions.sh tomcat root, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

