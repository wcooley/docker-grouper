#!/bin/bash

docker buildx build --platform linux/amd64 -t grouper-installer-test:5.18.3 .

#docker buildx build --keep-build-cache --platform linux/amd64 -t grouper-installer-test:5.18.3 .

#docker buildx build --platform linux/amd64 --cache-to type=local,dest=./cache -t grouper-installer-test:5.18.3 . 
