#!/bin/bash

if [ $# -lt 2 ]; then
    echo 'pass in user and group, e.g. /opt/container_files/docker-build-bin/containerDockerfileInstallPermissions.sh tomcat root'
    exit 1
fi

user=$1
group=$2

# this needs to exist
mkdir -p /opt/tier

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -user $user -print | wc -l)
if [ $lines -ne 0 ]; then
  chown $user:$group $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -user $user -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chown $user:$group \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -user $user -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -group $group -print | wc -l)
if [ $lines -ne 0 ]; then
  chown $user:$group $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -group $group -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chown $user:$group \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -group $group -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+rwxs | wc -l)
if [ $lines -ne 0 ]; then
  chmod g+rwxs $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+rwxs)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod g+rwxs \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ -type d -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+rwxs ), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -type f -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+rw | wc -l)
if [ $lines -ne 0 ]; then
  chmod g+rw $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -type f -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+rw)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod g+rw \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -type f -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+rw ), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -perm -o+w -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot | wc -l)
if [ $lines -ne 0 ]; then
  chmod o-w $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -perm -o+w -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod o-w \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /usr/local/bin /etc/httpd/conf.d/ /usr/lib/jvm/java/jre/lib/security/cacerts -perm -o+w -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" ! -perm -g+x -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name \"*.sh\" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -g+x), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -u+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -u+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name \"*.sh\" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -u+x), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -o+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name "*.sh" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -o+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /home/$user /opt/container_files/ /opt/grouper/ /opt/tier/ /opt/tier-support/ /opt/tomee/ /etc/httpd/conf/ /home/tomcat/ /etc/httpd/conf.d/ -type f -name \"*.sh\" -not -path /opt/grouper/slashRoot/* -not -path /opt/grouper/slashRoot ! -perm -o+x), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

/opt/container_files/docker-build-bin/containerDockerfileInstallDos2unix.sh /usr/local/bin
returnCode=$?
echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) /opt/container_files/docker-build-bin/containerDockerfileInstallDos2unix.sh /usr/local/bin, result: $returnCode"
if [ $returnCode != 0 ]; then exit $returnCode; fi

lines=$(find /usr/local/bin -type f ! -perm -g+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /usr/local/bin -type f ! -perm -g+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /usr/local/bin -type f ! -perm -g+x), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /usr/local/bin -type f ! -perm -o+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /usr/local/bin -type f ! -perm -o+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /usr/local/bin -type f ! -perm -o+x), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi


lines=$(find /usr/local/bin -type f ! -perm -u+x | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /usr/local/bin -type f ! -perm -u+x)
  returnCode=$?
  echo "grouperDockerfile; INFO: (containerDockerfileInstallPermissions.sh) chmod +x \$(find /usr/local/bin -type f ! -perm -u+x), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi
