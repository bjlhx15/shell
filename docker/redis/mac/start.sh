#!/bin/bash

# 导入配置
source env-conf.sh

echo '启动redis集群容器...'
for port in `seq ${redis_port_range}`; do \
 docker start redis-${port}
done