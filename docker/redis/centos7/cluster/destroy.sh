#!/bin/bash

# 导入配置
source env-conf.sh

echo '强制销毁docker redis集群容器...'
for port in `seq ${redis_port_range}`; do \
 docker rm -f redis-${port}
done
docker ps -a|grep redis
echo 'docker 容器销毁完成...'