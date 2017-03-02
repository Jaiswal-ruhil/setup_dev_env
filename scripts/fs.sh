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

check_dir() {
    local DIR_NAME=$1
    if ! [[ -d $DIR_NAME ]]; then
        echo -e "directory not found: "$DIR_NAME
        exit 0
    fi
}

create_file() {
    local OUTPUT_FOLDER=$1
    local FILE_NAME=$2
    local MOD=$3
    if ! [[ -e $OUTPUT_FOLDER/$FILE_NAME ]]; then
        cp $_REPO_DIR_/$TMPL_LOC/$FILE_NAME $OUTPUT_FOLDER/$FILE_NAME
        echo -e "\t$FILE_NAME file created"
    else
        echo -e "\t$FILE_NAME file already exists"
    fi
    if ! [[ -z $MOD ]]; then
        chmod $MOD $OUTPUT_FOLDER/$FILE_NAME
    fi
}

check_file() {
    local FILE_NAME=$1
    if ! [[ -e $FILE_NAME ]]; then
        echo -e "file not found: "$FILE_NAME
        echo 1
    fi
    echo 0
}
