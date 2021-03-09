#!/bin/bash

curpwd=`pwd`

echo "读取配置..."
#服务器内网ip
#ip=""
ip="10.1.0.10"
#redis镜像版本
redis_version="5.0.5"
#集群文件放置目录
redis_dir="/export/docker/redis_cluster"
#端口范围，要至少6个才可以
redis_port_range="7001 7006"
redis_password="TestRedis123"

echo "IP:${ip}"
echo "redis_version:${redis_version}"
echo "redis_dir:${redis_dir}"
echo "redis_password:${redis_password}"