#!/bin/bash

dev_run() {
    local CMD_STR=$@
    IFS=':' read -r -a array <<< "$CMD_STR"
    bash -c "$CALL_ORIGIN/$REPO_NAME/$DEFAULT_EXEC ""${array[@]}"
}
