#!/bin/bash

docker buildx build --platform linux/amd64 -t my-grouper .

#docker buildx build --keep-build-cache --platform linux/amd64 -t my-grouper .

#docker buildx build --platform linux/amd64 --cache-to type=local,dest=./cache -t my-grouper . 