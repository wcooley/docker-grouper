#!/bin/bash

# $1 ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
# $2 ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm
# $3 ARG JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
# $4 ARG GROUPER_VERSION=2.6.14

yum update -y
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) yum update -y, result: $returnCode"

yum install -y wget tar unzip dos2unix patch
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) yum install -y wget tar unzip dos2unix patch, result: $returnCode"

yum clean all
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) yum clean all, result: $returnCode"

curl -O -L $1
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) curl -O -L $1, result: $returnCode"

rpm --import /opt/container_files/java-corretto/corretto-signing-key.pub corretto-signing-key.pub
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

mv /opt/container_files/tier-support /opt
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) mv /opt/container_files/tier-support /opt, result: $returnCode"

mkdir -p /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) , result: $returnCode"

wget -q -O /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar https://oss.sonatype.org/service/local/repositories/releases/content/edu/internet2/middleware/grouper/grouper-installer/$GROUPER_VERSION/grouper-installer-$GROUPER_VERSION.jar
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) wget -q -O /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar https://oss.sonatype.org/service/local/repositories/releases/content/edu/internet2/middleware/grouper/grouper-installer/$GROUPER_VERSION/grouper-installer-$GROUPER_VERSION.jar, result: $returnCode"

mv /opt/container_files/grouper.installer.properties /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) mv /opt/container_files/grouper.installer.properties /opt/grouper/$GROUPER_VERSION, result: $returnCode"

# Temporary morphString file used for building, not used in production
mv /opt/container_files/morphString.properties /opt/grouper/$GROUPER_VERSION
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) mv /opt/container_files/morphString.properties /opt/grouper/$GROUPER_VERSION, result: $returnCode"

cd /opt/grouper/$GROUPER_VERSION/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) cd /opt/grouper/$GROUPER_VERSION/, result: $returnCode"

$JAVA_HOME/bin/java -cp :grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) $JAVA_HOME/bin/java -cp :grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller, result: $returnCode"

mkdir -p /opt/grouper/grouperWebapp/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) mkdir -p /opt/grouper/grouperWebapp/, result: $returnCode"

mkdir -p /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) mkdir -p /opt/tomee/, result: $returnCode"

mv /opt/grouper/$4/grouperInstaller.jar /opt/grouper/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) cp /opt/grouper/$4/grouperInstaller.jar /opt/grouper/, result: $returnCode"

