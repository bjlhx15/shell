#!/usr/bin/env bash



docker-compose -f docker-compose-cluster-redis.yaml down


rm -rf /data/redisdata/redis-master1/*   /data/redisdata/redis-master2/*  /data/redisdata/redis-master3/* /data/redisdata/redis-slave1/*  /data/redisdata/redis-slave2/*  /data/redisdata/redis-slave3/*
