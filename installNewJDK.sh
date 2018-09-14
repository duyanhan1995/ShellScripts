#!/bin/bash

jdkFile=JDKLinks
# 先在本地查找JDKLinks文件
if [ -f "${jdkFile}" ]
then
	# 若存在则删除
	rm -rf ${jdkFile}
fi
# 若不存在则下载
wget https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/${jdkFile}
echo "jdk版本链接依赖文件下载完成..."
# 给与一定操作权限
chmod u+r ${jdkFile}
# 读文件
# 保留默认字段分隔符IFS环境变量至IFS.OLD中
IFSOLD=${IFS}
# 定义数组versionName、versionURL、versionFileName
versionName=()
versionURL=()
versionFileName=()
# 选择的版本在数组中的索引
select=0
count=0
# 将换行符作为字段分隔符
IFS=$'\n'
for line in $(cat ${jdkFile})
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
	select=index
	echo "开始下载：${versionName[index]}"
	# 检测本地是否已有，若有则不下载
	if [ ! -f ${versionFileName[index]} ]
	then
		# 没有则下载
		wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${versionURL[index]}
		echo "下载完成"
	else 
		echo "文件已存在！"
	fi
}


destDir=""
function getSubDir() {
	for element in $(ls ${1})
	do
		path="${1}/${element}"
		if [ -d ${path} ]
		then
			destDir=${element}
		fi
	done
}



function updateEnv() {

	echo "开始配置环境变量，请稍等..."
	file="/etc/profile"
	chmod u+w ${file}
	echo "" >> ${file}
	echo "#set java environment" >> ${file}
	echo "" >> ${file}
	echo "JAVA_HOME=${1}" >> ${file}
	echo "JRE_HOME=${2}" >> ${file}
	echo "CLASS_PATH=${3}" >> ${file}
	echo "PATH=${4}" >> ${file}
	echo "export JAVA_HOME JRE_HOME CLASS_PATH PATH" >> ${file}
	sleep 0.75s
	echo "配置完毕！"
	locate source /etc/profile > /dev/null
	sleep 0.75s
	echo "环境变量配置已经生效..."
	# 恢复环境变量配置文件原有权限
	chmod 644 ${file}
	echo "安装完成，当前java版本为"
	echo 

	java -version
}

myJAVA_HOME=""
myJRE_HOME=""
myClASS_PATH=""
myPATH=""
myJAVA_BIN=""
myJAVA_LIB=""
function unzip {
	# 开始解压文件
	read -p "要安装在当前目录吗？(y/n): " answer
	echo
	if [[ "${answer}" == "y" || "${answer}" == "Y" ]]
	then
		mkdir -p java
		echo "开始解压，请稍等..."
		# 默认安装在当前目录
		tar -zxf ${versionFileName[${select}]} -C ./java
		echo "解压完毕！"
		# 获取核心目录
		getSubDir java
		# 移动并重命名核心目录
		mv ./java/${destDir} ./javaTemp
		rm -rf java
		mv javaTemp java
		# 切入java目录
		cd java
		myJAVA_HOME="$(pwd)"
	elif [[ "${answer}" == "n" || "${answer}" == "N" ]]
	then
		read -p "请输入自定义安装路径：" customPath
		echo "开始创建目录"
		mkdir -p ${customPath}
		echo "开始解压，请稍等..."
		tar -zxf ${versionFileName[${select}]} -C ${customPath}
		echo "解压完毕！"
		# 获取当前目录
		currentPath=$(pwd)
		# 获取核心目录
		getSubDir ${customPath}
		cd ${customPath}/${destDir}
		cp -r * ${customPath}
		rm -rf ${customPath}/${destDir}
		myJAVA_HOME="${customPath}"
		# 返回实际存在的目录
		cd ${currentPath}
	fi

	myJAVA_BIN="${myJAVA_HOME}/bin"
	myJRE_HOME="${myJAVA_HOME}/jre"
	myJAVA_LIB="${myJAVA_HOME}/lib"
	myClASS_PATH=".:${myJAVA_LIB}/dt.jar:${myJAVA_LIB}/tools.jar:${myJAVA_LIB}"
	myPATH="${PATH}:${myJAVA_BIN}:${myJRE_HOME}"

	sleep 0.75s
	# 配置环境变量
	updateEnv ${myJAVA_HOME} ${myJRE_HOME} ${myClASS_PATH} ${myPATH} 
}

printMenu
download
unzip

sleep 0.75s
echo
echo "脚本退出！========脚本若有使用问题，联系 2504621508@qq.com "

# 删除脚本(jdk链接文件和脚本本身)
rm -f ${jdkFile}
rm -f ${0}
