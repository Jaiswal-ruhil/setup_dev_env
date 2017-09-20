#!/usr/bin/env bash

CONTAINER_NAME=$1
RESULT=`docker ps -a --filter name=$CONTAINER_NAME --format 1`
if [[ ! $RESULT ]]; then
    exit 1
fi
exit 0
