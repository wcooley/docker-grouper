#/bin/bash

if [ "$#" -ne 2 ]; then
  echo "You must enter exactly 2 command line arguments: grouper base container version, grouper_container_git_base_dir"
  echo "rebuildTestContainer.sh 2.5.33 /mnt/c/mchyzer/git/grouper_container"
  exit 1
fi

export grouperBaseContainerVersion=$1
export grouperContainerGitPath=$2
export subimageName=my-grouper-$1

export reldir=`dirname $0`

# /mnt/c/mchyzer/git/grouper_container
mkdir -p $reldir/slashRoot/usr/local/bin
rsync -avzpl $grouperContainerGitPath/container_files/usr-local-bin/* $reldir/slashRoot/usr/local/bin

rsync -avzpl $grouperContainerGitPath/container_files/tier-support/test/grouper*.sh $reldir

mkdir -p $reldir/slashRoot/opt/tomee/conf
rsync -avzpl $grouperContainerGitPath/container_files/tomee/conf/* $reldir/slashRoot/opt/tomee/conf/

docker build -f $reldir/testContainer.Dockerfile -t $subimageName --build-arg GROUPER_VERSION=$grouperBaseContainerVersion $reldir

echo "Run tests with: ./grouperContainerUnitTest.sh grouper-test $subimageName:latest $grouperBaseContainerVersion $grouperBaseContainerVersion"