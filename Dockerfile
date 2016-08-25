FROM bigfleet/shibboleth_sp

# Define args and set a default value
ARG maintainer=tier
ARG imagename=shibboleth_sp
ARG version=2.3.0

MAINTAINER $maintainer
LABEL Vendor="Internet2"
LABEL ImageType="Base"
LABEL ImageName=$imagename
LABEL ImageOS=centos7
LABEL Version=$version
ENV VERSION=$version
ENV TOMCAT_VERSION="6.0.35"

LABEL Build docker build --rm --tag $maintainer/$imagename .

COPY MariaDB.repo /etc/yum.repos.d/MariaDB.repo

RUN mkdir -p /opt/grouper/$VERSION \
      && curl -o /opt/grouper/$VERSION/grouperInstaller.jar http://software.internet2.edu/grouper/release/$VERSION/grouperInstaller.jar \
      && yum -y update \
      && yum -y install \
        dos2unix \
        expect \
        java-1.8.0-openjdk \
        java-1.8.0-openjdk-devel \
        MariaDB-client \
        mlocate \
      && yum clean all
      
COPY grouper.installer.properties /opt/grouper/$version
WORKDIR /opt/grouper/$version
RUN java -cp .:grouperInstaller.jar edu.internet2.middleware.grouperInstaller.GrouperInstaller

VOLUME /opt/grouper/2.3.0/apache-tomcat-$TOMCAT_VERSION/logs

EXPOSE 8080 8009 8005