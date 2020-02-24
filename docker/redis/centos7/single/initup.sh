#!/bin/bash


function install_redis(){
	docker pull redis:5.0.3
	docker images|grep redis
	mkdir -p /export/docker/redis_single/data
	touch /export/docker/redis_single/redis.conf
	echo 'protected-mode no'>>/export/docker/redis_single/redis.conf
	echo 'appendonly yes'>>/export/docker/redis_single/redis.conf
	docker run -d --privileged=true -p 56379:6379 \
		-v /export/docker/redis_single/redis.conf:/etc/redis/redis.conf \
		-v /export/docker/redis_single/data:/data \
		--name redis_single redis:5.0.3 redis-server /etc/redis/redis.conf --appendonly yes --requirepass "RedisTest_1234"
}

function show_test(){
	docker exec -it redis_single redis-cli
}

function main(){
	install_redis
}

main $@