#!/bin/bash

remove_image() {
    local DOCKER_IMG=$1
    remove_img_container -i $DOCKER_IMG
    if [[ $(docker images --format "{{.ID}}" $DOCKER_IMG) ]];then
        echo -e "\tOLDER IMAGE FOUND"
        docker rmi $DOCKER_IMG
        echo -e "\tOLDER IMAGE REMOVED"
    fi
}

remove_container() {
    ####
    # Removes a container
    # input: CONTAINER_NAME
    ####
    local CONTAINER_NAME=$1
    if ! [[ -z $(docker ps -a -f "name=${CONTAINER_NAME}" --format "{{.Names}}") ]];then
        echo -e "\tOLDER CONTAINER FOUND"
        docker rm $CONTAINER_NAME
        echo -e "\tOLDER CONTAINER REMOVED."
    fi
}

remove_img_container() {
    ####
    # Removes a container
    # input: CONTAINER_NAME
    ####
    local CONTAINER_ATTR
    local CONTAINER_VALUE
    local OPTIND opt a
    while getopts i: opt; do
        case $opt in
            i) CONTAINER_ATTR=ancestor; CONTAINER_VALUE=$OPTAG;;
        esac
    done

    CONTAINERS=$(docker ps -a -f "${CONTAINER_ATTR}=${IMG_NAME}" --format "{{.Names}}")
    if ! [[ -z $CONTAINERS ]];then
        echo -e "\tOLDER CONTAINER(s) FOUND"
        docker rm $CONTAINERS
        echo -e "\tOLDER CONTAINER(s) REMOVED."
    fi
}

docker_build_tmpl() {
    local DEV_SRC_DIR=$1
    local DOCKER_TEMPL=$2
    local DOCKER_IMG=$3
    local CONTAINER_NAME=$4

    echo "BUILDING DOCKER IMAGE.."
    remove_image $DOCKER_IMG
    docker build --tag=$DOCKER_IMG --rm=true $DEV_SRC_DIR
    echo -e "\tIMAGE BUILT"
    remove_img_container -i $DOCKER_IMG
}

docker_build() {
    ####
    # builds the docker image from Docker.tmpl
    # input none
    ####
    ## CONSTANTS
    local CONF_FILE=$CALL_ORIGIN/$REPO_DIR_NAME/$REPO_CONF_NAME
    local DOCKER_TMPL=$CALL_ORIGIN/$REPO_DIR_NAME/$DEFAULT_DOCKERFILE
    local DOCKER_FILE_LOCATION=$CALL_ORIGIN/$REPO_DIR_NAME
    check_file $CONF_FILE $DOCKER_TEMPL
    local DOCKER_IMG=$( load_config $1 )
    preprocess -c $CONF_FILE $DOCKER_TMPL
    echo "BUILDING DOCKER IMAGE.."
    remove_image $DOCKER_IMG
    docker build --tag=$DOCKER_IMG --rm=true $DOCKER_FILE_LOCATION
    echo -e "\tIMAGE BUILT"
    remove_img_container -i $DOCKER_IMG
}
