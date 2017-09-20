. ./.dev_env/config

echo $CONTAINER_NAME
echo $BIN_PATH
echo $BIN_PATH_CONTAINER
echo $REPO_PATH
echo $REPO_PATH_CONTAINER

docker run --name $CONTAINER_NAME -it \
    -v $BIN_PATH:$BIN_PATH_CONTAINER \
    -v $REPO_PATH:$REPO_PATH_CONTAINER \
    $IMG /bin/bash
docker rm $CONTAINER_NAME
