#!/bin/bash
file=JDKLinks
# 先在本地查找JDKLinks文件
if [ -f "${file}" ]
then
	# 若存在则删除
	rm -rf ${file}
fi
# 若不存在则下载
wget https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/${file}
# 给与一定操作权限
chmod u+r ${file}
# 读文件
# 保留默认字段分隔符IFS环境变量至IFS.OLD中
IFSOLD=${IFS}
# 定义数组versionName、versionURL、versionFileName
versionName=()
versionURL=()
versionFileName=()
count=0
# 将换行符作为字段分隔符
IFS=$'\n'
for line in $(cat JDKLinks)
do
	# 内部循环中将空格作为字段分隔符
	IFS=${IFSOLD}
	index=0
	for content in $(echo ${line})
	do
		if [ ${index} -eq 0 ]
		then
			# 获取版本名称
			versionName[${count}]=${content}
		else
			# 获取版本下载地址
			versionURL[${count}]=${content}
			# 获取版本文件名称
			temp=${content##h*\/}
			versionFileName[${count}]=${temp%%\?*}
		fi
		# 内循环计数器递增
		index=$(expr ${index} + 1)
	done
	# 计数器递增
	count=$(expr ${count} + 1)
done

# 打印验证函数
function print {
	for i in ${versionName[*]}
	do
		echo "${i}"
	done

	for i in ${versionURL[*]}
	do
		echo "${i}"
	done

	for i in ${versionFileName[*]}
	do
		echo "${i}"
	done
}


function printMenu {
	echo
	echo "以下是可选的jdk安装包："
	echo
	versionNameLength=${#versionName[*]}	
	for ((i=0; i < versionNameLength; i++))
	do
		order=$(expr ${i} + 1)
		echo "${order}、  ${versionName[i]}"
	done
}

function download {
	echo
	read -p "请选择您要安装的版本(1~${#versionName[*]})：" orderNumber
	echo
	index=$(expr ${orderNumber} - 1)
	echo "开始下载：${versionName[index]}"
	wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${versionURL[index]}
}

printMenu
download
