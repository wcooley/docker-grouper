FROM --platform=$TARGETPLATFORM rockylinux:8.8

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper" \
      ImageName=$imagename \
      ImageOS=centos7

ARG GROUPER_CONTAINER_VERSION

ENV GROUPER_VERSION=5.4.0 \
    GROUPER_CONTAINER_VERSION=5.4.0 \
    JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto \
    PATH=$PATH:$JAVA_HOME/bin \
    GROUPER_HOME=/opt/grouper/grouperWebapp/WEB-INF

#  net-tools curl mlocate strace telnet man vim rsyslog cron mod_ssl cronie
RUN yum update -y \
    && yum install -y logrotate python3-pip rsync sudo patch wget tar unzip dos2unix file net-tools diffutils curl mlocate logrotate strace telnet man vim rsyslog cronie findutils \
    && pip3 install --upgrade setuptools \
    && yum clean -y all \
    && groupadd -r tomcat \
    && useradd -r -m -s /sbin/nologin -g tomcat tomcat \
    && mkdir -p /opt/container_files

# Install Corretto Java JDK
#Corretto download page: https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html

# Install Corretto Java JDK (newer more arch independent way)
RUN rpm --import https://yum.corretto.aws/corretto.key \
    && curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo \
    && yum install -y java-17-amazon-corretto-devel

# real copy command (if not caching), uncomment this and change comments of COPY above to work on install script
COPY container_files/ /opt/container_files/

# TODO put this back in one command
RUN chmod +x /opt/container_files/docker-build-bin/*.sh
RUN /opt/container_files/docker-build-bin/containerDockerfileInstallDos2unix.sh /opt/container_files 
RUN /opt/container_files/docker-build-bin/containerDockerfileInstallGrouper.sh $JAVA_HOME $GROUPER_VERSION
RUN /opt/container_files/docker-build-bin/containerDockerfileInstall.sh $JAVA_HOME $GROUPER_VERSION


# testing container
# see output with  docker build . --tag my:grouper
# DOCKER_BUILDKIT=0 docker build --progress=plain -t mygrouper .
# docker run --detach --name mygrouper mygrouper:latest
# docker exec -it mygrouper bash

WORKDIR /opt/grouper/grouperWebapp/WEB-INF/
EXPOSE 80 443
HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["ping"]
#CMD ["google.com"]
