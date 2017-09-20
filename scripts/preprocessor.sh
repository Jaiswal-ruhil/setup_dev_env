#!/bin/bash

replace() {
    local OLD=$1
    local NEW=$2
    local INP_FILE=$3
    OLD="$(echo $OLD | sed 's/\//\\\//g')"
    NEW="$(echo $NEW | sed 's/\//\\\//g')"
    sed -i -- 's/{{'$OLD'}}/'$NEW'/g' $INP_FILE
}

preprocess() {
    local FILE=${@:$#-1:1} # resolve the issue of last 2 elemnts
    local OUTPUT_FILE=${@: -1}
    cp $FILE $OUTPUT_FILE
    local OPTIND opt a
    while getopts :r:c:h opt; do
        case $opt in
            h)
                echo "-h: help"
                echo "-r: replace     usage --> OLD:NEW"
            ;;
            c)
                echo -n "REPLACING....CONF CONTENT "
                CONF_FILE=$OPTARG
                while read line; do
                    if ! [[ -z "${line// }" ]]; then
                        IFS='=' read OLD NEW <<< "$line"
                        replace $OLD $NEW $OUTPUT_FILE
                    fi
                done < $CONF_FILE
                echo "[DONE]"
            ;;
            r)
                echo "REPLACING....TAG"
                IFS=':' read OLD NEW <<< "$OPTARG"
                replace $OLD $NEW $OUTPUT_FILE
            ;;
        esac
    done
}
