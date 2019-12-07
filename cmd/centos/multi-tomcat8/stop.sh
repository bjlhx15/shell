#!/bin/bash

# 导入配置
source env-conf.sh
project_path=$(cd `dirname $0`; pwd)
CATALINA_HOME=${tomcat_path}

#JAVA_OPTS参数根据需要添加，尤其是内存相关参数，并且注意这里的设置会覆盖分组设置中的同名值
export JAVA_OPTS="-Xms1024m -Xmx1024m -Dfile.encoding=UTF-8 -Des.set.netty.runtime.available.processors=false"


function tomcat_control() {
    for (( i = 1; i <= ${tomcat_instance_number}; ++i )); do
        catalina_base=${tomcat_instance_path}/${tomcat_instance_format}${i}
        ${catalina_base}/bin/control.sh $1
    done
}

function main()
{
    tomcat_control stop
}
main $@