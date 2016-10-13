#!/bin/bash

. ./.dev_env/config

_REPO_DIR_="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CALL_ORIGIN="$( pwd )"

# no input
if [ $? != 0 ] ; then echo "Terminating...NOW" >&2 ; exit 1 ; fi

# replace long arguments
args=( )
for arg; do
    case "$arg" in
        *) args+=( "$arg" ) ;;
    esac
done

set -- "${args[@]}"

while getopts :h OPTION; do
    : "$OPTION" "$OPTARG"
    case $OPTION in
        h)  echo "usage"; exit 0;;
        \?) echo $OPTION"  "$OPTARG;;
    esac
done
