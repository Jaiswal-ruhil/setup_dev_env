#!/bin/bash

source $_REPO_DIR_/scripts/fs.sh
source $_REPO_DIR_/scripts/handler_git.sh

init() {
    INFO "INITIALIZING DEV ENV"
    local init_repo_dir=$CALL_ORIGIN
    create_dir $init_repo_dir/$REPO_DIR_NAME
    create_dir $init_repo_dir/$REPO_DIR_NAME/$FLAGS_FOLDER_NAME
    create_file $init_repo_dir/$REPO_DIR_NAME/ $GLOBAL_CONF
    git_init $init_repo_dir
    for arg; do
        case "$arg" in
            --Dockerfile) create_file_from $init_repo_dir/$REPO_DIR_NAME/ $DOCKER_TMPL_REPO/$DEFAULT_DOCKERFILE;;
        esac
    done
    INFO "[DONE]"
}

load_config() {
    local CONFIG_KEY=$1
    local LINE=$( grep -o "^$CONFIG_KEY=.*$" $CALL_ORIGIN/$REPO_DIR_NAME/$REPO_CONF_NAME )
    local KEY
    local VALUE
    IFS='=' read KEY VALUE <<< "$LINE"
    echo $VALUE
}
