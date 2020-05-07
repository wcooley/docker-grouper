FROM centos:centos7 as installing
RUN yum update -y \
    && yum install -y wget tar unzip dos2unix \
    && yum clean all
    
RUN yum install -y wget tar unzip dos2unix
    
ARG GROUPER_CONTAINER_VERSION
ENV GROUPER_VERSION=2.5.28 \
     GROUPER_CONTAINER_VERSION=$GROUPER_CONTAINER_VERSION

# Install Corretto Java JDK
#Corretto download page: https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html
ARG CORRETTO_URL_PERM=https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.rpm
ARG CORRETTO_RPM=amazon-corretto-8-x64-linux-jdk.rpm
COPY container_files/java-corretto/corretto-signing-key.pub .
RUN curl -O -L $CORRETTO_URL_PERM \
    && rpm --import corretto-signing-key.pub \
    && rpm -K $CORRETTO_RPM \
    && rpm -i $CORRETTO_RPM \
    && rm -r corretto-signing-key.pub $CORRETTO_RPM
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto

RUN echo 'Downloading Grouper Installer...' \
    && mkdir -p /opt/grouper/$GROUPER_VERSION \
    && wget -q -O /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar https://oss.sonatype.org/service/local/repositories/releases/content/edu/internet2/middleware/grouper/grouper-installer/$GROUPER_VERSION/grouper-installer-$GROUPER_VERSION.jar
COPY container_files/grouper.installer.properties /opt/grouper/$GROUPER_VERSION
# Temporary morphString file used for building, not used in production
COPY container_files/morphString.properties /opt/grouper/$GROUPER_VERSION
RUN echo 'Installing Grouper'; \
    PATH=$PATH:$JAVA_HOME/bin; \
    cd /opt/grouper/$GROUPER_VERSION/ \
    && $JAVA_HOME/bin/java -cp :grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller
FROM centos:centos7 as cleanup
ENV GROUPER_VERSION=2.5.28 \
    TOMEE_VERSION=7.0.0
RUN mkdir -p /opt/grouper/grouperWebapp/
RUN mkdir -p /opt/tomee/
COPY --from=installing /opt/grouper/$GROUPER_VERSION/grouperInstaller.jar /opt/grouper/
COPY --from=installing /opt/grouper/$GROUPER_VERSION/container/tomee/ /opt/tomee/
COPY --from=installing /opt/grouper/$GROUPER_VERSION/container/webapp/ /opt/grouper/grouperWebapp/
RUN ls /opt/grouper/grouperWebapp/
COPY --from=installing /etc/alternatives/java /etc/alternatives/java
RUN ls /opt/grouper/
RUN ls /opt/grouper/grouperWebapp/WEB-INF
#ADD https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.11.0/log4j-core-2.11.0.jar /opt/tomee/bin
#ADD https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.11.0/log4j-api-2.11.0.jar /opt/tomee/bin
#ADD https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-jul/2.11.0/log4j-jul-2.11.0.jar /opt/tomee/bin
RUN cd /opt/tomee/; \
    rm -fr webapps/docs/ webapps/host-manager/ webapps/manager/ logs/* temp/* work/* conf/logging.properties
COPY container_files/api/* /opt/grouper/grouperWebapp/WEB-INF/classes/
COPY container_files/ui/ /opt/grouper/grouperWebapp/WEB-INF/classes/
COPY container_files/tomee/ /opt/tomee/
FROM tier/shibboleth_sp:3.0.4_03122019
LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper" \
      ImageName=$imagename \
      ImageOS=centos7
      
ARG GROUPER_CONTAINER_VERSION
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
ENV PATH=$PATH:$JAVA_HOME/bin \
    GROUPER_HOME=/opt/grouper/grouperWebapp/WEB-INF \
    GROUPER_CONTAINER_VERSION=$GROUPER_CONTAINER_VERSION
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime
RUN yum update -y \
    && yum install -y cron logrotate python-pip rsync sudo \
    && pip install --upgrade pip \
    && pip install supervisor \
    && yum clean -y all
COPY --from=installing $JAVA_HOME $JAVA_HOME
COPY --from=cleanup /opt/tomee/ /opt/tomee/
COPY --from=cleanup /opt/grouper/ /opt/grouper/
RUN groupadd -r tomcat \
    && useradd -r -m -s /sbin/nologin -g tomcat tomcat \
    && chown -R tomcat:tomcat /opt/tomee  \
    && ln -s $JAVA_HOME/bin/java /etc/alternatives/java \
    && mkdir -p /opt/tomee/conf/Catalina/localhost/ \
    && chown -R tomcat:tomcat /opt/grouper/grouperWebapp \
    && mkdir /opt/hsqldb \
    && chown tomcat:tomcat /opt/hsqldb


COPY container_files/tier-support/ /opt/tier-support/
COPY container_files/usr-local-bin/ /usr/local/bin/
COPY container_files/httpd/* /etc/httpd/conf.d/
COPY container_files/shibboleth/* /etc/shibboleth/
RUN cp /dev/null /etc/httpd/conf.d/ssl.conf 

WORKDIR /opt/grouper/grouperWebapp/WEB-INF/
EXPOSE 80 443
HEALTHCHECK NONE
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["bin/gsh.sh", "-loader"]
