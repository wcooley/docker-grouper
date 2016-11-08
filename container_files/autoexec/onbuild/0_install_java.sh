#!/bin/bash

# Override this file with a version with the following commented out in order to use Oracle JDK.

# Uncomment all the following lines to download the JDK to your Shibboleth IDP image.  By uncommenting these lines, you agree to the Oracle Binary Code License Agreement for Java SE (http://www.oracle.com/technetwork/java/javase/terms/license/index.html)

#JAVA_VERSION=8u101
#BUILD_VERSION b13
#JAVA_HOME /usr/java/latest

#wget -nv --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm && \
#    yum -y install /tmp/jdk-8-linux-x64.rpm && \
#    rm -f /tmp/jdk-8-linux-x64.rpm && \
#    alternatives --install /usr/bin/java jar $JAVA_HOME/bin/java 200000 && \
#    alternatives --install /usr/bin/javaws javaws $JAVA_HOME/bin/javaws 200000 && \
#    alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 200000

yum -y install --setopt=tsflags=nodocs \
  java-1.8.0-openjdk \
  java-1.8.0-openjdk-devel

cd /opt/grouper/$VERSION && java -cp :grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller