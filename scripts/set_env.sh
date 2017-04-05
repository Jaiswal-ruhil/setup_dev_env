#!/bin/bash

# #############################################################################
# exports the values from config file
# #############################################################################
_export() {
  local conf_file=$1
  while IFS='' read -r line || [[ -n "$line" ]]; do
    export $line
  done < $conf_file
}

# #############################################################################
# prepares the config file_stat
# for the given given repo prepare the config
# #############################################################################
_prepare_conf() {
  local _dev_folder=$1
  local _conf=$_dev_folder/$REPO_CONF_NAME
  # get all the content from .global
  # get values for
  grep -e '^[A-Za-z_0-9]*=[^:]*$' $_dev_folder/$GLOBAL_CONF | while read -r line ; do
    # is present in config
    local _key=`str_match "${line}" "^[A-Za-z_0-9]*"`
    local _key_desc=`str_replace "${line}" "${_key}=" ""`
    if ! [[ `file_stat Exists ${_conf}` ]];then touch $_conf; fi
    local _local_conf_line=$( grep -e "^${_key}=" $_conf )
    if ! [[ $_local_conf_line ]]; then
      local _local_value
      MSG "Input value: $_key ($_key_desc): "
      read _local_value < /dev/tty
      file_append $_conf "${_key}=${_local_value}"
    fi
    export $_local_conf_line
  done
  #check values for
  grep -e '^[A-Za-z_0-9]*=[^:]*:[^:]*$' $_dev_folder/$GLOBAL_CONF | while read -r line ; do
    local _key=$(echo $line | sed s/=.*//g)
    local _value=$(echo $line | sed s/.*://g)
    if ! [[ $( grep -e "^${_key}=${_value}$" $_conf ) ]]; then
      file_append $_conf "${_key}=${_value}"
    fi
  done
}


# #############################################################################
# setup the development environment
# #############################################################################
setup_exec_env() {
  local _dev_folder=$1
  _prepare_conf $_dev_folder
  _export $_dev_folder/$REPO_CONF_NAME
}
