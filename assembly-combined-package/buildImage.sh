#!/bin/bash
SHELL_DIR="$( cd "$( dirname "$0" )" && pwd )"
PWDPATH=`pwd`
cd $SHELL_DIR



# Base镜像
docker build \
-t harbor.software.dc/mpdata/linkis-emr-base:latest -f ./docker/emr-base/Dockerfile ./ --squash 

# 如果测试hdfs需加上/etc/host配置
:<<!
--add-host namenode:172.18.8.174 \
--add-host datanode:172.18.8.174 \
--add-host resourceserver:172.18.8.174 \
--add-host nodemanager:172.18.8.174 \
--add-host historyserver:172.18.8.174 \
--add-host hive-server:172.18.8.174  \
--add-host hive-metastore:172.18.8.174 \
--add-host hive-metastore-mysql:172.18.8.174
!

# 所有linkis组件放在一个镜像中，使用不同的脚本启动
docker build -t harbor.software.dc/mpdata/linkis-install:1.0.3-ljgk -f ./docker/linkis-install/Dockerfile ./ --squash \
--add-host namenode:172.18.8.174 \
--add-host datanode:172.18.8.174 \
--add-host resourceserver:172.18.8.174 \
--add-host nodemanager:172.18.8.174 \
--add-host historyserver:172.18.8.174 \
--add-host hive-server:172.18.8.174  \
--add-host hive-metastore:172.18.8.174 \
--add-host hive-metastore-mysql:172.18.8.174

# linkis使用的数据库镜像，需要处理初始化数据
if [ -d "./tmp/" ] ; then
rm -rf ./tmp/
fi
mkdir ./tmp/
cp ./deploy-config/linkis-env.sh ./tmp/
echo "CREATE DATABASE IF NOT EXISTS linkis DEFAULT CHARSET utf8 COLLATE utf8_general_ci;" >> ./tmp/linkis_db.sql 
cp ../db/linkis_ddl.sql ./tmp/
cp ../db/linkis_dml.sql ./tmp/
source ./tmp/linkis-env.sh

if [ "$YARN_RESTFUL_URL" != "" ]
then
  sed -i ${txt}  "s#@YARN_RESTFUL_URL#$YARN_RESTFUL_URL#g" ./tmp/linkis_dml.sql
fi
if [ "$SPARK_VERSION" != "" ]
then
  sed -i ${txt}  "s#spark-2.4.3#spark-$SPARK_VERSION#g" ./tmp/linkis_dml.sql
fi
if [ "$HIVE_VERSION" != "" ]
then
  sed -i ${txt}  "s#hive-1.2.1#hive-$HIVE_VERSION#g" ./tmp/linkis_dml.sql
fi
if [ "$PYTHON_VERSION" != "" ]
then
  sed -i ${txt}  "s#python-python2#python-$PYTHON_VERSION#g" ./tmp/linkis_dml.sql
fi

docker build -t harbor.software.dc/mpdata/linkis-mysql:1.0.3-ljgk -f ./docker/linkis-mysql/Dockerfile ./ --squash \

cd $PWDPATH

:<<!
docker ps -a |grep Created | awk '{print $1}' | xargs docker rm
docker ps -a |grep Exited | awk '{print $1}' | xargs docker rm
docker images prune
docker images | grep none  | awk '{print $3}' | xargs docker rmi
!
