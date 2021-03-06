#!/bin/bash

# 导入配置
source env-conf.sh
project_path=$(cd `dirname $0`; pwd)
CATALINA_HOME=${tomcat_path}


function create_dir(){
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        echo "mkdir -p ${catalina_base}";
        mkdir -p ${catalina_base}
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
        mv ${catalina_base}/conf/server.xml ${catalina_base}/conf/server.xml.bak
        cp -r ${project_path}/server_template.xml ${catalina_base}/conf/server.xml
        # 环境变量替换
        sed -i "s#server_port_start#${serverPortStart}#g" ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/server.xml
        sed -i "s#server_port_stop#${serverPortStop}#g" ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/server.xml

        echo "copy ${project_path}/Catalina/localhost/ROOT.xml";
        mkdir -p ${catalina_base}/conf/Catalina/localhost
        cp -r ${project_path}/Catalina/localhost/ROOT.xml ${catalina_base}/conf/Catalina/localhost/ROOT.xml
        sed -i "s#__doc_base_url_root__#${catalina_base}/webapps/#g" ${tomcat_instance_path}/${tomcat_instance_format}${i}/conf/Catalina/localhost/ROOT.xml

        echo "start port :${serverPortStart},stop port:${serverPortStop}"
    done
}

function shell_setting() {
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        echo "mkdir -p ${catalina_base}/bin";
        mkdir -p ${catalina_base}/bin
        cp -r ${project_path}/tomcat_control_template.sh ${catalina_base}/bin/control.sh
        catalina_base_str=`echo ${catalina_base}`
        CATALINA_HOME_str=`echo ${CATALINA_HOME}`
        sed -i "s#__CATALINA_BASE__#${catalina_base_str}#g" ${catalina_base}/bin/control.sh
        sed -i "s#__CATALINA_HOME__#${CATALINA_HOME_str}#g" ${catalina_base}/bin/control.sh
    done
}

function tomcat_control() {
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        cp -r ${project_path}/index_template.html ${catalina_base}/webapps/index.html

        str=`echo ${tomcat_instance_format}${i}`
        sed -i "s#__index__template__#${str}#g" ${catalina_base}/webapps/index.html
        chmod 777 ${catalina_base}/bin/control.sh
#        ${catalina_base}/bin/control.sh start
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