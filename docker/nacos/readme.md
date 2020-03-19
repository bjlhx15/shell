https://nacos.io/zh-cn/docs/quick-start-docker.html
# 下载
``` BASH
docker pull nacos/nacos-server
```
# 配置
    可以自定义账号密码，并将账号密码存储进我们自己的数据库，需要修改/nacos/conf/application.properties文件，nacos默认使用的数据库为内嵌的cmdb
    默认账号密码为 nacos/nacos
- 方式一、内置数据库
``` BASH
docker run --env MODE=standalone --name nacos_single -d -p 18848:8848 nacos/nacos-server
```
更多：https://nacos.io/zh-cn/docs/quick-start-docker.html

方式二、外部mysql
1. 创建数据库：
```mysql
create database nacos_config
```
2. 初始化数据库，导入初始化文件nacos-db.sql

# 创建nacos容器
``` BASH
docker run -d \
-e PREFER_HOST_MODE=hostname \
-e MODE=standalone \
-e SPRING_DATASOURCE_PLATFORM=mysql \
-e MYSQL_MASTER_SERVICE_HOST=数据库ip \
-e MYSQL_MASTER_SERVICE_PORT=数据库端口 \
-e MYSQL_MASTER_SERVICE_USER=用户名 \
-e MYSQL_MASTER_SERVICE_PASSWORD=密码 \
-e MYSQL_MASTER_SERVICE_DB_NAME=对应的数据库名 \
-e MYSQL_SLAVE_SERVICE_HOST=从数据库ip \
-p 8848:8848 \
--name nacos-sa-mysql \
--restart=always \
nacos/nacos-server
```
注意：这里有个注意的是MYSQL_SLAVE_SERVICE_HOST也需要配置，因为通过查看nacos容器内的config/application.properties文件，会发现这此值未设置默认值，所以会导致启动报错，容器启动不起来，这里可以与主数据库一致。

# 访问

默认用户名密码都为nacos
http://localhost:18848/nacos
测试：进入控制台，并添加测试配置


