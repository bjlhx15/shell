
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



###################### 查看集群 ######################
echo "================================================="
nodes_cmd="echo cluster nodes | redis-cli -c "
nodes_info=`sshpass -p ${host1_pw} ssh ${host1_user}@${host1_ip} "docker exec ${host1_master_containers[0]} sh -c \"${nodes_cmd}\""`
echo "get cluster info from ${host1_master_containers[0]}:"
echo "${nodes_info}"
echo
echo
sleep 3


###################### 插入数据 ######################
echo "================================================="
set_cmd="echo set key1 value1 | redis-cli -c "
set_info=`sshpass -p ${host1_pw} ssh ${host1_user}@${host1_ip} "docker exec ${host1_master_containers[0]} sh -c \"${set_cmd}\""`
echo "set key1:value1 into cluster from ${host1_master_containers[0]}, status: ${set_info}"

set_cmd="echo set key2 value2 | redis-cli -c "
set_info=`sshpass -p ${host1_pw} ssh ${host1_user}@${host1_ip} "docker exec ${host1_master_containers[0]} sh -c \"${set_cmd}\""`
echo "set key2:value2 into cluster from ${host1_master_containers[0]}, status: ${set_info}"

set_cmd="echo set key3 value3 | redis-cli -c "
set_info=`sshpass -p ${host1_pw} ssh ${host1_user}@${host1_ip} "docker exec ${host1_master_containers[0]} sh -c \"${set_cmd}\""`
echo "set key3:value3 into cluster from ${host1_master_containers[0]}, status: ${set_info}"





###################### master读数据 ######################
echo "================================================="

for i in $(seq 1 ${num_host});do
  user=$(eval echo \$host${i}_user)
  ip=$(eval echo \$host${i}_ip)
  pw=$(eval echo \$host${i}_pw)

  host_name="host${i}_master_containers"
  host_master_containers=( $(eval echo \${${host_name}[@]}) )

  for master in "${host_master_containers[@]}";do
    echo "get test data from ${master}: "
    get_cmd="echo get key1 | redis-cli -c "
    get_info=`sshpass -p ${pw} ssh ${user}@${ip} "docker exec ${master} sh -c \"${get_cmd}\""`
    echo "key1: ${get_info}"
    get_cmd="echo get key2 | redis-cli -c "
    get_info=`sshpass -p ${pw} ssh ${user}@${ip} "docker exec ${master} sh -c \"${get_cmd}\""`
    echo "key2: ${get_info}"
    get_cmd="echo get key3 | redis-cli -c "
    get_info=`sshpass -p ${pw} ssh ${user}@${ip} "docker exec ${master} sh -c \"${get_cmd}\""`
    echo "key3: ${get_info}"
    echo

  done

done


###################### slave读数据 ######################
echo "================================================="


for i in $(seq 1 ${num_host});do
  user=$(eval echo \$host${i}_user)
  ip=$(eval echo \$host${i}_ip)
  pw=$(eval echo \$host${i}_pw)

  host_name="host${i}_slave_containers"
  host_slave_containers=( $(eval echo \${${host_name}[@]}) )

  for slave in "${host_slave_containers[@]}";do
    echo "get test data from ${slave}: "
    get_cmd="echo get key1 | redis-cli -c "
    get_info=`sshpass -p ${pw} ssh ${user}@${ip} "docker exec ${slave} sh -c \"${get_cmd}\""`
    echo "key1: ${get_info}"
    get_cmd="echo get key2 | redis-cli -c "
    get_info=`sshpass -p ${pw} ssh ${user}@${ip} "docker exec ${slave} sh -c \"${get_cmd}\""`
    echo "key2: ${get_info}"
    get_cmd="echo get key3 | redis-cli -c "
    get_info=`sshpass -p ${pw} ssh ${user}@${ip} "docker exec ${slave} sh -c \"${get_cmd}\""`
    echo "key3: ${get_info}"
    echo

  done

done
