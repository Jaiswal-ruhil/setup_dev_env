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
