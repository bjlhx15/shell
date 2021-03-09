#!/usr/bin/env bash

set -e

###################### 变量定义 ######################
# 主节点容器列表
master_containers=(redis-master1 redis-master2 redis-master3)
# 从节点容器列表
slave_containers=(redis-slave1 redis-slave2 redis-slave3)
# docker用局域网名称
network_name=jzktest

###################### 创建局域网 ######################
echo "================================================="
echo "check docker network..."
num=`docker network ls | grep ${network_name} | wc -l`
if [ ${num} -ne 1 ];then
  echo "docker network ${network_name} not exist, creating..."
  docker network create ${network_name}
else
  echo "docker network ${network_name} already exit. "
fi

echo
echo

###################### 启动集群实例 ######################
echo "================================================="
echo "start redis cluster instance..."
docker-compose -f docker-compose-cluster-redis.yaml up -d
echo "start redis cluster instance success, include 3 master nodes and 3 slave nodes."
echo
echo
sleep 10

###################### 创建redis集群 ######################
echo "================================================="
# 所有主节点容器ip+port
cluster_info=""
for master in "${master_containers[@]}";do
  cluster_info+=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${master}`
  cluster_info+=":6379 "
done

echo "init redis cluster..."
# 版本小于5.0的集群启动命令
start_cluster_cmd="redis-trib.rb create --replicas 0 ${cluster_info} "
# 版本大于5.0的集群启动命令
#start_cluster_cmd2="redis-cli --cluster create ${cluster_info} --cluster-replicas 0"

# 任一主节点执行即可
# exp:  redis-trib.rb create --replicas 0 172.17.0.6:6379 172.17.0.8:6379 172.17.0.5:6379
docker exec ${master_containers[0]} sh -c "echo yes | ${start_cluster_cmd} && exit"
echo "init redis cluster success."
echo
echo

###################### 输出集群信息 ######################
echo "================================================="
echo "the cluster info:"
cluster_master_nodes=""
for master in "${master_containers[@]}";do
  cluster_master_nodes+="${master} "
done
cluster_slave_nodes=""
for slave in "${slave_containers[@]}";do
  cluster_slave_nodes+="${slave} "
done
echo "cluster master nodes: ${cluster_master_nodes}"
echo "cluster slave nodes: ${cluster_slave_nodes}"
echo
echo

echo -e "\033[42;34m finish success !!! \033[0m"

