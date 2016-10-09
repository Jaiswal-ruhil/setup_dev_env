#!/bin/bash

create_dir() {
    local DIR_NAME=$1
    if ! [[ -d $DIR_NAME ]]; then
        mkdir $DIR_NAME
        echo -e "\tdir created"
    else
        echo -e "\tdir already exists"
    fi
}

create_file() {
    local FILE_NAME=$1 MOD=$2
    if ! [[ -e $FILE_NAME ]]; then
        cp $_REPO_DIR_/$TMPL_LOC/$DEFAULT_EXEC $FILE_NAME
        echo -e "\trun file created"
    else
        echo -e "\trun file already exists"
    fi
    if [[ -z $MOD ]]; then
        chmod $MOD $FILE_NAME
    fi
}
