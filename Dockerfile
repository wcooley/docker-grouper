FROM tier/shibboleth_sp:3.1.0_04172020

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper" \
      ImageName=$imagename \
      ImageOS=centos7
      

# see output with DOCKER_BUILDKIT=0 docker build . --tag my:grouper

RUN groupadd -r tomcat \
    && useradd -r -m -s /sbin/nologin -g tomcat tomcat
   
ARG GROUPER_CONTAINER_VERSION

ENV GROUPER_VERSION=2.6.14 \
    GROUPER_CONTAINER_VERSION=$GROUPER_CONTAINER_VERSION \
    JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto \
    PATH=$PATH:$JAVA_HOME/bin \
    GROUPER_HOME=/opt/grouper/grouperWebapp/WEB-INF

COPY container_files/ /opt/container_files/

# only needed if not building grouper (testing container)
#RUN mkdir -p /opt/grouper/$GROUPER_VERSION/container/tomee
#RUN mkdir -p /opt/grouper/$GROUPER_VERSION/container/webapp
#COPY grouper-installer-2.6.14.jar /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar
#COPY opt_tomee/ /opt/grouper/$GROUPER_VERSION/container/tomee/
#COPY opt_grouper/ /opt/grouper/$GROUPER_VERSION/container/webapp/
# end if not need building container

# Install Corretto Java JDK
#Corretto download page: https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html
ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm

RUN chmod +x /opt/container_files/*.sh \
    && /opt/container_files/containerDockerfileInstall.sh $CORRETTO_URL_PERM $CORRETTO_RPM $JAVA_HOME $GROUPER_VERSION

WORKDIR /opt/grouper/grouperWebapp/WEB-INF/
EXPOSE 80 443
HEALTHCHECK NONE
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# testing container
#ENTRYPOINT ["ping"]
#CMD ["google.com"]


