#!/bin/bash

curpwd=`pwd`

echo "读取配置..."
#服务器内网ip
#ip=""
ip="10.0.0.70"
#redis镜像版本
redis_version="5.0.3"
#集群文件放置目录
redis_dir="/export/docker/redis_cluster"
#端口范围，要至少6个才可以
redis_port_range="7000 7005"

echo "IP:${ip}"
echo "redis_version:${redis_version}"
echo "redis_dir:${redis_dir}"