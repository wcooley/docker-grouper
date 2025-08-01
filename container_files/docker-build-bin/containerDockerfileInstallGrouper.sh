#!/bin/bash

# These need to be set correctly
# ARG JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
# ARG GROUPER_VERSION=2.x.x


printLog() {
    echo "grouperDockerfile; INFO: (containerDockerfileInstallGrouper.sh) $1"
}

runCmd() {
    cmd=$1
    eval "$cmd"
    returnCode=$?
    printLog "$cmd, result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
}


if [[ "$GROUPER_VERSION" =~ -SNAPSHOT$ ]]; then
    isSnapshot=1
    grouperSourceBranch=GROUPER_$(echo $GROUPER_VERSION | cut -c1)_BRANCH
else
    isSnapshot=0
    grouperSourceBranch=GROUPER_RELEASE_$GROUPER_VERSION
fi

printLog "detected isSnapshot=$isSnapshot and grouperSourceBranch=$grouperSourceBranch"

mountDir=/tmp/container_files
tarballDir=/tmp/tarballs
containerDir=/tmp/stage/grouper/$GROUPER_VERSION/container
containerTomcatDir=$containerDir/tomcat
webAppDir=$containerDir/grouper/grouperWebapp

i2ServerBase=https://software.internet2.edu/grouper
mvnVersion=3.6.3
tomcatVersion=9.0.105
MVN=$tarballDir/apache-maven-$mvnVersion/bin/mvn

# cp command is aliased to interactive which affects automated scripts
unalias cp
unalias rm

printLog "GROUPER_VERSION=$GROUPER_VERSION"
printLog "isSnapshot=$isSnapshot"
printLog "grouperSourceBranch=$grouperSourceBranch"
printLog "mvnVersion=$mvnVersion"
printLog "tomcatVersion=$tomcatVersion"


# Create the tarballs directory
runCmd "mkdir -p $tarballDir"

# Download and unpack Maven
runCmd "curl -L -k $i2ServerBase/downloads/tools/apache-maven-$mvnVersion-bin.tar.gz --output $tarballDir/apache-maven-$mvnVersion-bin.tar.gz"
runCmd "tar xzf $tarballDir/apache-maven-$mvnVersion-bin.tar.gz -C $tarballDir"

# Download and unpack Tomcat
runCmd "curl -L -k $i2ServerBase/downloads/tools/apache-tomcat-$tomcatVersion.tar.gz   --output $tarballDir/apache-tomcat-$tomcatVersion.tar.gz"
runCmd "tar xzf $tarballDir/apache-tomcat-$tomcatVersion.tar.gz -C $tarballDir"

# Download grouper source
if [ $isSnapshot != 1 ]; then
    runCmd "curl -L -k https://github.com/Internet2/grouper/archive/$grouperSourceBranch.tar.gz --output $tarballDir/$grouperSourceBranch.tar.gz"
    runCmd "tar xzf $tarballDir/$grouperSourceBranch.tar.gz -C $tarballDir"

    grouperReleaseDir=$tarballDir/grouper-$grouperSourceBranch
else
    runCmd "yum install -y git"
    runCmd "rm -rf $tarballDir/grouper-$GROUPER_VERSION && git clone --depth 1 --branch $grouperSourceBranch https://github.com/Internet2/grouper.git $tarballDir/grouper-$GROUPER_VERSION"

    grouperReleaseDir=$tarballDir/grouper-$GROUPER_VERSION
fi

# set up staging directories
runCmd "mkdir -p $containerDir $containerTomcatDir $webAppDir"

# copy webapp
runCmd "rsync -avzpl $grouperReleaseDir/grouper-ui/webapp/* $webAppDir"

# create staging subfolders
#    skipping in v5: $webAppDir/WEB-INF/modules $webAppDir/WEB-INF/services
runCmd "mkdir -p $webAppDir/WEB-INF $webAppDir/conf $webAppDir/WEB-INF/lib $webAppDir/WEB-INF/libUiAndDaemon $webAppDir/WEB-INF/libWs $webAppDir/WEB-INF/classes/grouperText $webAppDir/WEB-INF/bin $webAppDir/docs"


# copy dependencies - API
runCmd "$MVN -f $grouperReleaseDir/grouper-container/grouper-api-container -DincludeScope=runtime -Dgrouper.version=$GROUPER_VERSION dependency:copy-dependencies"
runCmd "cp -p $grouperReleaseDir/grouper-container/grouper-api-container/target/dependency/*.jar $webAppDir/WEB-INF/lib"

# copy dependencies - UI/daemon
runCmd "$MVN -f $grouperReleaseDir/grouper-container/grouper-uiDaemon-container -DincludeScope=runtime -Dgrouper.version=$GROUPER_VERSION dependency:copy-dependencies"
runCmd "cp -p $grouperReleaseDir/grouper-container/grouper-uiDaemon-container/target/dependency/*.jar $webAppDir/WEB-INF/libUiAndDaemon"

# copy dependencies - WS
runCmd "$MVN -f $grouperReleaseDir/grouper-container/grouper-ws-container -DincludeScope=runtime -Dgrouper.version=$GROUPER_VERSION dependency:copy-dependencies"
runCmd "cp -p $grouperReleaseDir/grouper-container/grouper-ws-container/target/dependency/*.jar $webAppDir/WEB-INF/libWs"


# download grouper jars
for app in grouper grouperClient; do
    runCmd "curl -L -k https://oss.sonatype.org/content/repositories/releases/edu/internet2/middleware/grouper/$app/$GROUPER_VERSION/$app-$GROUPER_VERSION.jar --output $webAppDir/WEB-INF/lib/$app-$GROUPER_VERSION.jar"
done

# Removed in v5: grouper-pspng  grouper-box grouper-duo grouper-azure-provisioner
for app in grouper-ui; do
    runCmd "curl -L -k https://oss.sonatype.org/content/repositories/releases/edu/internet2/middleware/grouper/$app/$GROUPER_VERSION/$app-$GROUPER_VERSION.jar --output $webAppDir/WEB-INF/libUiAndDaemon/$app-$GROUPER_VERSION.jar"
done

for app in grouper-ws; do
    runCmd "curl -L -k https://oss.sonatype.org/content/repositories/releases/edu/internet2/middleware/grouper/$app/$GROUPER_VERSION/$app-$GROUPER_VERSION.jar --output $webAppDir/WEB-INF/libWs/$app-$GROUPER_VERSION.jar"
done