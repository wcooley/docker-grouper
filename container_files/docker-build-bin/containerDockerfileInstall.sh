#!/bin/bash

# $1 ARG JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
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

mkdir -p /opt/tomcat/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomcat/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar /opt/grouper/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar /opt/grouper/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/grouper/$GROUPER_VERSION/container/tomcat/* /opt/tomcat/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$GROUPER_VERSION/container/tomcat/* /opt/tomcat/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomcat/temp
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomcat/temp, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomcat/work
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomcat/work, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/grouper/$GROUPER_VERSION/container/webapp/* /opt/grouper/grouperWebapp/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/grouper/$GROUPER_VERSION/container/webapp/* /opt/grouper/grouperWebapp/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -rf /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -rf /opt/grouper/$GROUPER_VERSION, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -rf /opt/tomcat/webapps/ROOT /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs/ /opt/tomcat/webapps/host-manager/ /opt/tomcat/webapps/manager/ /opt/tomcat/logs/* /opt/tomcat/temp/* /opt/tomcat/work/* /opt/tomcat/conf/logging.properties
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -rf /opt/tomcat/webapps/ROOT /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs/ /opt/tomcat/webapps/host-manager/ /opt/tomcat/webapps/manager/ /opt/tomcat/logs/* /opt/tomcat/temp/* /opt/tomcat/work/*\ /opt/tomcat/conf/logging.properties, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp -R /opt/container_files/grouperWebapp/* /opt/grouper/grouperWebapp
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp -R /opt/container_files/grouperWebapp/* /opt/grouper/grouperWebapp, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp -R /opt/container_files/tomcat/* /opt/tomcat/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp -R /opt/container_files/tomcat/* /opt/tomcat/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/tomcat/conf/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomcat/conf/Catalina/localhost/, result: $returnCode"
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

rm -f /opt/tomcat/bin/log4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/tomcat/bin/log4j-*, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/tier-support/log4j_fix/tomcatBin/log4j-* /opt/tomcat/bin/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/tomcatBin/log4j-* /opt/tomcat/bin/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

rm -f /opt/tomcat/lib/slf4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) rm -f /opt/tomcat/lib/slf4j-*, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mv /opt/tier-support/log4j_fix/tomcatLib/slf4j-* /opt/tomcat/lib/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/tier-support/log4j_fix/tomcatLib/slf4j-* /opt/tomcat/lib/, result: $returnCode"
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

mkdir -p /opt/tomcat/work/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/tomcat/work/Catalina/localhost/, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/grouper/certs/client
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/certs/client, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

mkdir -p /opt/grouper/certs/anchors
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mkdir -p /opt/grouper/certs/anchors, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

#mv /opt/container_files/certs/* /opt/grouper/certs/
#returnCode=$?
#echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) mv /opt/container_files/certs/* /opt/grouper/certs/, result: $returnCode"
#if [ $returnCode != 0 ]; then exit $returnCode; fi

chmod u+w $JAVA_HOME/lib/security/cacerts
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod u+w $JAVA_HOME/lib/security/cacerts , result=$returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi  
  
/usr/lib/jvm/java/bin/keytool -import -noprompt -cacerts -storepass changeit -alias "localhost" -file "/opt/container_files/certs/localhost.pem"
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) /usr/lib/jvm/java/bin/keytool -import -noprompt -cacerts -storepass changeit -alias \"localhost\" -file \"/opt/container_files/certs/localhost.pem\" , result=$returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi  
        
chmod u-w $JAVA_HOME/lib/security/cacerts
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) chmod u-w $JAVA_HOME/lib/security/cacerts , result=$returnCode"
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

cp /opt/tomcat/conf/server.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/tomcat/conf/server.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /opt/tomcat/conf/Catalina/localhost/grouper.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/tomcat/conf/Catalina/localhost/grouper.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

cp /opt/grouper/grouperWebapp/WEB-INF/web.xml /opt/tier-support/originalFiles 2>/dev/null
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) cp /opt/grouper/grouperWebapp/WEB-INF/web.xml /opt/tier-support/originalFiles 2>/dev/null, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

/opt/container_files/docker-build-bin/containerDockerfileInstallPermissions.sh tomcat root
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstall.sh) /opt/container_files/docker-build-bin/containerDockerfileInstallPermissions.sh tomcat root, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

