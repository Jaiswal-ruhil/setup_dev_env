#!/bin/bash

source $_REPO_DIR_/scripts/fs.sh
source $_REPO_DIR_/scripts/git_control.sh

init() {
    echo "INITIALIZING DEV ENV"
    local init_repo_dir=$(pwd)
    create_dir $init_repo_dir/.dev-env
    git_init $init_repo_dir/.dev-env
    echo "init: "$init_repo_dir
    echo "[DONE]"
}
