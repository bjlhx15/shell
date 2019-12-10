#!/bin/bash

project_path=$(cd `dirname $0`; pwd)

function fileAndProcSetting(){
    if [ `grep -c '* soft nofile 65535' /etc/security/limits.conf` -eq 0 ];then
        echo 'not have'
        echo -e "\n * soft nofile 65535 \n * hard nofile 65535 \n * soft nproc 65535 \n * hard nproc 65535">>/etc/security/limits.conf
    else
        echo 'have file and proc open number setting.'
    fi
}

function main()
{
    echo "soft and server filepath creating ……"

    echo "file and proc open number setting……"
    fileAndProcSetting

    echo "install cpmleted ……"
}
main $@