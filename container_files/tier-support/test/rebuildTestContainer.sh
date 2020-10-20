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

# /mnt/c/mchyzer/git/grouper_container
mkdir -p $reldir/slashRoot/usr/local/bin
rsync -avzpl $grouperContainerGitPath/container_files/usr-local-bin/* $reldir/slashRoot/usr/local/bin

rsync -avzpl $grouperContainerGitPath/container_files/tier-support/test/grouper*.sh $reldir

#mkdir -p $reldir/slashRoot/opt/tomee/conf
#rsync -avzpl $grouperContainerGitPath/container_files/tomee/conf/* $reldir/slashRoot/opt/tomee/conf/

sed -i "s|__BASE_CONTAINER__|$grouperBaseImageName|g" "$reldir/testContainer.Dockerfile"

docker build -f $reldir/testContainer.Dockerfile -t $subimageName --build-arg GROUPER_VERSION=$grouperBaseContainerVersion $reldir

echo "Run tests with: ./grouperContainerUnitTest.sh grouper-test $subimageName:latest $grouperBaseContainerVersion $grouperBaseContainerVersion"