#!/bin/bash

_export() {
    local conf_file=$1
    while IFS='' read -r line || [[ -n "$line" ]]; do
        export $line
    done < $conf_file
}

setup_exec_env() {
    local dev_folder=$1
    _export $dev_folder/config
}
