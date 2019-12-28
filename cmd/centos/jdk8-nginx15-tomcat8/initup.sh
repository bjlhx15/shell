#!/bin/bash

# 导入配置
source env-conf.sh

#exit;
project_path_jdk8=$(cd `dirname $0`; pwd)
echo "当前目录：${project_path_jdk8}"

function main()
{
    echo "install starting……"
    pp=$(cd `dirname ${project_path_jdk8}`; pwd)
    source ${pp}/open-port/initup.sh
    source ${pp}/jdk8/initup.sh
    source ${pp}/nginx15/initup.sh
    source ${pp}/tomcat8/initup.sh

    echo "install cpmleted ……"
}
main $@