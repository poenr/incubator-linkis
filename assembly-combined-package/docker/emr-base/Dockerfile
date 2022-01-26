FROM harbor.software.dc/centos/centos:centos7.8.2003
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && \
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    yum clean all && yum makecache

RUN yum -y install wget tar zip unzip sudo expect nc which dos2unix telnet curl vim mysql git initscripts net-tools p7zip python-pip python2-pandas
RUN python -m pip install matplotlib -i https://mirrors.aliyun.com/pypi/simple/

#时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone

#hadoop用户
RUN useradd hadoop && echo "hadoop  ALL=(ALL)       NOPASSWD: NOPASSWD: ALL">>/etc/sudoers

RUN wget -c --no-check-certificate http://dl.software.dc/dist/jdk-8u261-linux-x64.tar.gz -O jdk-8u261-linux-x64.tar.gz && \
    tar -xvf jdk-8u261-linux-x64.tar.gz && \
    mkdir -p /usr/java && \
    mv ./jdk1.8.0_261/ /usr/java/  && \
    rm -rf jdk-8u261-linux-x64.tar.gz && \
    echo "">> /etc/profile  && \
    echo "JAVA_HOME=/usr/java/jdk1.8.0_261">> /etc/profile  && \
    echo "JRE_HOME=/usr/java/jdk1.8.0_261/jre">> /etc/profile  && \
    echo "CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib">> /etc/profile  && \
    echo "PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin">> /etc/profile  && \
    echo "export JAVA_HOME JRE_HOME CLASS_PATH PATH">> /etc/profile

ENV JAVA_HOME=/usr/java/jdk1.8.0_261
ENV JRE_HOME=/usr/java/jdk1.8.0_261/jre
ENV CLASS_PATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
RUN java -version

#linkis+dss配置文件所需软链接
RUN mkdir -p /appcom/config && mkdir -p /appcom/Install/LinkisInstall && mkdir -p /appcom/Install/dss && \
    mkdir -p /appcom/tmp && mkdir -p /appcom/tmp/wds/scheduler
RUN rm -rf /appcom/config/hadoop-config && \
    ln -s /opt/hadoop/hadoop-2.7.4/etc/hadoop /appcom/config/hadoop-config && \
    rm -rf /appcom/config/hive-config && \
    ln -s /opt/hive/apache-hive-2.3.9-bin/conf /appcom/config/hive-config && \
    rm -rf /appcom/config/spark-config && \
    ln -s /opt/spark/spark-2.4.4-bin-hadoop2.7/conf /appcom/config/spark-config && \
    rm -rf /appcom/config/flink-config && \
    ln -s /opt/flink/flink-1.10.1/conf /appcom/config/flink-config

RUN git clone http://drone-ci:windows-999@gitlab.software.dc/mp-data/dss/hive-client.git && \
    cd hive-client && \
    git checkout master && \
    ls -l /opt/ && \
    sh install.sh && cd ../ && rm -rf hive-client

RUN echo "">> /etc/profile  && \
    echo "SPARK_HOME=/opt/spark/spark-2.4.4-bin-hadoop2.7">> /etc/profile  && \
    echo "SPARK_CONF_DIR=$SPARK_HOME/conf">> /etc/profile  && \
    echo "PYSPARK_ALLOW_INSECURE_GATEWAY=1">> /etc/profile  && \
    echo "HIVE_HOME=/opt/hive/apache-hive-2.3.9-bin">> /etc/profile  && \
    echo "FLINK_HOME=/opt/flink/flink-1.10.1">> /etc/profile  && \
    echo "HIVE_CONF_DIR=$HIVE_HOME/conf">> /etc/profile  && \
    echo "SCALA_HOME=/usr/local/scala-2.11.8">> /etc/profile  && \
    echo "HADOOP_HOME=/opt/hadoop/hadoop-2.7.4">> /etc/profile  && \
    echo "HADOOP_CONF_PATH=$HADOOP_HOME/etc/hadoop">> /etc/profile  && \
    echo "HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop">> /etc/profile  && \
    echo "HADOOP_CLASSPATH=`${HADOOP_HOME}/bin/hadoop classpath`">> /etc/profile  && \
    echo "HADOOP_CONF_PATH=$HADOOP_HOME/etc/hadoop">> /etc/profile  && \
    echo "HADOOP_CONF_PATH=$HADOOP_HOME/etc/hadoop">> /etc/profile  && \
    echo "" >> /etc/profile

ENV SPARK_HOME=/opt/spark/spark-2.4.4-bin-hadoop2.7
ENV SPARK_CONF_DIR=$SPARK_HOME/conf
ENV PYSPARK_ALLOW_INSECURE_GATEWAY=1
ENV HIVE_HOME=/opt/hive/apache-hive-2.3.9-bin
ENV FLINK_HOME=/opt/flink/flink-1.10.1
ENV HIVE_CONF_DIR=$HIVE_HOME/conf
ENV SCALA_HOME=/usr/local/scala-2.11.8
ENV HADOOP_HOME=/opt/hadoop/hadoop-2.7.4
ENV HADOOP_CONF_PATH=$HADOOP_HOME/etc/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=${JAVA_HOME}/bin/:${SPARK_HOME}/bin:${HIVE_HOME}/bin:${SCALA_HOME}/bin:${FLINK_HOME}/bin:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:$PATH

RUN ls -l /opt
RUN cat /etc/hosts
RUN hadoop version




