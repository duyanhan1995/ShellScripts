#!/bin/bash

echo "正在查找自带jdk"
echo
IFS=$'\n'
for package in $(rpm -qa | grep jdk)
do 
	echo "开始卸载：${package}"
	yum -y remove ${package}
	echo "${package}卸载完毕"
	echo 
done
echo
echo "执行完毕！全部卸载完成！"
