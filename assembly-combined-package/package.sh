#!/bin/bash
SHELL_DIR="$( cd "$( dirname "$0" )" && pwd )"
PWDPATH=`pwd`
cd $SHELL_DIR
cd ../
git pull

export MAVEN_OPTS="-Xms2g -Xmx2g"
mvn -N install
mvn -T 12 -B clean install -pl '!:public-module-combined,!:linkis-package,!:linkis-install-package' -DskipTests
mvn clean install -pl ':public-module-combined,:linkis-package,:linkis-install-package' -DskipTests


ls -l assembly-combined-package/target/

cd $PWDPATH
