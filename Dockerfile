FROM i2incommon/shib-sp:3.3.0_09152022-rocky8-multi-arch-test

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper" \
      ImageName=$imagename \
      ImageOS=centos7

ARG GROUPER_CONTAINER_VERSION

ENV GROUPER_VERSION=2.6.16 \
    GROUPER_CONTAINER_VERSION=$GROUPER_CONTAINER_VERSION \
    PATH=$PATH:$JAVA_HOME/bin \
    GROUPER_HOME=/opt/grouper/grouperWebapp/WEB-INF

# net-tools curl mlocate strace telnet man vim rsyslog cron httpd mod_ssl cronie
RUN yum update -y \
    && yum install -y logrotate python3-pip rsync sudo patch supervisor wget tar unzip dos2unix file \
    && pip3 install --upgrade setuptools \
    && yum clean -y all \
    && groupadd -r tomcat \
    && useradd -r -m -s /sbin/nologin -g tomcat tomcat \
    && mkdir -p /opt/container_files

# Install Corretto Java JDK (newer more arch independent way)
RUN rpm --import https://yum.corretto.aws/corretto.key \
    && curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo \
    && yum install -y java-1.8.0-amazon-corretto-devel

# Old way to install 
#Corretto download page: https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html
ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm



# real copy command (if not caching), uncomment this and change comments of COPY above to work on install script
COPY container_files/ /opt/container_files/

RUN cd /tmp && chmod +x /opt/container_files/docker-build-bin/*.sh \
    && /opt/container_files/docker-build-bin/containerDockerfileInstallDos2unix.sh /opt/container_files \
    && /opt/container_files/docker-build-bin/containerDockerfileInstallGrouper.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION \
    && /opt/container_files/docker-build-bin/containerDockerfileInstall.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION

#    // old way of installing java, hard-coded arch and URL
#    // && /opt/container_files/docker-build-bin/containerDockerfileInstallJava.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION \

# testing container
# see output with  docker build . --tag my:grouper
# DOCKER_BUILDKIT=0 docker build --progress=plain -t mygrouper .
# docker run --detach --name mygrouper mygrouper:latest
# docker exec -it mygrouper bash

WORKDIR /opt/grouper/grouperWebapp/WEB-INF/
EXPOSE 80 443
HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
