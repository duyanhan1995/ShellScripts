# ShellScriptTools,针对CentOS7环境的一些脚本

## CentOS 7  安装  MySQL 5.7.21
**简单说明**
- 开放3306端口，不关闭防火墙
- 直接覆盖掉CentOS7自带的MariaDB
- 同时帮助设置了远程登录
- 自定义初始密码(大于等于4位)，并在/root/secret/mysql_initPassword文件中可以查看到
- 安装命令如下：
```
wget https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/mysql.sh&&chmod 755 mysql.sh&&./mysql.sh
```

## CentOS 7  安装  Nginx 1.13.8
**简单说明**
- 开放80端口，不关闭防火墙
- 首页地址：http://IP:80
- 安装命令如下：
```
wget https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/nginx.sh&&chmod 755 nginx.sh&&./nginx.sh
```

## CentOS 7  修改用户名
**简单说明**
- 修改用户名通过依次修改passwd、shadow、group、gshadow这四个文件以及用户主目录/home/用户
- 用户名修改后，会自动对新用户名进行提权
- 要求：使用root用户执行此脚本
```
wget https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/changeUserName.sh&&chmod 755 changeUserName.sh&&./changeUserName.sh
```

## CentOS 7  卸载原始自带的JDK
**简单说明**
- 卸载自带的opendJDK
```
wget https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/uninstallOriginalJDK.sh&&chmod 755 uninstallOriginalJDK.sh&&./uninstallOriginalJDK.sh
```

## CentOS 7  安装新的JDK
**简单说明**
- 安装新的JDK，提供版本选择
- 可以自定义安装路径
- 自动配置并更新环境变量
```
wget https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/installNewJDK.sh&&chmod 755 installNewJDK.sh&&./installNewJDK.sh
```

## CentOS 7 集群批量设置SSH免密登录
**简单说明**
- 要求root目录下有名为host_ip.txt文件
- 要求具有root权限
- host_ip.txt格式为三列：ip + 一个空格 + 用户名 + 一个空格 + 密码
**适用场景**
例如搭建Hadoop集群时，各机器间的访问，需要免密登录：
可以将各机器的ip，用户名，密码按以上要求的格式放至host_ip.txt文件中，然后让他们同时执行以下脚本即可。
```
wget -c https://raw.githubusercontent.com/duyanhan1995/ShellScripts/master/sshBatchPasswordFree.sh && chmod 755 sshBatchPasswordFree.sh && ./sshBatchPasswordFree.sh
```
