#!/bin/bash
SHELL_DIR="$( cd "$( dirname "$0" )" && pwd )"
PWDPATH=`pwd`
cd $SHELL_DIR
cd ../
INSTALL_HOME=`pwd`

APPDIR=$INSTALL_HOME/../
echo APPDIR=$APPDIR

if [ -f "$APPDIR/dss/sbin/dss-stop-all.sh" ];then
  su - hadoop -c "sh /$APPDIR/dss/sbin/dss-stop-all.sh"
  ps -ef | grep -v grep| grep java | grep dss | awk '{print $2}' | xargs kill -9 2>/dev/null
  find $APPDIR/dss/dss-appconns/ -name "*.index" | xargs rm -rf
fi
if [ -f "$APPDIR/LinkisInstall/sbin/linkis-stop-all.sh" ];then
  su - hadoop -c "sh $APPDIR/LinkisInstall/sbin/linkis-stop-all.sh"
  ps -ef | grep -v grep | grep java | grep linkis | awk '{print $2}' | xargs kill -9 2>/dev/null
fi

cd $PWDPATH



