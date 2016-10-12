#!/bin/bash

dev_run() {
    local CMD_STR=$@
    bash -c "$CALL_ORIGIN/$REPO_DIR_NAME/$DEFAULT_EXEC $CMD_STR"
}
