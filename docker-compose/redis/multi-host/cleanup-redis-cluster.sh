#!/usr/bin/env bash

###################### 变量定义 ######################
# 重试间隔时间 s
retry_duration=5
# docker用局域网名称
network_name=overlay-cluster
# host主机个数
num_host=2
# 服务集群实例数
num_instance=3
# 项目所在home目录
prj_dir=`pwd`
# 项目依赖软件、工具
tools_dep=(docker docker-compose sshpass)

# host1 用户
host1_user="root"
# host1 ip
host1_ip="49.232.45.32"
# host1 密码
host1_pw="xxxx"
# host1使用docker-compose yaml文件
host1_yaml="./docker-compose/docker-compose-cluster-redis-host1.yaml"

# host2 用户
host2_user="root"
# host2 ip
host2_ip="106.53.75.44"
# host1 密码
host2_pw="xxxx"
# host1使用docker-compose yaml文件
host2_yaml="./docker-compose/docker-compose-cluster-redis-host2.yaml"


# host1上主节点容器列表
host1_master_containers=( redis-master1 )
# host1上从节点容器列表
host1_slave_containers=(redis-slave2 redis-slave3)
# host2上主节点容器列表
host2_master_containers=(redis-master2 redis-master3)
# host2上从节点容器列表
host2_slave_containers=( redis-slave1 )



data_dir=""
for i in $(seq 1 ${num_instance});do
  data_dir+="/data/redisdata/redis-master${i}/*   /data/redisdata/redis-slave${i}/*  "
done



for i in $(seq 1 ${num_host}); do
  user=$(eval echo \$host${i}_user)
  ip=$(eval echo \$host${i}_ip)
  pw=$(eval echo \$host${i}_pw)
  yaml=$(eval echo \$host${i}_yaml)

  set -x
  sshpass -p ${pw} ssh ${user}@${ip} "cd ${prj_dir}; docker-compose -f ${yaml} down; rm -rf ${data_dir}"
  set +x

done



