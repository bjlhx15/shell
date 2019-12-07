#!/bin/bash

. /etc/init.d/functions
export CATALINA_BASE="__CATALINA_BASE__"
export CATALINA_HOME="__CATALINA_HOME__"

case "$1" in
start)
        $CATALINA_HOME/bin/startup.sh
        ;;
stop)
        $CATALINA_HOME/bin/shutdown.sh
        ;;
restart)
        $CATALINA_HOME/bin/shutdown.sh
        sleep 5
        $CATALINA_HOME/bin/startup.sh
        ;;
esac