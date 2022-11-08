#!/usr/bin/env bats

load ../common

@test "010 Image is present and healthy" {
    docker image inspect ${imagename}
}

@test "030 Test Compose the environment" {
    cd test-compose && ./compose.sh && docker-compose down
}
