#!/bin/bash

echo "读取配置..."
#服务器内网ip
ip="10.13.225.196"
#ip="192.168.199.220"
#redis镜像版本
redis_version="5.0.3"
#集群文件放置目录
redis_dir="/Users/lihongxu6/docker/redis/redis-cluster"
#端口范围，要至少6个才可以
redis_port_range="7000 7005"
redis_password="TestRedis123"

echo "IP:${ip}"
echo "redis_version:${redis_version}"
echo "redis_dir:${redis_dir}"