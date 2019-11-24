#!/bin/bash

# 导入配置
source env-conf.sh

echo '停止redis集群容器，可用 start 启动...'
for port in `seq ${redis_port_range}`; do \
 docker stop redis-${port}
done