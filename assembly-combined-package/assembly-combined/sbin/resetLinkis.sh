#!/bin/bash
SHELL_DIR="$( cd "$( dirname "$0" )" && pwd )"
PWDPATH=`pwd`
cd $SHELL_DIR
cd ../
INSTALL_HOME=`pwd`
echo INSTALL_HOME=$INSTALL_HOME
APPDIR=/appcom/Install
echo APPDIR=$APPDIR

chown -R hadoop:hadoop $APPDIR
chown -R hadoop:hadoop /tmp/linkis/

if [ -f "$APPDIR/dss/sbin/dss-stop-all.sh" ];then
  su - hadoop -c "sh /$APPDIR/dss/sbin/dss-stop-all.sh"
  ps -ef | grep -v grep| grep java | grep dss | awk '{print $2}' | xargs kill -9 2>/dev/null
  find $APPDIR/dss/dss-appconns/ -name "*.index" | xargs rm -rf
fi
if [ -f "$APPDIR/LinkisInstall/sbin/linkis-stop-all.sh" ];then
  su - hadoop -c "sh $APPDIR/LinkisInstall/sbin/linkis-stop-all.sh"
  ps -ef | grep -v grep | grep java | grep linkis | awk '{print $2}' | xargs kill -9 2>/dev/null
fi

# clear log
if [ -d "$APPDIR/LinkisInstall/logs" ];then
rm -rf $APPDIR/LinkisInstall/logs/*
fi
if [ -d "$APPDIR/dss/logs" ];then
rm -rf $APPDIR/dss/logs/*
fi

rm -rf /appcom/tmp/engineConnPublickDir/*


# restore database linkis
if [ -f "$APPDIR/LinkisInstall/sbin/linkis-stop-all.sh" ];then
LINKIS_HOME=/appcom/Install/LinkisInstall
source ${LINKIS_HOME}/conf/db.sh
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB  --default-character-set=utf8 -e "source ${LINKIS_HOME}/db/linkis_ddl.sql"
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB  --default-character-set=utf8 -e "source ${LINKIS_HOME}/db/linkis_dml.sql"
fi

# restore database dss
if [ -f "$APPDIR/dss/sbin/dss-stop-all.sh" ];then
DSS_HOME=/appcom/Install/dss
source ${DSS_HOME}/conf/db.sh
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB  --default-character-set=utf8 -e "UPDATE dss_appconn SET appconn_class_path = CONCAT(appconn_class_path,'/lib'),resource='' WHERE resource<>''"
fi


# restore database linkis

if [ -f "$APPDIR/LinkisInstall/sbin/linkis-start-all.sh" ];then
  su - hadoop -c "sh $APPDIR/LinkisInstall/sbin/linkis-start-all.sh"
fi
if [ -f "$APPDIR/dss/sbin/dss-start-all.sh" ];then
  su - hadoop -c "sh $APPDIR/dss/sbin/dss-start-all.sh"
fi

echo 'sh $INSTALL_HOME/bin/linkis-cli-hive -code "show databases;" -submitUser hadoop -proxyUser hadoop'
sh $INSTALL_HOME/bin/linkis-cli-hive -code "show databases;" -submitUser hadoop -proxyUser hadoop

cd $PWDPATH
