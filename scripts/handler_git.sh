#!/bin/bash

git_init() {
    local DIR=$1
    local VER_CTRL_DIR=$DIR/.git
    if ! [[ -d $VER_CTRL_DIR ]]; then
        bash -c "cd $DIR; git init;"
    else
        echo -e "\tvirsion control already exists already exists"
    fi
}
