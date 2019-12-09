#!/bin/bash

echo "读取配置..."
# tomcat 解压后版本地址
tomcat_path="/export/servers/tomcat8.0.30"
# 实际 是 tomcat_path_instance_1="/export/Instances/tomcat_instance1" 按tomcat_instance_number 循环
# 部署地址：
tomcat_instance_path="/export/Instances"
# 实例名称
tomcat_instance_format="tomcat_instance"
# 实例个数
tomcat_instance_number=3

echo "tomcat_path:${tomcat_path}"
echo "tomcat_instance_path:${tomcat_instance_path}"
echo "tomcat_instance_format:${tomcat_instance_format}"
echo "tomcat_instance_number:${tomcat_instance_number}"