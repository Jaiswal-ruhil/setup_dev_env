#!/bin/bash

dev_run() {
    local CMD_STR=$@
    IFS=':' read -r -a array <<< "$CMD_STR"
    bash -c "$CALL_ORIGIN/$REPO_DIR_NAME/$DEFAULT_EXEC ""${array[@]}"
}

exec_flag() {
    local FLAG=$1
    local VALUE=$2
    bash $CALL_ORIGIN/$REPO_DIR_NAME/$FLAGS_FOLDER_NAME/$FLAG.sh $VALUE
}

exec_cmd() {
    local CMD=$1
    local VALUE="${@:2}"
    bash $_REPO_DIR_/$CMD_FOLDER_NAME/$CMD.sh $CALL_ORIGIN $VALUE
}
