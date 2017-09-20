#!/bin/bash

source $_REPO_DIR_/scripts/fs.sh
source $_REPO_DIR_/scripts/handler_git.sh

# #############################################################################
# initialize the repository
# #############################################################################
init() {
    INFO "INITIALIZING DEV ENV"
    local init_repo_dir=$CALL_ORIGIN
    # create the directory structure
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

# #############################################################################
# given config key return the value
# #############################################################################
load_config() {
    local CONFIG_KEY=$1
    local LINE=$( grep -o "^$CONFIG_KEY=.*$" $CALL_ORIGIN/$REPO_DIR_NAME/$REPO_CONF_NAME )
    local KEY
    local VALUE
    IFS='=' read KEY VALUE <<< "$LINE"
    echo $VALUE
}

# #############################################################################
# given a file resolves the given requirements
# example: considering startpoint as pwd (can be a sub dir)
# .
# |- .dev_env
#     |-- flags
#         |--# start.sh
#     |-# config
#     |-# .global
# #############################################################################
resolve_requirements() {
    # TODO: resolve for space in the initial dir name
    # TODO: ability to handle mutiple detached trees
    local _req_file=$1
    local _depth
    local _name
    local _line
    while read _line; do
        # extract value
        IFS=' ' read _depth _name <<< "$_line" #taking advantage of the fact that the value will trim
        if ! [[ $_name ]];then _name=$_depth; _depth=''; fi
        # check if file exists (use ls) repo_dir/line
        ERR $_depth
        INFO $_name
    done < $_req_file
}
