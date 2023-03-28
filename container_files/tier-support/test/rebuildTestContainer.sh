#/bin/bash

if [ "$#" -ne 3 ]; then
  echo "You must enter exactly 3 command line arguments: grouper base image name, grouper base container version, grouper_container_git_base_dir"
  echo "rebuildTestContainer.sh i2incommon/grouper:2.5.35 2.5.35 /mnt/c/git/grouper_container"
  exit 1
fi

export grouperBaseImageName=$1
export grouperBaseContainerVersion=$2
export grouperContainerGitPath=$3
export subimageName=my-grouper-$2

export reldir=`dirname $0`
cd $reldir

# /mnt/c/mchyzer/git/grouper_container
mkdir -p slashRoot/usr/local/bin
rsync -avzpl $grouperContainerGitPath/container_files/usr-local-bin/* slashRoot/usr/local/bin

rsync -avzpl $grouperContainerGitPath/container_files/tier-support/test/grouper*.sh $reldir

#mkdir -p slashRoot/opt/tomcat/conf
#rsync -avzpl $grouperContainerGitPath/container_files/tomcat/conf/* slashRoot/opt/tomcat/conf/

sed -i "s|__BASE_CONTAINER__|$grouperBaseImageName|g" "testContainer.Dockerfile"

docker build -f testContainer.Dockerfile -t $subimageName --build-arg GROUPER_VERSION=$grouperBaseContainerVersion $reldir

echo "Run tests with: ./grouperContainerUnitTest.sh grouper-test $subimageName:latest $grouperBaseContainerVersion $grouperBaseContainerVersion"
