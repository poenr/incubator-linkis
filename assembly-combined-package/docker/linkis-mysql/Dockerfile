FROM harbor.software.dc/mysql/mysql:5.7
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

ADD docker/linkis-mysql/my.cnf /etc/mysql/conf.d/my.cnf

ADD tmp/linkis_db.sql  /docker-entrypoint-initdb.d/01.linkis_db.sql.sql
ADD tmp/linkis_ddl.sql /docker-entrypoint-initdb.d/02.linkis_ddl.sql.sql
ADD tmp/linkis_dml.sql /docker-entrypoint-initdb.d/03.linkis_dml.sql.sql

EXPOSE 3306




