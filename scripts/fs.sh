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
        INFO "\t$FILE_NAME file created"
    else
        INFO "\t$FILE_NAME file already exists"
    fi
    if ! [[ -z $MOD ]]; then
        chmod $MOD $OUTPUT_FOLDER/$FILE_NAME
    fi
}

check_file() {
    local FILE_NAME=$1
    if ! [[ -e $FILE_NAME ]]; then
        INFO "file not found: "$FILE_NAME
    fi
}

_file_stat_Modified() {
    local _FILE=$1
    echo `stat --format %y ${_FILE}`
}

_file_stat_Exists() {
    local _FILE=$1
    if [[ -e $FILE_NAME ]]; then echo 1; fi
}

file_append() {
    local _file=$1
    local _content=$2
    echo $_file
    echo $_content
    echo "${_content}" >>$_file
}

file_stat() {
    local _STAT=$1
    local _FILE=$2
    echo `_file_stat_${_STAT} ${_FILE}`
}
