#!/bin/bash

str_replace() {
    local INP_STR=$1
    local OLD=$2
    local NEW=$3
    local NEW_STR="$(echo $INP_STR | sed 's/'$OLD'/'$NEW'/g')"
    echo $NEW_STR, $INP_STR, $OLD, $NEW
}
