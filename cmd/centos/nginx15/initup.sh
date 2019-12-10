#!/bin/bash

# 导入配置


function nginx_install() {
    useradd admin
    echo "nginx init start ######"
    source env-conf.sh
    project_path=$(cd `dirname $0`; pwd)
    pnginx=$(cd `dirname ${project_path}`; pwd)
    pnginx=${pnginx}+'/nginx15'
    echo "project_path:${project_path}"
    echo "pnginx:${pnginx}"

    mkdir -p ${soft_path}
    cd ${soft_path}
    if [ -e nginx-1.15.12.tar.gz ]; then
        echo "exist nginx-1.15.12.tar.gz"
    else
        echo "nginx download start ……"
        wget http://nginx.org/download/nginx-1.15.12.tar.gz
        echo "nginx download end ……"
    fi

    echo "nginx install start ……"
    yum -y install gcc-c++
    yum -y install pcre*
    yum -y install openssl*

    tar -zvxf nginx-1.15.12.tar.gz
    rm -rf ${nginx_server}

    mkdir -p ${nginx_server}
    mkdir -p ${nginx_server}/run

    cd ${soft_path}/nginx-1.15.12
    # 指定目录安装
    ./configure --prefix=${nginx_server} --conf-path=${nginx_server}/conf/nginx.conf
    make && make install

    # 拷贝配置
    mv ${nginx_server}/conf/nginx.conf ${nginx_server}/conf/nginx.conf.default
    cp ${pnginx}/nginx.conf ${nginx_server}/conf/nginx.conf
    mkdir -p ${nginx_server}/run
    rm -rf nginx-1.15.12
    echo "nginx install end ……"
    chown -R admin:admin /export
    chmod -R 777 /export/servers
    chown root:root ${nginx_server}/sbin/nginx
    chmod 755 ${nginx_server}/sbin/nginx
    chmod u+s ${nginx_server}/sbin/nginx
    echo "nginx init end ######"
    cd ${project_path}
}


function main()
{

    echo "install start ……"
    nginx_install

    echo "install cpmleted ……"
}
main $@