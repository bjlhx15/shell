#!/bin/bash

# 导入配置
source env-conf.sh

#判断问加减是否存在 如果存在删除后创建，不存在创建
echo "redis集群目录重置,将会清空一下目录所有文件:${redis_dir}/..."
while true
do
	read -r -p "Are You Sure? [Y/n] " input

	case $input in
	    [yY][eE][sS]|[yY])
			echo "Yes"
			break
			;;

	    [nN][oO]|[nN])
			echo "No"
			exit 1
			;;

	    *)
			echo "Invalid input..."
			;;
	esac
done
echo "redis集群目录重置,清空开始..."
rm -f -r ${redis_dir}
# if [ -f "${redisdir}"} ];then
# 	rm -f -r ${redisdir}
# fi
mkdir -p ${redis_dir}

echo "开始构建redis集群目录..."

for port in `seq ${redis_port_range}`; do \
  mkdir -p ${redis_dir}/${port}/conf \
  && PORT=${port} IP=${ip} envsubst < ./redis-cluster.tmpl > ${redis_dir}/${port}/conf/redis.conf \
  && mkdir -p ${redis_dir}/${port}/data; \
  echo "构建配置文件：${redis_dir}/${port}/conf/redis.conf..."
  echo "构建数据目录：${redis_dir}/${port}/data..."
done

#exit;

echo "拉取redis:${redis_version}镜像..."

#拉取redis镜像
docker pull redis:${redis_version}

#为redis集群创建docker网桥
docker network create redis-net

echo "创建网桥..."
#查看docker所有的网桥
docker network ls

echo "创建并运行redis集群容器..."

#定义一个初始值变量，用于叠加ip
execsh='/usr/local/bin/redis-cli --cluster create '
#创建redis运行容器
for port in `seq ${redis_port_range}`; do \
  docker run -d -ti -p ${port}:${port} -p 1${port}:1${port} \
  -v ${redis_dir}/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf \
  -v ${redis_dir}/${port}/data:/data \
  --restart always --name redis-${port} --net redis-net \
  --sysctl net.core.somaxconn=1024 redis:${redis_version} redis-server /usr/local/etc/redis/redis.conf; \
  #获取docker分配的ip
  execsh=${execsh}`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-${port}`:${port}' '
done

execsh=${execsh}'--cluster-replicas 1'

#将拼接好的命令打印到控制台
echo ${execsh}

arr=(${redis_port_range})
first=${arr[0]}

echo "通过后会自动进入第一个集群节点，请输入：./exe.sh， 继续会提示输入：yes； 然后进入调试：redis-cli -p ${first} -c "

#将控制台的打印命令写入exe.sh脚本，docker容器直接执行就好
echo "${execsh}" > ${redis_dir}/${first}/data/exe.sh

#给exe.sh权限
chmod 777 ${redis_dir}/${first}/data/exe.sh

#进入第一个redis容器内
docker exec -it redis-${first} bash