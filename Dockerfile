ARG GROUPER_CONTAINER_VERSION=5.19.1
ARG GROUPER_VERSION=5.19.1
ARG JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto

FROM rockylinux/rockylinux:9.4 AS os-base

LABEL author="tier-packaging@internet2.edu <tier-packaging@internet2.edu>" \
      Vendor="TIER" \
      ImageType="Grouper" \
      ImageName=$imagename \
      ImageOS=centos7

#  net-tools curl mlocate strace telnet man vim rsyslog cron mod_ssl cronie
RUN dnf update -y \
&& dnf --allowerasing install -y logrotate python3-pip rsync sudo patch wget tar unzip dos2unix file net-tools diffutils curl mlocate strace telnet man vim rsyslog cronie findutils procps \
&& pip3 install --upgrade setuptools \
&& dnf clean -y all

# Install Corretto Java JDK (newer more arch independent way)
RUN rpm --import https://yum.corretto.aws/corretto.key \
&& curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo \
&& dnf --allowerasing install -y java-17-amazon-corretto-devel

RUN groupadd -g 994 -r tomcat \
    && useradd -u 996 -r -m -s /sbin/nologin -g tomcat tomcat


FROM os-base AS stage-download

ARG GROUPER_CONTAINER_VERSION
ARG GROUPER_VERSION
ARG JAVA_HOME

ENV GROUPER_VERSION=$GROUPER_VERSION \
    GROUPER_CONTAINER_VERSION=GROUPER_CONTAINER_VERSION \
    JAVA_HOME=$JAVA_HOME \
    PATH=$PATH:$JAVA_HOME/bin \
    GROUPER_HOME=/opt/grouper/grouperWebapp/WEB-INF

COPY container_files/ /tmp/container_files/

RUN chmod +x /tmp/container_files/docker-build-bin/*.sh

RUN /tmp/container_files/docker-build-bin/containerDockerfileInstallGrouper.sh $JAVA_HOME $GROUPER_VERSION


FROM stage-download AS stage

# Staging commands are in a new container so the maven downloads don't refresh for every adjustment
COPY container_files_stage/ /tmp/container_files/

RUN /tmp/container_files/docker-build-bin/containerDockerfileConfigureGrouper.sh $JAVA_HOME $GROUPER_VERSION



FROM os-base AS grouper

ARG GROUPER_CONTAINER_VERSION
ARG GROUPER_VERSION
ARG JAVA_HOME

ENV GROUPER_VERSION=$GROUPER_VERSION \
    GROUPER_CONTAINER_VERSION=$GROUPER_VERSION \
    JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto \
    PATH=$PATH:$JAVA_HOME/bin \
    GROUPER_HOME=/opt/grouper/grouperWebapp/WEB-INF

COPY --from=stage /tmp/stage/grouper/$GROUPER_VERSION/container /opt


COPY container_files/usr-local-bin/ /usr/local/bin/

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && rm -f /etc/alternatives/java \
    && ln -s $JAVA_HOME/bin/java /etc/alternatives/java \
    && chmod u+w $JAVA_HOME/lib/security/cacerts \
    && /usr/lib/jvm/java/bin/keytool -import -noprompt -cacerts -storepass changeit -alias "localhost" -file "/opt/grouper/certs/localhost.pem" \
    && chmod u-w $JAVA_HOME/lib/security/cacerts \
    && echo 'umask 002' >> /home/tomcat/.bashrc

# testing container
# see output with  docker build . --tag my:grouper
# DOCKER_BUILDKIT=0 docker build --progress=plain -t mygrouper .
# docker run --detach --name mygrouper mygrouper:latest
# docker exec -it mygrouper bash

WORKDIR /opt/grouper/grouperWebapp/WEB-INF/
EXPOSE 80 443 8080 8443
HEALTHCHECK NONE

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["ping"]
#CMD ["google.com"]