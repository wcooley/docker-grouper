FROM tier/shibboleth_sp:3.1.0_04172020

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper" \
      ImageName=$imagename \
      ImageOS=centos7
      
ARG GROUPER_CONTAINER_VERSION

ENV GROUPER_VERSION=2.6.15 \
    GROUPER_CONTAINER_VERSION=$GROUPER_CONTAINER_VERSION \
    JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto \
    PATH=$PATH:$JAVA_HOME/bin \
    GROUPER_HOME=/opt/grouper/grouperWebapp/WEB-INF

RUN yum update -y \
    && yum install -y logrotate python3-pip rsync sudo patch supervisor wget tar unzip dos2unix file \
    && pip3 install --upgrade setuptools \
    && yum clean -y all \
    && groupadd -r tomcat \
    && useradd -r -m -s /sbin/nologin -g tomcat tomcat \
    && mkdir -p /opt/container_files

# Install Corretto Java JDK
#Corretto download page: https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html
ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm

# if we are doing layers for caching while developing the container, can call run from here and not from containreDockerfileInstall.sh...
#COPY container_files/containerDockerfileInstallJava.sh /opt/container_files/
#COPY container_files/morphString.properties /opt/container_files/
#COPY container_files/grouper.installer.properties /opt/container_files/
#COPY container_files/containerDockerfileInstallGrouper.sh /opt/container_files/

#RUN cd /tmp \
#    && chmod +x /opt/container_files/*.sh \
#    && if [ $(find /opt/container_files -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1 | wc -l) -ne 0 ]; then dos2unix $(find /opt/container_files -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1)  ; fi; \
#    && /opt/container_files/containerDockerfileInstallJava.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION \
#    && /opt/container_files/containerDockerfileInstallGrouper.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION 

# real copy command (if not caching), uncomment this and change comments of COPY above to work on install script
COPY container_files/ /opt/container_files/

#RUN cd /tmp \
#    && chmod +x /opt/container_files/*.sh \
#    && if [ $(find /opt/container_files -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1 | wc -l) -ne 0 ]; then dos2unix $(find /opt/container_files -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1)  ; fi; \
#    && /opt/container_files/containerDockerfileInstall.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION

RUN cd /tmp \
    && chmod +x /opt/container_files/*.sh \
    && if [ $(find /opt/container_files -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1 | wc -l) -ne 0 ]; then dos2unix $(find /opt/container_files -type f -name "*.sh" -exec file "{}" ";"   | grep CRLF | cut -d: -f1)  ; fi; \
    && /opt/container_files/containerDockerfileInstallJava.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION \
    && /opt/container_files/containerDockerfileInstallGrouper.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION \
    && /opt/container_files/containerDockerfileInstall.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION


# testing container
# see output with  docker build . --tag my:grouper
# DOCKER_BUILDKIT=0 docker build --progress=plain -t mygrouper .
# docker run --detach --name mygrouper mygrouper:latest
# docker exec -it mygrouper bash

WORKDIR /opt/grouper/grouperWebapp/WEB-INF/
EXPOSE 80 443
HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
## uncomment ping, and comment out other entrypoint to just have a simple runnable container
#ENTRYPOINT ["ping"]
#CMD ["google.com"]