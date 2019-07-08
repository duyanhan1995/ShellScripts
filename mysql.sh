#!/bin/bash
# mysql.sh
wget https://raw.githubusercontent.com/reki-cool/ShellScripts/master/mysql_configure.sh
wget https://raw.githubusercontent.com/reki-cool/ShellScripts/master/mysql_download.sh
chmod 755 mysql_configure.sh mysql_download.sh
./mysql_download.sh
./mysql_configure.sh
#	清理垃圾文件
rm -f sql.log
rm -f mysql57-community-release-el7-10.noarch.rpm
rm -f mysql_download.sh
rm -f mysql_configure.sh
#	tip
echo "mysql安装完毕！"
