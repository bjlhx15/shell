#!/bin/bash

. /etc/init.d/functions

cd "$(dirname $0)"/.. || exit 1


#JAVA_OPTS参数根据需要添加，尤其是内存相关参数，并且注意这里的设置会覆盖分组设置中的同名值
export JAVA_OPTS="-Xms1024m -Xmx1024m \
 -Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF-8 -Des.set.netty.runtime.available.processors=false"

export CATALINA_BASE="__CATALINA_BASE__"
export CATALINA_HOME="__CATALINA_HOME__"

case "$1" in
start)
        $CATALINA_HOME/bin/startup.sh
        ;;
stop)
        $CATALINA_HOME/bin/shutdown.sh
        pkill -f tomcat
        ;;
restart)
        $CATALINA_HOME/bin/shutdown.sh
        pkill -f tomcat
        sleep 5
        $CATALINA_HOME/bin/startup.sh
        ;;
esac