#!/bin/bash

# read -p "请输入原始用户名: " oldName
# read -p "请输入新的用户名: " newName
# echo ""
# echo "即将使用新用户名：${newName}，更替旧用户名：${oldName}"
# # 要修改的文件，它们的名称构成的数组

# fileArray=(passwd shadow group gshadow)
# for file in ${fileArray[*]}
# do
# 	IFS=$'\n'
# 	count=0
# 	for line in $(cat /etc/${file})
# 	do
# 		count=$(expr ${count} + 1)
# 		oldLine=${line}
# 		newLine=${line//${oldName}/${newName}}
# 		if [[ ${oldLine} =~ ${oldName} ]]
# 		then
# 			lineNumber=${count}
# 			echo "修改：/etc/${file}：第${lineNumber}行"
# 			echo "原始为：${oldLine}"
# 			echo "更改为：${newLine}"
# 		fi
# 		echo  "${newLine}" >>/etc/${file}.bak.temp
# 	done
# 	cp /etc/${file}.bak.temp /etc/${file}
# 	rm -rf /etc/${file}.bak.temp
# done
# mv /home/${oldName} /home/${newName}
# echo "更新用户主目录/home/${oldName}——>/home/${newName}"
# echo ""
# echo "用户名修改完毕！"


# 2018年9月26日更新
read -p "请输入原始用户名: " oldName
read -p "请输入新的用户名: " newName
echo ""
echo "即将使用新用户名：${newName}，更替旧用户名：${oldName}"
# 要修改的文件，它们的名称构成的数组
fileArray=(passwd shadow group gshadow)
for file in ${fileArray[*]}
do
	sed -i "s/${oldName}/${newName}/g" /etc/${file}
	echo "/etc/${file}文件已经修改完毕！"
done
mv /home/${oldName} /home/${newName}
echo "更新用户主目录/home/${oldName}——>/home/${newName}"
chmod u+w /etc/sudoers
# 删除旧用户授权
echo "删除旧用户${oldName}授权"
sed -i "/${oldName}[ \t]*ALL=(ALL)[ \t]*ALL/d" /etc/sudoers
# 添加新用户授权
echo "添加新用户${newName}授权"
sed -i "/root[ \t]*ALL=(ALL)[ \t]*ALL/ a ${newName}\tALL=(ALL) \tALL" /etc/sudoers
# 移除/etc/sudoers可写权限
chmod u-w /etc/sudoers
# 删除此脚本自身
rm -f ${0}
