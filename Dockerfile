FROM bigfleet/shibboleth_sp

# Define args and set a default value
ARG maintainer=tier
ARG imagename=grouper
ARG version=2.3.0

MAINTAINER $maintainer
LABEL Vendor="Internet2"
LABEL ImageType="Base"
LABEL ImageName=$imagename
LABEL ImageOS=centos7
LABEL Version=$version
ENV VERSION=$version
ENV TOMCAT_VERSION="6.0.35"
ENV WAIT_TIME=60

LABEL Build docker build --rm --tag $maintainer/$imagename .

ADD container_files /opt

RUN mkdir -p /opt/grouper/$VERSION \
      && mv /opt/etc/grouper.installer.properties /opt/grouper/$VERSION/. \
      && mv /opt/etc/MariaDB.repo /etc/yum.repos.d/MariaDB.repo \
      && curl -o /opt/grouper/$VERSION/grouperInstaller.jar http://software.internet2.edu/grouper/release/$VERSION/grouperInstaller.jar \
      && yum -y update \
      && yum -y install --setopt=tsflags=nodocs \
        dos2unix \
        java-1.8.0-openjdk \
        java-1.8.0-openjdk-devel \
        MariaDB-client \
        supervisor \
        mlocate \
      && yum clean all

# The installer creates a HSQL DB which we ignore later

RUN mkdir -p /var/log/supervisor
RUN mv /etc/supervisord.conf /etc/supervisord.conf.old
COPY container_files/conf/supervisord.conf /etc
WORKDIR /opt/grouper/$version
RUN java -cp :grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller

VOLUME /opt/grouper/2.3.0/apache-tomcat-$TOMCAT_VERSION/logs

EXPOSE 8080 8009 8005
CMD ["/usr/bin/supervisord"]
#CMD ["/opt/bin/start.sh"]
