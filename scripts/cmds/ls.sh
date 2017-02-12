CALL_ORIGIN=\\$1
files_names=`sed 's/ls//' <<< "${@:2}"`
locations=`sed "s/[ \t]\+/ $CALL_ORIGIN\/.dev_env\//g" <<< " $files_names"`
ls $locations
