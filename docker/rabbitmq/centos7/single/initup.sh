#!/bin/bash


function install(){
	docker pull rabbitmq:3.7.13-management
	docker images|grep rabbitmq
	mkdir -p /export/docker/rabbitmq_single
	docker run -d -p 5672:5672 -p 15672:15672 \
		-v /export/docker/rabbitmq_single:/var/lib/rabbitmq \
		--name rabbitmq_single --hostname rabbitmq_single \
		-e RABBITMQ_DEFAULT_USER=rabbitmqAdmin -e RABBITMQ_DEFAULT_PASS=RabbitmqTest_1234 rabbitmq:3.7.13-management
}

function show_test(){
}

function main(){
	install
}

main $@