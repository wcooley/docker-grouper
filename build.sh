#!/bin/bash

#docker build -t my-grouper .
docker buildx build --platform linux/arm64 -t my-grouper .