#!/bin/bash
#author:wu yuan qiang
#date:2019-03-20
#准备安装环境
#修改时间
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
#关闭防火墙
systemctl stop firewalld 
setenforce 0
sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
#配置java环境
yum -y install java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64 2>/dev/null
read -p "是否查看java环境搭建成功(y/n):" yn
if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
java -version
elif [ "$yn" == "N" ] || [ "$yn" == "n"  ]; then
echo "进行下一步..."
fi
#部署数据库
#准备mariadb数据库
yum -y install mariadb-server mariadb 2>/dev/null
sed -i '2 i transaction-isolation=READ-COMMITTED' /etc/my.cnf
#启动数据库
systemctl start mariadb
systemctl enable mariadb 2>/dev/null
#设置mysql密码
read -p "重置数据库密码：" passwd
mysql -uroot -p123456 -e "set password for root@'localhost'=password('$passwd');"
#设置confluence数据库
mysql -u root -p -e 'create database confluence default character set utf8 collate utf8_bin;'
#下载confluence
cd /opt
wget -t 0 https://www.atlassian.com/software/confluence/downloads/binary/atlassianconfluence-6.14.2-x64.bin
#给予755权限
chmod 755 atlassian-confluence-6.14.2-x64.bin
#部署Confluence Wiki
echo "现在开始部署Confluence Wiki！！"
echo "请等待5秒钟！！"
ti1=`date +%s`     #获取时间戳
ti2=`date +%s`
i=$(($ti2 - $ti1 ))
while [[ "$i" -ne "5" ]] #等待5s执行下一条指令
do
        ti2=`date +%s`
        i=$(($ti2 - $ti1 ))
done
./opt/atlassian-confluence-6.14.2-x64.bin
