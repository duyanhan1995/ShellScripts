#!/bin/bash

#卸载OpenJDK，并安装OracleJDK
yum -y remove $(rpm -qa | grep jdk)
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
mkdir /usr/lib/jvm
tar -xzf jdk-8u131-linux-x64.tar.gz -C /usr/lib/jvm
echo '#设置JDK环境变量' >> /etc/profile
echo 'export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_131' >> /etc/profile
echo 'export CLASSPATH=$JAVA_HOME ' >> /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile
