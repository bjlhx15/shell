#!/bin/bash

# 导入配置
source env-conf.sh
project_path=$(cd `dirname $0`; pwd)

function version_check() {
    #JAVA_VERSION=$JAVA_HOME | awk -F"/" '{print $4}' 或者
    JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`;

    if [ ${JAVA_VERSION} ]; then
        read -r -p "目前已存在 JDK ${JAVA_VERSION},确认继续安装? [Y/n] " input

        case $input in
            [yY][eE][sS]|[yY])
                echo "存在，继续安装，请先清理原冲突配置"
                return 0
                ;;

            [nN][oO]|[nN])
                echo "存在，不继续安装"
                return 1
                ;;

            *)
                echo "Invalid input..."
                ;;
        esac
    else
        return 0;
    fi
}

function jdk_install() {
    mkdir -p ${jdk_server}
    jdk_dir=$(dirname ${jdk_path})
    cd ${jdk_dir}
    echo "jdk init start ######"
    echo "jdk download start ……"

    if [ -e jdk-*.tar.gz ] ; then
        echo 'exist jdk-*.tar.gz'
    else
        echo 'no exist jdk-*.tar.gz'
        echo `请将 jdk-*.tar.gz 上传至 ${jdk_path} 上`
        echo "请将 本地 jdk 上传服务器目录下并配置，如 jdk-8u231-linux-x64.tar.gz ,jdk 格式 jdk-*.tar.gz"
        echo "本地上传至远端 scp /Users/lihongxu6/Downloads/jdk-8u231-linux-x64.tar.gz root@192.168.120.204:${soft_path}"
        exit 0;
    fi
    echo "jdk download end ……"

    echo "jdk install start ……"

    jdk_tar_name=`echo jdk-*.tar.gz`
    tar -zvxf ${jdk_tar_name}
    jdk_name=`echo jdk*_*`
    rm -rf ${jdk_server}/${jdk_name}
    mv ${jdk_name} ${jdk_server}/${jdk_name}
    echo "jdk install end ……"

    echo "jdk profile start ……"
    if [ `grep -c 'export JAVA_HOME=/export/servers' /etc/profile` -eq 0 ];then
        echo 'not have'
        echo -e "\n\nexport JAVA_HOME=/export/servers/${jdk_name}" '\nexport CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar\nexport PATH=$PATH:${JAVA_HOME}/bin' >>/etc/profile
    else
        echo 'have jdk setting'
    fi
    source /etc/profile
    java -version
    echo "jdk profile end ……"
    echo "jdk init end ######"
}


function main()
{
    echo "install starting ……"
    version_check

    retval=$?
#    echo ${retval}
    # 安装
    if [ ${retval} == 0 ]; then
        echo '安装开始……'
        jdk_install
    else
        echo '不安装……'

    fi

    echo "install cpmleted ……"
}
main $@