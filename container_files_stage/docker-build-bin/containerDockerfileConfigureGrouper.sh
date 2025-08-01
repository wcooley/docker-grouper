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

tomcatVersion=9.0.105

# cp command is aliased to interactive which affects automated scripts
unalias cp
unalias rm

printLog "GROUPER_VERSION=$GROUPER_VERSION"
printLog "isSnapshot=$isSnapshot"
printLog "grouperSourceBranch=$grouperSourceBranch"
printLog "tomcatVersion=$tomcatVersion"


if [ $isSnapshot != 1 ]; then
    grouperReleaseDir=$tarballDir/grouper-$grouperSourceBranch
else
    grouperReleaseDir=$tarballDir/grouper-$GROUPER_VERSION
fi

# copy app conf/* to classes
for dir in grouper grouper-ws/grouper-ws grouper-ui grouper-misc/grouperClient; do
    runCmd "rsync -avzpl $grouperReleaseDir/$dir/conf/* $webAppDir/WEB-INF/classes/"
done

# copy staging conf to classes (mainly log4j)
runCmd "rsync -avzpl $mountDir/grouperWebapp/WEB-INF/classes/* $webAppDir/WEB-INF/classes/"

# copy example files to classes renaming to remove .examples
for file in $grouperReleaseDir/grouper/misc/*example.properties; do
    if [[ "$file" =~ grouper.text.en.us.example.properties$ ]]; then
        newFile=$webAppDir/WEB-INF/classes/grouperText/grouper.text.en.us.properties
    else
        newFile="$webAppDir/WEB-INF/classes/${file##*/}"
        newFile=${newFile//.example./.}
    fi
    runCmd "cp -p $file $newFile"
done

# copy WS conf subdirectories to WEB-INF/conf
# (SOAP gone in v5) for dir in "webapp/WEB-INF/modules webapp/WEB-INF/services conf"; do
#for dir in "conf"; do
#    runCmd "rsync -avzpl $grouperReleaseDir/grouper-ws/grouper-ws/$dir $webAppDir/dir/"
#done

# copy bin
runCmd "rsync -avzpl $grouperReleaseDir/grouper/bin/* $webAppDir/WEB-INF/bin/"

# copy Swagger docs
runCmd "rsync -avzpl $grouperReleaseDir/grouper-ws/grouper-ws/webapp/docs/* $webAppDir/docs"

# make gsh executable
runCmd "chmod +x $webAppDir/WEB-INF/bin/gsh.sh"


# delete slf4j related jars from all the lib dirs
## not needed?


# Remove older versions of jars
## TODO

# Delete duplicate copies of jars in other libs
for destination_dir in $webAppDir/WEB-INF/libUiAndDaemon $webAppDir/WEB-INF/libWs; do
    for file in $webAppDir/WEB-INF/lib/*; do
        # Check if the file exists in the destination directory
        basefile="$destination_dir/$(basename "$file")"
        if [ -e "$basefile" ]; then
            # Delete the file in the destination directory
            rm "$basefile"
            echo "Deleted $basefile in $destination_dir"
        fi
    done
done
printLog "Removed files from libUiAndDaemon and libWs"


# copy apache-tomcat-x.y.z to tomcat
runCmd "rsync -avzpl $tarballDir/apache-tomcat-$tomcatVersion/* $containerTomcatDir"

# make tomcat files executable
runCmd "chmod +x $containerTomcatDir/bin/*.sh"



# install grouper files for tomcat
runCmd "rsync -avzpl $mountDir/tomcat/* $containerTomcatDir"


# copy tier-support
runCmd "rsync -avzpl $mountDir/tier-support $containerDir"


# Make logs dir
runCmd "mkdir -p $containerDir/grouper/logs"

# Make slashRoot
runCmd "mkdir -p $containerDir/grouper/slashRoot"


# Clean up tomcat
runCmd "rm -rf $containerTomcatDir/webapps/ROOT $containerTomcatDir/webapps/examples $containerTomcatDir/webapps/docs/ $containerTomcatDir/webapps/host-manager/ $containerTomcatDir/webapps/manager/ $containerTomcatDir/logs/* $containerTomcatDir/temp/* $containerTomcatDir/work/* $containerTomcatDir/conf/logging.properties"
runCmd "rm -f $containerTomcatDir/bin/log4j-*"
runCmd "rm -f $containerTomcatDir/lib/slf4j-*"

runCmd "mkdir -p $containerTomcatDir/conf/Catalina/localhost/"
runCmd "mkdir -p $containerTomcatDir/work/Catalina/localhost/"

runCmd "cp -p $mountDir/log4j_fix/tomcatBin/log4j-* $containerTomcatDir/bin/"
runCmd "cp -p $mountDir/log4j_fix/tomcatLib/slf4j-* $containerTomcatDir/lib/"

runCmd "rm -f $webAppDir/WEB-INF/lib/slf4j-api-*"

runCmd "cp -p $mountDir/log4j_fix/webinfLib/* $webAppDir/WEB-INF/lib/"


runCmd "touch $containerDir/grouper/grouperEnv.sh"


runCmd "mkdir -p $containerDir/grouper/certs/client $containerDir/grouper/certs/keys $containerDir/grouper/certs/anchors"

# put localhost and test certs outside where the bootstrap would pick them up
runCmd "cp -p $mountDir/certs/localhost.*   $containerDir/grouper/certs/"


runCmd "mkdir -p $containerDir/tier-support/originalFiles"
runCmd "cp $webAppDir/WEB-INF/classes/log4j2.xml $containerDir/tier-support/originalFiles"
runCmd "cp $containerTomcatDir/conf/server.xml $containerDir/tier-support/originalFiles"
runCmd "cp $containerTomcatDir/conf/Catalina/localhost/grouper.xml $containerDir/tier-support/originalFiles"
runCmd "cp $webAppDir/WEB-INF/web.xml $containerDir/tier-support/originalFiles"

# change ownership over everything. Don't fail the following commands if nothing was found
runCmd "find $containerDir/grouper $containerDir/tier-support $containerDir/tomcat  $containerDir/usr-local-bin $JAVA_HOME/lib/security/cacerts -path $containerDir/grouper/slashRoot -prune -o -path $containerDir/grouper/logs -prune -o -print0 | xargs -0 chown tomcat.root  || true"

# directory permissions
runCmd "find $containerDir/grouper $containerDir/tier-support $containerDir/usr-local-bin -path $containerDir/grouper/slashRoot -prune -o -path $containerDir/grouper/logs -prune -o -type d -print0 | xargs -0 chmod g+rwxs || true"

# file permissions
runCmd "find $containerDir/grouper $containerDir/tier-support $containerDir/usr-local-bin $JAVA_HOME/lib/security/cacerts -path $containerDir/grouper/slashRoot -prune -o -path $containerDir/grouper/logs -prune -o -type f -print0 | xargs -0 chmod g+rw || true"

# remove non-group write
runCmd "find $containerDir/grouper $containerDir/tier-support $containerDir/usr-local-bin $JAVA_HOME/lib/security/cacerts -path $containerDir/grouper/slashRoot -prune -o -path $containerDir/grouper/logs -prune -print0 | xargs -0 chmod o-w || true"

# set shell scripts to executable
runCmd "find $containerDir/grouper $containerDir/tier-support $containerDir/tomcat -path $containerDir/grouper/slashRoot -prune -o -path $containerDir/grouper/logs -prune -o -type f -name \*.sh -print0 | xargs -0 chmod +x || true"

# permissions on certs
#dont fail since if no files then it exits with 1
runCmd "find $containerDir/grouper/certs/keys -type f -print0 | xargs -0 chmod -f 660 || true"

# bin file executable
runCmd "find  $containerDir/usr-local-bin -type f -print0 | xargs -0 chmod +x || true"