#!/bin/bash

# 导入配置
source env-conf.sh

echo "拉取:docker pull centos:${centos_version} 镜像..."

#拉取redis镜像
docker pull centos:${centos_version}

mkdir -p /Users/lihongxu6/docker/${name}
cp /Users/lihongxu6/Downloads/jdk-8u231-linux-x64.tar.gz /Users/lihongxu6/docker/${name}/jdk-8u111-linux-x64.tar.gz

echo "删除旧实例 ${name} 镜像..."
docker rm -f ${name}
#exit;
echo "创建实例 ${name} 镜像..."
docker run -dit --privileged --name=${name} -v /Users/lihongxu6/docker/${name}:/export/soft  centos:${centos_version} /bin/bash

echo "查看实例 ${name} 镜像..."
docker ps -a |grep ${name}

#获取docker分配的ip
ip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${name}`' '
echo "实例 ${name} 镜像，ip:${ip}..."

echo "进入实例 ${name} 镜像..."
docker exec -it ${name} /bin/bash

