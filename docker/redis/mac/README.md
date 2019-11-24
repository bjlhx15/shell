4.1、基础
1、注意点
    envsubst 安装：
        brew install gettext 
        brew link --force gettext
    终端获取dockerip方法  
        [014-docker-终端获取 docker 容器(container)的 ip 地址](https://www.cnblogs.com/bjlhx/p/11918099.html)
2、创建搭建集群所需的conf文件，
    如：redis-cluster.tmpl
3、基础配置文件【需要手工配置】
    env-conf.sh
```bash
#!/bin/bash

echo "读取配置..."
#服务器内网ip
ip="192.170.25.170"
#redis镜像版本
redis_version="5.0.3"
#集群文件放置目录
redis_dir="/Users/lihongxu6/docker/redis/redis-cluster"
#端口范围，要至少6个才可以
redis_port_range="7000 7005"

echo "IP:${ip}"
echo "redis_version:${redis_version}"
echo "redis_dir:${redis_dir}"
```    
4、脚本命令说明
initup.sh   初始化环境
create.sh   新建一个redis docker 集群
destroy.sh  销毁一个redis docker 集群

start.sh            启动
stop.sh             停止
4.2、执行过程
1、initup.sh  初始化构建 【不论现有环境如何，都可以初始化构建，但是结果 会销毁集群中数据】
    ./initup.sh  执行即可，主要是配置网络以及，构建配置文件
    最后会进入第一个的docker中，继续执行：
        ./exe.sh  主要是构建集群，将几个节点互相配置
    配置完毕，使用即可【手工进入docker中：docker exec -it redis-7000 bash】
        redis-cli -p 7000 -c
        set akey avalue
2、平常可以停止，使用时候再启动【当然也可以销毁，在建，数据存在】
    start.sh            启动
    stop.sh             停止
3、销毁以及新建
    create.sh   新建一个集群，指的是新建docker容器，不使用新配置，所以在新建时候，不会销毁数据
    destroy.sh     销毁一个集群，指的是销毁docker容器，不删除配置，所以在需要再次使用时，可以 使用 init-newcreate.sh 新建
    