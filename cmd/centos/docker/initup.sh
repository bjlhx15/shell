#!/bin/bash

function os(){
   sysver=`cat /etc/redhat-release`
   linuxcire=`uname -r`
}
function install_docker(){
    yum install docker -y
    docker version
    systemctl start docker
    systemctl enable docker #开机启动docker
    docker version
    systemctl status docker
}


function main(){
    os
}
main $@