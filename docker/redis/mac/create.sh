#!/bin/bash

# 导入配置
source env-conf.sh

for port in `seq ${redis_port_range}`; do \
  docker run -d -ti -p ${port}:${port} -p 1${port}:1${port} \
  -v ${redis_dir}/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf \
  -v ${redis_dir}/${port}/data:/data \
  --restart always --name redis-${port} --net redis-net \
  --sysctl net.core.somaxconn=1024 redis:${redis_version} redis-server /usr/local/etc/redis/redis.conf;
done