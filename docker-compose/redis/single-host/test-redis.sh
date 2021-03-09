#!/usr/bin/env bash

###################### 变量定义 ######################
# 主节点容器列表
master_containers=(redis-master1 redis-master2 redis-master3)
# 从节点容器列表
slave_containers=(redis-slave1 redis-slave2 redis-slave3)
# docker用局域网名称
network_name=jzktest

###################### 查看集群 ######################
echo "================================================="
nodes_cmd="echo cluster nodes | redis-cli -c "
nodes_info=`docker exec ${master_containers[0]} sh -c "${nodes_cmd}"`
echo "get cluster info from ${master_containers[0]}:"
echo "${nodes_info}"
echo
echo

###################### 插入数据 ######################
echo "================================================="
set_cmd="echo set key1 value1 | redis-cli -c "
set_info=`docker exec ${master_containers[0]} sh -c "${set_cmd}"`
echo "set key1:value1 into cluster from ${master_containers[0]}, status: ${set_info}"

set_cmd="echo set key2 value2 | redis-cli -c "
set_info=`docker exec ${master_containers[0]} sh -c "${set_cmd}"`
echo "set key2:value2 into cluster from ${master_containers[0]}, status: ${set_info}"

set_cmd="echo set key3 value3 | redis-cli -c "
set_info=`docker exec ${master_containers[0]} sh -c "${set_cmd}"`
echo "set key3:value3 into cluster from ${master_containers[0]}, status: ${set_info}"

###################### master读数据 ######################
echo "================================================="
for master in "${master_containers[@]}";do
  echo "get test data from ${master}: "
  get_cmd="echo get key1 | redis-cli -c "
  get_info=`docker exec ${master} sh -c "${get_cmd}"`
  echo "key1: ${get_info}"
  get_cmd="echo get key2 | redis-cli -c "
  get_info=`docker exec ${master} sh -c "${get_cmd}"`
  echo "key2: ${get_info}"
  get_cmd="echo get key3 | redis-cli -c "
  get_info=`docker exec ${master} sh -c "${get_cmd}"`
  echo "key3: ${get_info}"
  echo
done
echo
echo


###################### slave读数据 ######################
echo "================================================="
for slave in "${slave_containers[@]}";do
  echo "get test data from ${slave}: "
  get_cmd="echo get key1 | redis-cli -c "
  get_info=`docker exec ${slave} sh -c "${get_cmd}"`
  echo "key1: ${get_info}"
  get_cmd="echo get key2 | redis-cli -c "
  get_info=`docker exec ${slave} sh -c "${get_cmd}"`
  echo "key2: ${get_info}"
  get_cmd="echo get key3 | redis-cli -c "
  get_info=`docker exec ${slave} sh -c "${get_cmd}"`
  echo "key3: ${get_info}"
  echo
done
echo
echo


