
date_to_epoch() {
    local _DATE=$1
    echo `date -d"${_DATE}" +%s`
}

date_diff() {
    local _DATE1=`date_to_epoch ${1}`
    local _DATE2=`date_to_epoch ${2}`
    echo $(($_DATE1 - $_DATE2))
}
