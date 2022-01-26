#!/bin/bash
SHELL_DIR="$( cd "$( dirname "$0" )" && pwd )"
PWDPATH=`pwd`
cd $SHELL_DIR
cd ../
INSTALL_HOME=`pwd`
echo INSTALL_HOME=$INSTALL_HOME
APPDIR=/appcom/Install
echo APPDIR=$APPDIR

#测试hive引擎
echo 'sh $INSTALL_HOME/bin/linkis-cli-hive -code "show databases;" -submitUser hadoop -proxyUser hadoop'
sh $INSTALL_HOME/bin/linkis-cli-hive -code "show databases;" -submitUser hadoop -proxyUser hadoop

#测试spark引擎
echo 'sh $INSTALL_HOME/bin/linkis-cli-spark-sql -code "show databases;" -submitUser hadoop -proxyUser hadoop'
sh $INSTALL_HOME/bin/linkis-cli-spark-sql -code "show databases;" -submitUser hadoop -proxyUser hadoop

#测试shell引擎
echo 'sh $INSTALL_HOME/bin/linkis-cli -engineType shell-1 -code "echo \"hello world\"" -codeType shell -submitUser hadoop -proxyUser hadoop'
sh $INSTALL_HOME/bin/linkis-cli -engineType shell-1 -code "echo \"hello world\"" -codeType shell -submitUser hadoop -proxyUser hadoop

#测试JDBC引擎
echo 'sh $INSTALL_HOME/bin/linkis-cli -engineType jdbc-4 -code "show databases;" -codeType sql -confMap wds.linkis.jdbc.username=hadoop,wds.linkis.jdbc.password=hadoop'
sh $INSTALL_HOME/bin/linkis-cli -engineType jdbc-4 -code "show databases;" -codeType sql -confMap wds.linkis.jdbc.username=hadoop,wds.linkis.jdbc.password=hadoop


cd $PWDPATH


