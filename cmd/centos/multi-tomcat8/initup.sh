#!/bin/bash

# 导入配置
source env-conf.sh
project_path=$(cd `dirname $0`; pwd)
CATALINA_HOME=${tomcat_path}

#JAVA_OPTS参数根据需要添加，尤其是内存相关参数，并且注意这里的设置会覆盖分组设置中的同名值
export JAVA_OPTS="-Xms1024m -Xmx1024m -Dfile.encoding=UTF-8 -Des.set.netty.runtime.available.processors=false"

function create_dir(){
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        echo "mkdir -p ${catalina_base}";
        sudo mkdir -p ${catalina_base}
    done
}

function copy_tomcat_conf() {
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        echo "copy {conf,logs,temp,work}";

        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        cp -r ${tomcat_path}/conf ${tomcat_path}/logs ${catalina_base}/
        cp -r ${tomcat_path}/{temp,work} ${catalina_base}/
        mkdir -p ${catalina_base}/webapps
        # 两种复制方式

        echo "copy conf/server.xml";
        serverPortStart="160${i}"
        serverPortStop="800${i}"
        mv ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/server.xml ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/server.xml.bak
        cp -r ${project_path}/server_template.xml ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/server.xml
        # 环境变量替换
        sed -i "s/server_port_start/${serverPortStart}/g" ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/server.xml
        sed -i "s/server_port_stop/${serverPortStop}/g" ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/server.xml
        echo "start port :${serverPortStart},stop port:${serverPortStop}"
    done
}

function shell_setting() {
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        echo "mkdir -p ${catalina_base}/bin";
        sudo mkdir -p ${catalina_base}/bin
        cp -r ${project_path}/tomcat_control_template.sh ${catalina_base}/bin/control.sh
        sed -i "s/__CATALINA_BASE__/${catalina_base}/g" ${catalina_base}/bin/control.sh
        sed -i "s/__CATALINA_HOME__/${CATALINA_HOME}/g" ${catalina_base}/bin/control.sh
    done
}

function tomcat_control() {
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        cp -r ${project_path}/index_template.html ${catalina_base}/webapps/index_template.html
        sed -i "s/__index__template__/${tomcat_instance_format}${i}/g" ${catalina_base}/webapps/index_template.html
        ${catalina_base}/bin/control.sh start
    done
}

function main()
{

    echo "create_dir ……"
    create_dir


    copy_tomcat_conf
    echo "install cpmleted ……"

    shell_setting

    tomcat_control
    echo "tomcat start cpmleted ……"
}
main $@