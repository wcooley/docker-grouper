# this matches the version you decided on from release notes
ARG GROUPER_VERSION=__BASE_CONTAINER__
 
#  --build-arg GROUPER_VERSION=${VARIABLE_NAME} i2incommon/grouper:${GROUPER_VERSION}
FROM i2incommon/grouper:__BASE_CONTAINER__
 
# this will overlay all the files from /opt/grouperContainer/slashRoot on to /
COPY slashRoot /
 
RUN /opt/container_files/containerDockerfileInstallPermissions.sh tomcat root