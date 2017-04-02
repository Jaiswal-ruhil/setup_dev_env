#!/bin/bash

source $_REPO_DIR_/scripts/date_time.sh
source $_REPO_DIR_/scripts/fs.sh
source $_REPO_DIR_/scripts/string.sh


_img_stat_ContainerID() {
    local DOCKER_IMG=$1
    if [[ $(_img_stat_Exists $DOCKER_IMG) ]]; then
        echo `docker ps -a -f "ancestor=${DOCKER_IMG}" --format "{{.ID}}"`
    fi
}

_img_stat_Created() {
    local DOCKER_IMG=$1
    if [[ $(_img_stat_Exists $DOCKER_IMG) ]]; then
        echo `docker inspect --format "{{.Created}}" $DOCKER_IMG`
    fi
}

_img_stat_Epoch() {
    local DOCKER_IMG=$1
    if [[ $(_img_stat_Exists $DOCKER_IMG) ]]; then
        local _DATE=`docker inspect --format "{{.Created}}" $DOCKER_IMG`
        echo `date_to_epoch $_DATE`
    fi
}

_img_stat_Exists() {
    local DOCKER_IMG=$1
    echo $(docker images --format "{{.ID}}" $DOCKER_IMG)
}

docker_build_tmpl() {
    local DEV_SRC_DIR=$1
    local DOCKER_TEMPL=$2
    local DOCKER_IMG=$3
    local CONTAINER_NAME=$4
    echo "BUILDING DOCKER IMAGE.."
    remove_image $DOCKER_IMG
    docker build --tag=$DOCKER_IMG --rm=true $DEV_SRC_DIR
    remove_img_container -i $DOCKER_IMG
    echo -e "\tIMAGE BUILT"
}

# #############################################################################
# builds the docker image from IMGNAME.tmpl
# input
#   IMAGE_NAME ( the file in .dev_env/Dockerfiles/<IMGNAME>.tmpl)
#   IMAGE_TAG
# #############################################################################
docker_build() {
    local _IMG_NAME=$1
    local _IMG_TAG=$2
    local CONF_FILE=$CALL_ORIGIN/$REPO_DIR_NAME/$REPO_CONF_NAME
    local OUTPUT_FILE_LOCATION=$CALL_ORIGIN/$REPO_DOCKER_TMPL_DIR
    local DOCKER_TMPL_FILE=$OUTPUT_FILE_LOCATION/$_IMG_NAME.tmpl
    check_file $CONF_FILE $DOCKER_TMPL_FILE
    preprocess -c $CONF_FILE $DOCKER_TMPL_FILE $OUTPUT_FILE_LOCATION/Dockerfile
    echo "BUILDING DOCKER IMAGE.."
    docker build --tag=${_IMG_NAME}:${_IMG_TAG} --rm=true $OUTPUT_FILE_LOCATION
    echo -e "\tIMAGE BUILT"
}

img_stat() {
    local _STAT=$1 # Created, Exists
    local _DOCKER_IMG=$2
    echo `_img_stat_${_STAT} ${_DOCKER_IMG}`
}

remove_image() {
    local DOCKER_IMG=$1
    remove_img_container -i $DOCKER_IMG
    if [[ $(docker images --format "{{.ID}}" $DOCKER_IMG) ]];then
        echo -e "\tOLDER IMAGE FOUND"
        docker rmi $DOCKER_IMG
        echo -e "\tOLDER IMAGE REMOVED"
    fi
}

# #############################################################################
# Removes a container
# input: CONTAINER_NAME
# #############################################################################
remove_container() {
    local CONTAINER_NAME=$1
    if ! [[ -z $(docker ps -a -f "name=${CONTAINER_NAME}" --format "{{.Names}}") ]];then
        echo -e "\tOLDER CONTAINER FOUND"
        docker rm $CONTAINER_NAME
        echo -e "\tOLDER CONTAINER REMOVED."
    fi
}

# #############################################################################
# Removes an container
# input: IMAGE_NAME
# #############################################################################
remove_img_container() {
    local CONTAINER_ATTR
    local CONTAINER_VALUE
    local OPTIND opt a
    while getopts i: opt; do
        case $opt in
            i) CONTAINER_ATTR=ancestor; CONTAINER_VALUE=$OPTAG;;
        esac
    done
    CONTAINERS=$(docker ps -a -f "${CONTAINER_ATTR}=${IMG_NAME}" --format "{{.ID}}")
    if ! [[ -z $CONTAINERS ]];then
        echo -e "\tOLDER CONTAINER(s) FOUND"
        docker rm $CONTAINERS
        echo -e "\tOLDER CONTAINER(s) REMOVED."
    fi
}

# #############################################################################
# Runs the container with given config
# input: similar docker run command with --img=<IMG_NAME>:<TAG> [..options]
# #############################################################################
run_container() {
    local _INPUT=$*
    local _IMG_FLAG=`str_match "${_INPUT}" "--img=[^\ ]*"`
    local _IMG_NAME=`str_replace ${_IMG_FLAG} --img= ""`
    local _FILE=$CALL_ORIGIN/$REPO_DOCKER_TMPL_DIR/$_IMG_NAME.tmpl
    local _FILE_DATE=`file_stat Modified ${_FILE}`
    local _IMG_VER=`date -u -d"${_FILE_DATE}" +%Y.%m.%d.%H.%M.%S`
    local _IMG_DATE=`img_stat Created ${_IMG_NAME}:${_IMG_VER}`
    local _CMD=`str_replace "${_INPUT}" "${_IMG_FLAG}" "${_IMG_NAME}:${_IMG_VER}"`
    local _CONTAINER_ID=`img_stat ContainerID ${_IMG_NAME}:${_IMG_VER}`

    if [[ `date_diff ${_IMG_DATE} ${_FILE_DATE}` -lt 0 ]]; then
        echo -n "IMG is obsolete need to rebuild img"
        local _OLD_TAG=`docker images addng-data --format {{.Tag}}`             # destroy any related containers
        remove_img_container -i "${_IMG_NAME}:${_OLD_TAG}"
        docker_build ${_IMG_NAME} ${_IMG_VER}                                   # build the image
        docker run $_CMD
    elif [[ `docker ps -f "ID=${CONTAINER_ID}" --format "{{.Names}}"` ]]; then  # CONTAINERS exists
        echo "Container already running"
    elif [[ $_CONTAINER_ID ]]; then                                             # CONTAINERS exists
        echo -e "old container found\n"
        docker start -ai $_CONTAINER_ID
    else                                                                        # start an new container
        docker run $_CMD
    fi
}
