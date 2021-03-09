#!/bin/bash


function install(){
	# 下载
	docker pull zookeeper:3.6
	docker images|grep zookeeper
	# 2181　　Zookeeper客户端交互端口
	# 2888　　Zookeeper集群端口
	# 3888　　Zookeeper选举端口
	# docker run --name zk_single \
	# 	-p  12181:2181 -p 12888:2888 -p 13888:3888 \
	# 	--restart always -d zookeeper:3.5
	# docker logs -f zk_single  
	# 可以看到 /conf/zoo.cfg 配置文件
	docker run --name zk_single -p  12181:2181 -p 12888:2888 -p 13888:3888 \
	 -v /Users/lihongxu6/docker/zookeeper/single/conf:/conf \
	 -v /Users/lihongxu6/docker/zookeeper/single/data:/data \
		-v /Users/lihongxu6/docker/zookeeper/single/datalog:/datalog \
		--restart always -d zookeeper:3.6
}

function show_test(){
	docker logs -f zk_single
}

function main(){
	install
}

main $@