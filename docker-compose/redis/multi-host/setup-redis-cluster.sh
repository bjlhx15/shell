#!/usr/bin/env bash

set -e

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


###################### 检查依赖 ######################
set +e
echo "================================================="
echo "check dependency tools for all hosts..."
for tool in "${tools_dep[@]}"; do

    for i in $(seq 1 ${num_host}); do
      user=$(eval echo \$host${i}_user)
      ip=$(eval echo \$host${i}_ip)
      pw=$(eval echo \$host${i}_pw)

      sshpass -p ${pw} ssh ${user}@${ip} "which ${tool}"
      if [ "$?" -ne 0 ]; then
        echo "not found ${tool} on host${i}, please install firstly. "
        exit 1
      fi
      echo "found ${tool} on host${i}"
    done
done
echo "check dependency success."
echo
echo
sleep 5
set -e

###################### 检查文件 ######################
echo "================================================="
echo "check project directory for all remote hosts..."
for i in $(seq 1 ${num_host}); do
  user=$(eval echo \$host${i}_user)
  ip=$(eval echo \$host${i}_ip)
  pw=$(eval echo \$host${i}_pw)

  if  sshpass -p ${pw} ssh ${user}@${ip} test -e ${prj_dir} ; then
    # exit
    echo "project directory(${prj_dir}) already exist on host${i}, skip scp. "
  else
    # not exist
    echo "project directory(${prj_dir}) not exist on host${i}, scp it from host1. "
    set -x
    sshpass -p ${pw} ssh ${user}@${ip} "mkdir -p ${prj_dir}"
    sshpass -p ${pw} scp -r ${prj_dir}/* ${user}@${ip}:${prj_dir}
    set +x
  fi

  echo "project directory on host${i}"
done
echo "check project directory success. "
echo
echo
sleep 5


###################### 检查overlay网络 ######################
echo "================================================="
echo "check docker overlay network..."

for i in $(seq 1 ${num_host}); do
  user=$(eval echo \$host${i}_user)
  ip=$(eval echo \$host${i}_ip)
  pw=$(eval echo \$host${i}_pw)

  num=$(sshpass -p ${pw} ssh ${user}@${ip} "docker network ls | grep ${network_name} | wc -l" )
  if [ ${num} -ne 1 ];then
    echo "not found overlay network ${network_name} on host{i}, please create firstly."
    exit 1
  else
    echo "found overlay network ${network_name} on host${i}."
  fi

done
echo "check overlay network success."
echo
echo
sleep 5


###################### 启动服务实例 ######################
echo "================================================="
echo "start service instance..."

for i in $(seq 1 ${num_host}); do
  user=$(eval echo \$host${i}_user)
  ip=$(eval echo \$host${i}_ip)
  pw=$(eval echo \$host${i}_pw)
  yaml=$(eval echo \$host${i}_yaml)

  set -x
  sshpass -p ${pw} ssh ${user}@${ip} "cd ${prj_dir}; docker-compose -f ${yaml} up -d"
  set +x

done
echo "start service instance success."
echo
echo
sleep 5




###################### 创建redis集群 ######################
echo "================================================="
# 所有主机上的所有主节点容器ip+port
cluster_info=""
for master in "${host1_master_containers[@]}";do
  cluster_info+=`sshpass -p ${host1_pw} ssh ${host1_user}@${host1_ip} "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${master}"`
  cluster_info+=":6379 "
done

for i in $(seq 2 ${num_host}); do
  user=$(eval echo \$host${i}_user)
  ip=$(eval echo \$host${i}_ip)
  pw=$(eval echo \$host${i}_pw)

  host_name="host${i}_master_containers"
  host_master_containers=( $(eval echo \${${host_name}[@]}) )

  for container in "${host_master_containers[@]}";do
    cluster_info+=`sshpass -p ${pw} ssh ${user}@${ip} "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${container}"`
    cluster_info+=":6379 "
  done
done

chmod 777 ./image/redis-trib.rb

echo "init redis cluster..."
# 版本小于5.0的集群启动命令
start_cluster_cmd="redis-trib.rb create --replicas 0 ${cluster_info} "
# 版本大于5.0的集群启动命令
#start_cluster_cmd2="redis-cli --cluster create ${cluster_info} --cluster-replicas 0"

# 任一主节点执行即可
# exp:  redis-trib.rb create --replicas 0 172.17.0.6:6379 172.17.0.8:6379 172.17.0.5:6379
sshpass -p ${host1_pw} ssh ${host1_user}@${host1_ip} "docker exec ${host1_master_containers[0]} sh -c \"echo yes | ${start_cluster_cmd} && exit\""
echo "init redis cluster success."
echo
echo

###################### 输出集群信息 ######################
echo "================================================="
echo "the cluster info:"
cluster_master_nodes=""
for i in $(seq ${num_host});do
  host_name="host${i}_master_containers"
  host_master_containers=( $(eval echo \${${host_name}[@]}) )

  for master in "${host_master_containers[@]}";do
    cluster_master_nodes+="${master} "
  done

done

cluster_slave_nodes=""
for i in $(seq ${num_host});do
  host_name="host${i}_slave_containers"
  host_slave_containers=( $(eval echo \${${host_name}[@]}) )

  for slave in "${host_slave_containers[@]}";do
    cluster_slave_nodes+="${slave} "
  done
done

echo "cluster master nodes: ${cluster_master_nodes}"
echo "cluster slave nodes: ${cluster_slave_nodes}"
echo
echo

echo -e "\033[42;34m finish success !!! \033[0m"






