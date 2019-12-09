#!/bin/bash

# 导入配置
source env-conf.sh
project_path=$(cd `dirname $0`; pwd)



function main()
{
    echo "需手工清理 /etc/profile jdk配置"
    echo "需手工清理 /export/server/jdk 对应目录即可"

}
main $@