mv /opt/grouper/$4/container/tomee/* /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) cp -R /opt/grouper/$4/container/tomee/* /opt/tomee/, result: $returnCode"

mv /opt/grouper/$4/container/webapp/* /opt/grouper/grouperWebapp/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) cp -R /opt/grouper/$4/container/webapp/grouperWebapp/* /opt/grouper/grouperWebapp/, result: $returnCode"

rm -rf /opt/grouper/$4
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rm -rf /opt/grouper/$4, result: $returnCode"

rm -fr /opt/tomee/webapps/docs/ /opt/tomee/webapps/host-manager/ /opt/tomee/webapps/manager/ /opt/tomee/logs/* /opt/tomee/temp/* /opt/tomee/work/* /opt/tomee/conf/logging.properties
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) rm -fr /opt/tomee/webapps/docs/ /opt/tomee/webapps/host-manager/ /opt/tomee/webapps/manager/ /opt/tomee/logs/* /opt/tomee/temp/* /opt/tomee/work/*\ /opt/tomee/conf/logging.properties, result: $returnCode"

cp -R /opt/container_files/api/* /opt/grouper/grouperWebapp/WEB-INF/classes/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) cp -R /opt/container_files/api/* /opt/grouper/grouperWebapp/WEB-INF/classes/, result: $returnCode"

cp -R /opt/container_files/tomee/* /opt/tomee/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) cp -R /opt/container_files/tomee/* /opt/tomee/, result: $returnCode"

mkdir -p /opt/tomee/conf/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallJava.sh) mkdir -p /opt/tomee/conf/Catalina/localhost/, result: $returnCode"

ln -sf /usr/share/zoneinfo/UTC /etc/localtime
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) ln -sf /usr/share/zoneinfo/UTC /etc/localtime, result: $returnCode"

rm -f /etc/alternatives/java
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) rm -f /etc/alternatives/java, result: $returnCode"

ln -s $3/bin/java /etc/alternatives/java
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) ln -s $3/bin/java /etc/alternatives/java, result: $returnCode"

mv /opt/container_files/usr-local-bin/* /usr/local/bin/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mv /opt/container_files/usr-local-bin/* /usr/local/bin/, result: $returnCode"

chmod +x /usr/local/bin/*.sh
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) chmod +x /usr/local/bin/*.sh, result: $returnCode"

mv /opt/container_files/httpd/* /etc/httpd/conf.d/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mv /opt/container_files/httpd/* /etc/httpd/conf.d/, result: $returnCode"

mv /opt/container_files/shibboleth/* /etc/shibboleth/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mv /opt/container_files/shibboleth/* /etc/shibboleth/, result: $returnCode"

cp /dev/null /etc/httpd/conf.d/ssl.conf
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) cp /dev/null /etc/httpd/conf.d/ssl.conf, result: $returnCode"

rm -f /opt/tomee/bin/log4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) rm -f /opt/tomee/bin/log4j-*, result: $returnCode"

mv /opt/tier-support/log4j_fix/tomeeBin/log4j-* /opt/tomee/bin/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mv /opt/tier-support/log4j_fix/tomeeBin/log4j-* /opt/tomee/bin/, result: $returnCode"

rm -f /opt/tomee/lib/slf4j-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) rm -f /opt/tomee/lib/slf4j-*, result: $returnCode"

mv /opt/tier-support/log4j_fix/tomeeLib/slf4j-* /opt/tomee/lib/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mv /opt/tier-support/log4j_fix/tomeeLib/slf4j-* /opt/tomee/lib/, result: $returnCode"

rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) rm -f /opt/grouper/grouperWebapp/WEB-INF/lib/slf4j-api-*, result: $returnCode"

mv /opt/tier-support/log4j_fix/webinfLib/* /opt/grouper/grouperWebapp/WEB-INF/lib/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mv /opt/tier-support/log4j_fix/webinfLib/* /opt/grouper/grouperWebapp/WEB-INF/lib/, result: $returnCode"

touch /opt/grouper/grouperEnv.sh
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) touch /opt/grouper/grouperEnv.sh, result: $returnCode"

mkdir -p /opt/tomee/work/Catalina/localhost/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mkdir -p /opt/tomee/work/Catalina/localhost/, result: $returnCode"

mkdir -p /opt/grouper/certs/client
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mkdir -p /opt/grouper/certs/client, result: $returnCode"

mkdir -p /opt/grouper/certs/anchors
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mkdir -p /opt/grouper/certs/anchors, result: $returnCode"

mv /opt/container_files/certs/* /opt/grouper/certs/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) mv /opt/container_files/certs/* /opt/grouper/certs/, result: $returnCode"

chown tomcat:root  /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) chown tomcat:root  /opt/ /etc/httpd/conf/ /home/tomcat/ /opt/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts, result: $returnCode"

lines=$(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ ! -user tomcat -o ! -group root -print | wc -l)
if [ $lines -ne 0 ]; then
  chown -R tomcat:root $(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ ! -user tomcat -o ! -group root -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) chown -R tomcat:root \$(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ ! -user tomcat -o ! -group root -print), result: $returnCode"
fi

chmod g+rws /opt/ /etc/httpd/conf/ /home/tomcat/ /opt/ /usr/local/bin /etc/httpd/conf.d/
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) chmod g+rws /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/, result: $returnCode"

chmod g+rw /usr/lib/jvm/java/jre/lib/security/cacerts
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) chmod g+rw /usr/lib/jvm/java/jre/lib/security/cacerts, result: $returnCode"

lines=$(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d ! -perm -g+rws | wc -l)
if [ $lines -ne 0 ]; then
  chown -R tomcat:root $(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d ! -perm -g+rws)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) chmod -R g+rws \$(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d ! -perm -g+rws ), result: $returnCode"
fi

lines=$(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type f ! -perm -g+rw | wc -l)
if [ $lines -ne 0 ]; then
  chown -R tomcat:root $(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type f ! -perm -g+rw)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) chmod -R g+rw \$(find /opt/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type f ! -perm -g+rw ), result: $returnCode"
fi

#rm -rf /opt/container_files
#returnCode=$?
#echo "grouperDockerfile; INFO: (containerDockerfileShibLogic.sh) rm -rf /opt/container_files, result: $returnCode"

