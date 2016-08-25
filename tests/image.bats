#!/usr/bin/env bats

load ../common

@test "Grouper directory created" {
  docker run -i $maintainer/$imagename find /opt/grouper/$version
}

@test "API binary directory created" {
  docker run -i $maintainer/$imagename find /opt/grouper/$version/grouper.apiBinary-$version
}

@test "Client binary directory created" {
  docker run -i $maintainer/$imagename find /opt/grouper/$version/grouper.clientBinary-$version
}

@test "UI directory created" {
  docker run -i $maintainer/$imagename find /opt/grouper/$version/grouper.ui-$version
}

@test "WS directory created" {
  docker run -i $maintainer/$imagename find /opt/grouper/$version/grouper.ws-$version
}