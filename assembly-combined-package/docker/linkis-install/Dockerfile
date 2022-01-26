FROM harbor.software.dc/mpdata/linkis-emr-base:latest
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

ADD target/apache-linkis-1.0.3-incubating-bin.tar.gz /apache-linkis-1.0.3-incubating-bin
RUN ls -l /
RUN ls -l /apache-linkis-1.0.3-incubating-bin
RUN ls -l /apache-linkis-1.0.3-incubating-bin/*
ENV SIDIR=/apache-linkis-1.0.3-incubating-bin
RUN sed -i "s#MYSQL_HOST=127.0.0.1#MYSQL_HOST=linkis-mysql#g" $SIDIR/deploy-config/db.sh
RUN sed -i "s#MYSQL_DB=linkis#MYSQL_DB=linkis#g"  $SIDIR/deploy-config/db.sh
RUN sed -i "s#MYSQL_USER=root#MYSQL_USER=root#g"  $SIDIR/deploy-config/db.sh
RUN sed -i "s#MYSQL_PASSWORD=123456#MYSQL_PASSWORD=123456#g" $SIDIR/deploy-config/db.sh
RUN sh $SIDIR/bin/install.sh 1
RUN rm -rf /SIDIR
RUN rm -rf /appcom/Install/LinkisInstall-bak && rm -rf /appcom/Install/dss
RUN chown -R hadoop:hadoop /appcom/Install/
RUN chown -R hadoop:hadoop /appcom/config/
RUN chown -R hadoop:hadoop /appcom/tmp/
RUN chown -R hadoop:hadoop /tmp/linkis/
RUN chown -R hadoop:hadoop /opt/


RUN ls -l /appcom/Install/
RUN ls -l /appcom/config/
RUN ls -l /appcom/tmp/
RUN ls -l /tmp/linkis/

VOLUME /appcom/tmp/
VOLUME /tmp/linkis/
VOLUME /appcom/Install/LinkisInstall/lib/linkis-engineconn-plugins

WORKDIR /appcom/Install/LinkisInstall




