#!/bin/bash

str_replace() {
  # TODO: HANDLE '/' in the old and new values
  local INP_STR=$1
  local OLD=$2
  local NEW=$3
  local NEW_STR="$(echo $INP_STR | sed 's/'$OLD'/'$NEW'/g')"
  echo $NEW_STR
}

str_match() {
  local _INPUT=$1
  local _PATTERN=$2
  echo `echo $_INPUT | grep -e "${_PATTERN}" -o`
}

INFO() {
  printf "INFO: $*\n"
}

LOG() {
  printf "LOG: $*\n"
}

MSG() {
  printf "$*"
}

ERR() {
  printf "ERR: $*\n"
}
