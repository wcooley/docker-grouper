#!/usr/bin/env bats

load ../common

@test "Grouper directory created" {
  docker run -i $maintainer/$imagename find /opt/grouper/$version
}