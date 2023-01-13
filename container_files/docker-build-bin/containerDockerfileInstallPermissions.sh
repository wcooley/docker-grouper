#!/bin/bash

if [ $# -lt 2 ]; then
    echo 'pass in user and group, e.g. /opt/container_files/docker-build-bin/containerDockerfileInstallPermissions.sh tomcat root'
    exit 1
fi

user=$1
group=$2

# this needs to exist
mkdir -p /opt/tier

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o ! -user $user -print | wc -l)
if [ $lines -ne 0 ]; then
  chown $user:$group $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o ! -user $user -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chown $user:$group \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o ! -user $user -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o ! -group $group -print | wc -l)
if [ $lines -ne 0 ]; then
  chown $user:$group $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o ! -group $group -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chown $user:$group \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o ! -group $group -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type d ! -perm -g+rwxs -print | wc -l)
if [ $lines -ne 0 ]; then
  chmod g+rwxs $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type d ! -perm -g+rwxs -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chmod g+rwxs \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type d ! -perm -g+rwxs -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f ! -perm -g+rw -print | wc -l)
if [ $lines -ne 0 ]; then
  chmod g+rw $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f ! -perm -g+rw -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chmod g+rw \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f ! -perm -g+rw -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -perm -o+w -print | wc -l)
if [ $lines -ne 0 ]; then
  chmod o-w $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -perm -o+w -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chmod o-w \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /usr/local/bin /etc/httpd/conf.d $JAVA_HOME/lib/security/cacerts -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -perm -o+w -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name "*.sh" ! -perm -g+x -print -print | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name "*.sh" ! -perm -g+x -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chmod +x \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name \"*.sh\" ! -perm -g+x -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name "*.sh" ! -perm -u+x -print | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name "*.sh" ! -perm -u+x -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chmod +x \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name \"*.sh\" ! -perm -u+x -print), result: $returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi

lines=$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name "*.sh" ! -perm -o+x -print | wc -l)
if [ $lines -ne 0 ]; then
  chmod +x $(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name "*.sh" ! -perm -o+x -print)
  returnCode=$?
  echo "grouperDockerfile; INFO: ($0) chmod +x \$(find /home/$user /opt/container_files /opt/grouper /opt/tier /opt/tier-support /opt/tomcat /etc/httpd/conf /home/tomcat /etc/httpd/conf.d -path /opt/grouper/slashRoot -prune -o -path /opt/grouper/logs -prune -o -type f -name \"*.sh\" ! -perm -o+x -print), result: $returnCode"
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
