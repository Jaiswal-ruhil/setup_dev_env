#!/bin/bash

replace() {
    OLD=$1
    NEW=$2
    INP_FILE=$3
    OLD="$(echo $OLD | sed 's/\//\\\//g')"
    NEW="$(echo $NEW | sed 's/\//\\\//g')"
    sed -i -- 's/{{'$OLD'}}/'$NEW'/g' $INP_FILE
}

preprocess() {
    FILE=${@: -1}
    OUTPUT_FILE="$(echo $FILE | sed 's/.tmpl//g')"
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
