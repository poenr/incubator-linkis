#!/bin/bash

docker-compose down
rm -rf ./tmp/*
rm -rf ./logs/*
rm -rf ./linkis-engineconn-plugins/*

chmod a+rwx ./tmp
chmod a+rwx ./logs
chmod a+rwx ./linkis
chmod a+rwx ./linkis-engineconn-plugins

chown hadoop:hadoop ./tmp
chown hadoop:hadoop ./logs
chown hadoop:hadoop ./linkis
chown hadoop:hadoop ./linkis-engineconn-plugins

chmod a+rw /var/run/docker.sock 

docker-compose up -d
docker-compose logs -f

:<<!
docker-compose exec linkis-cg-engineplugin sh /appcom/Install/LinkisInstall/bin/linkis-cli-hive -code "show databases;" -submitUser hadoop -proxyUser hadoop

docker-compose exec linkis-cg-engineplugin sh /appcom/Install/LinkisInstall/bin/linkis-cli-spark-sql -code "show databases;" -submitUser hadoop -proxyUser hadoop

docker-compose exec linkis-cg-engineplugin sh /appcom/Install/LinkisInstall/bin/linkis-cli -engineType shell-1 -code "echo \"hello world\"" -codeType shell -submitUser hadoop -proxyUser hadoop

#测试JDBC引擎
docker-compose exec linkis-cg-engineplugin sh /appcom/Install/LinkisInstall/bin/linkis-cli -engineType jdbc-4 -code "show databases;" -codeType sql -confMap wds.linkis.jdbc.username=hadoop,wds.linkis.jdbc.password=hadoop


!