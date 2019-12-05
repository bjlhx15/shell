#!/bin/bash

# 导入配置
source env-conf.sh

echo "file and proc open number setting……"
echo -e "\n * soft nofile 65535 \n * hard nofile 65535 \n * soft nproc 65535 \n * hard nproc 65535">>/etc/security/limits.conf

echo "soft and server filepath creating ……"
mkdir -p /export/soft/
mkdir -p /export/servers/
useradd admin

#exit 0;

cd /export/soft/
echo "jdk init start ######"
echo "jdk download start ……"
echo "请将 本地 jdk 上传服务器目录下并配置，如 jdk-8u231-linux-x64.tar.gz ,jdk 格式 jdk-*.tar.gz"
echo "本地上传至远端 scp /Users/lihongxu6/Downloads/jdk-8u231-linux-x64.tar.gz root@192.168.120.204:/export/soft/"
mv /export/soft/jdk-8u231-linux-x64.tar.gz /export/soft/
echo "jdk download end ……"

echo "jdk install start ……"
tar -zvxf ${jdk_path}
jdk_name=`echo jdk*_*`
mv ${jdk_name} /export/servers/${jdk_name}
echo "jdk install end ……"

echo "jdk profile start ……"
echo -e "\n\n export JAVA_HOME=/export/servers/${jdk_name}
export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
export PATH=$PATH:${JAVA_HOME}/bin" >>/etc/profile
. /etc/profile
cat /etc/profile
echo "jdk profile end ……"

echo "jdk init end ######"

exit ;
echo "tomcat8 init start ######"
echo "tomcat8 download start ……"
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.30/bin/apache-tomcat-8.0.30.tar.gz
echo "tomcat8 download end ……"

echo "tomcat8 install start ……"
tar -zvxf apache-tomcat-8.0.30.tar.gz
mv apache-tomcat-8.0.30 /export/servers/tomcat8.0.30
echo "tomcat8 install end ……"
echo "tomcat8 init end ######"


echo "nginx init start ######"
echo "nginx download start ……"
wget http://nginx.org/download/nginx-1.15.12.tar.gz
echo "nginx download end ……"

echo "nginx install start ……"
yum install gcc-c++
yum -y install pcre*
yum -y install openssl*
tar -zvxf nginx-1.15.12.tar.gz
mv nginx-1.15.12 /export/servers/nginx-1.15.12
cd /export/servers/nginx-1.15.12
# 指定目录安装
./configure --prefix=/export/servers/nginx
make
make install

mkdir -p /export/servers/nginx/run
chown -R admin:admin /export
chmod -R 777 /export/servers
echo "nginx install end ……"
echo "nginx init end ######"