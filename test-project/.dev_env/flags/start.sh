
docker run --name $CONTAINER_NAME -it \
    -v $BIN_PATH:$BIN_PATH_CONTAINER \
    -v $REPO_PATH:$REPO_PATH_CONTAINER \
    $IMG /bin/bash
