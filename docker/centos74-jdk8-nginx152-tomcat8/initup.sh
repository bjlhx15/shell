#!/bin/bash

# 导入配置
source env-conf.sh

echo "拉取:docker pull centos:7.4.1708 镜像..."

#拉取redis镜像
docker pull centos:7.4.1708

echo "删除旧实例 ${name} 镜像..."
docker rm -f ${name}

echo "创建实例 ${name} 镜像..."
docker run -dit --privileged --name=${name} centos:7.4.1708 /bin/bash

echo "查看实例 ${name} 镜像..."
docker ps -a |grep ${name}

#获取docker分配的ip
ip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${name}`' '
echo "实例 ${name} 镜像，ip:${ip}..."

echo "进入实例 ${name} 镜像..."
docker exec -it ${name} /bin/bash

