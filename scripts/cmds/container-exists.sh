#!/usr/bin/env bash

CONTAINER_NAME=$3
RESULT=`docker ps -a --filter name=$CONTAINER_NAME --format found`
echo $RESULT
