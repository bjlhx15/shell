#!/bin/bash

# 导入配置
source env-conf.sh

#exit;
project_path=$(cd `dirname $0`; pwd)
echo "当前目录：${project_path}"

function fileAndProcSetting(){
    if [ `grep -c '* soft nofile 65535' /etc/security/limits.conf` -eq 0 ];then
        echo 'not have'
        echo -e "\n * soft nofile 65535 \n * hard nofile 65535 \n * soft nproc 65535 \n * hard nproc 65535">>/etc/security/limits.conf
    else
        echo 'have file and proc open number setting.'
    fi
}

function dirCreate(){
    mkdir -p /export/soft/
    mkdir -p /export/servers/
    cd /export/soft/
    useradd admin
}
function jdk_install() {
    mkdir -p /export/soft/
    cd /export/soft/
    echo "jdk init start ######"
    echo "jdk download start ……"
    echo "请将 本地 jdk 上传服务器目录下并配置，如 jdk-8u231-linux-x64.tar.gz ,jdk 格式 jdk-*.tar.gz"
    echo "本地上传至远端 scp /Users/lihongxu6/Downloads/jdk-8u231-linux-x64.tar.gz root@192.168.120.204:/export/soft/"

    if [ -e jdk-*.tar.gz ] ; then
        echo 'exist apache-tomcat-8.0.30.tar.gz'
    else
        mv ${jdk_path} /export/soft/
    fi
    echo "jdk download end ……"

    echo "jdk install start ……"

    jdk_tar_name=`echo jdk-*.tar.gz`
    tar -zvxf ${jdk_tar_name}
    jdk_name=`echo jdk*_*`
    rm -rf $1/${jdk_name}
    mv ${jdk_name} $1/${jdk_name}
    echo "jdk install end ……"

    echo "jdk profile start ……"
    if [ `grep -c 'export JAVA_HOME=/export/servers' /etc/profile` -eq 0 ];then
        echo 'not have'
        echo -e "\n\nexport JAVA_HOME=/export/servers/${jdk_name}
    export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
    export PATH=$PATH:${JAVA_HOME}/bin" >>/etc/profile
        source /etc/profile
    else
        echo 'have jdk setting'
    fi
    echo "jdk profile end ……"
    echo "jdk init end ######"
}

function tomcat_install() {
    echo "tomcat8 init start ######"
    if [ -e apache-tomcat-8.0.30.tar.gz ] ; then
        echo 'exist apache-tomcat-8.0.30.tar.gz'
    else
        echo "tomcat8 download start ……"
        wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.30/bin/apache-tomcat-8.0.30.tar.gz
        echo "tomcat8 download end ……"
    fi

    echo "tomcat8 install start ……"
    tar -zvxf apache-tomcat-8.0.30.tar.gz
    rm -rf $1
    mv apache-tomcat-8.0.30 $1
    echo "tomcat8 install end ……"
    echo "tomcat8 init end ######"
}
function nginx_install() {
    echo "nginx init start ######"
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
    rm -rf $1

    mkdir -p $1
    mkdir -p $1/run

    cd nginx-1.15.12
    # 指定目录安装
    ./configure --prefix=$1 --conf-path=$1/conf/nginx.conf
    make && make install

    # 拷贝配置
    mv $1/conf/nginx.conf $1/conf/nginx.conf.default
    cp ${project_path}/nginx.conf $1/conf/nginx.conf
    mkdir -p $1/run
    rm -rf nginx-1.15.12
    echo "nginx install end ……"
    chown -R admin:admin /export
    chmod -R 777 /export/servers
    chown root:root $1/sbin/nginx
    chmod 755 $1/sbin/nginx
    chmod u+s $1/sbin/nginx
    echo "nginx init end ######"
}


function main()
{
    echo "install starting……"
    pp=$(cd `dirname ${project_path}`; pwd)
    source ${pp}/open-port/initup.sh
    source ${pp}/jdk8/initup.sh
    source ${pp}/nginx15/initup.sh
    source ${pp}/tomcat8/initup.sh

    echo "install cpmleted ……"
}
main $@