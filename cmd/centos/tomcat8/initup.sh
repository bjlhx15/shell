#!/bin/bash

# 导入配置
source env-conf.sh
project_path=$(cd `dirname $0`; pwd)
CATALINA_HOME=${tomcat8_server_path}


function tomcat_install() {
    mkdir -p ${soft_path}
    cd ${soft_path}
    echo "tomcat8 init start ######"
    project_path=$(cd `dirname $0`; pwd)
    echo "project_path:${project_path}"
    if [ -e apache-tomcat-8.0.30.tar.gz ] ; then
        echo 'exist apache-tomcat-8.0.30.tar.gz'
    else
        echo "tomcat8 download start ……"
        wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.30/bin/apache-tomcat-8.0.30.tar.gz
        echo "tomcat8 download end ……"
    fi

    echo "tomcat8 install start ……"
    tar -zvxf apache-tomcat-8.0.30.tar.gz
    rm -rf ${tomcat8_server_path}
    mv apache-tomcat-8.0.30 ${tomcat8_server_path}

    chown -R admin:admin /export/servers/tomcat8.0.30
    chmod -R 777 /export/servers/tomcat8.0.30
    echo "tomcat8 install end ……"
    echo "tomcat8 init end ######"
    cd ${project_path}
}

function main()
{

    echo "tomcat install starting ……"
    tomcat_install
    echo "tomcat install cpmleted ……"
}
main $@