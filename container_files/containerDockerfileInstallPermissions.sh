#!/bin/bash

if [ $# -lt 2 ]; then
    echo 'pass in user and group, e.g. /opt/container_files/containerDockerfileInstallPermissions.sh tomcat root'
    exit 1
fi

user=$1
group=$2

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts ! -user $user -print | wc -l)
if [ $lines -ne 0 ]; then
  chown $user:$group $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts ! -user $user -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chown $user:$group \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts ! -user $user -print), result: $returnCode"
fi

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts ! -group $group -print | wc -l)
if [ $lines -ne 0 ]; then
  chown $user:$group $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts ! -group $group -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chown $user:$group \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts ! -group $group -print), result: $returnCode"
fi

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d ! -perm -g+rws | wc -l)
if [ $lines -ne 0 ]; then
  chmod g+rws $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d ! -perm -g+rws)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod g+rws \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d ! -perm -g+rws ), result: $returnCode"
fi

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -type f ! -perm -g+rw | wc -l)
if [ $lines -ne 0 ]; then
  chmod g+rw $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -type f ! -perm -g+rw)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod g+rw \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -type f ! -perm -g+rw ), result: $returnCode"
fi

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -perm -o+w | wc -l)
if [ $lines -ne 0 ]; then
  chmod o-w $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -perm -o+w)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod o-w \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -perm -o+w ), result: $returnCode"
fi

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" ! -perm -g+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" ! -perm -g+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name \"*.sh\" ! -perm -g+x), result: $returnCode"
fi

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" ! -perm -u+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" ! -perm -u+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name \"*.sh\" ! -perm -u+x), result: $returnCode"
fi

lines=$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" ! -perm -o+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" ! -perm -o+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name \"*.sh\" ! -perm -o+x), result: $returnCode"
fi

/opt/container_files/containerDockerfileInstallDos2unix.sh /usr/local/bin
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) /opt/container_files/containerDockerfileInstallDos2unix.sh /usr/local/bin, result: $returnCode"

find /usr/local/bin/ -type f -print0 | xargs -0 dos2unix
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) find /usr/local/bin/ -type f -print0 | xargs -0 dos2unix, result: $returnCode"

lines=$(find /usr/local/bin -type f ! -perm -g+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /usr/local/bin -type f ! -perm -g+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /usr/local/bin -type f ! -perm -g+x), result: $returnCode"
fi

lines=$(find /usr/local/bin -type f ! -perm -o+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /usr/local/bin -type f ! -perm -o+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /usr/local/bin -type f ! -perm -o+x), result: $returnCode"
fi


lines=$(find /usr/local/bin -type f ! -perm -u+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /usr/local/bin -type f ! -perm -u+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /usr/local/bin -type f ! -perm -u+x), result: $returnCode"
fi
