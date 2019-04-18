#!/bin/bash
start(){
	echo "*****************开始界面***********************"
	echo "1.注册"
	echo "2.登录"
	echo "3.退出"
	echo "************************************************"
	echo "输入数字进入相应菜单："
	read num
	return $num
}

register(){
	echo "******************注册************************"
	a=0
	while [ $a -le 0  ]
	do
		read -p "请输入用户名：" name
		mysql -e "create table test.$name (name char(10),password int(10),sum int(100));"
		if [ $? -eq 0 ]
		then
			b=0
			while [ $b -le 0 ]
			do
				echo "设置密码："
				read password1
				echo "确认密码："
				read password2
				if [ "$password1" = "$password2" ]
				then
					echo "注册成功"
					mysql -e "insert into test.jack(name,password,sum) values ('$name','$password1','100')"
					b=$(($b+1))
			
				else
					echo "两次输入不同，请重新输入"
        			fi
			done
			a=$(($a+1))
		else 
			echo "此用户名已注册，请重新输入"
		fi		
	done
}

login(){
		echo "************************登入************************"
		echo "用户名："
		read  id
		mysql -e "select *from test.$id" &>/dev/null
		if [ $? -eq 0 ]
		then
			echo "密码："
			read  password3
			password=$(mysql -e "select * from test.$id" | grep $id | awk '{print $2}')
			if [ "$password" = "$password3"  ]
			then
				echo "$id 登录成功"
				return 1
			else
				echo "密码错误,请重新登录"
				return 0
			fi
		else
			echo "该用户不存在"
				return 0
		fi
##      判断用户名是否存在
## 	判断密码是否正确
}

home(){
	echo "***********************主菜单************************"
	echo "1 查询"
	echo "2 充值"
	echo "3 消费"
	echo "输入数字进入相应菜单："
	read anum
	case $anum in
	"1") sum=$(mysql -e "select * from test.$id" | grep $id| awk '{print $3}')
	   echo "账户余额：$sum"
	   echo "输入1返回主菜单，2退出"
	   read snum
	;;
	"2") echo "*******************充值*******************"
	   echo "注：充值金额必须为50的整数倍"
	   echo "请输入充值金额："
	   read aa
	   if [ "$(($aa%50))" = "0" ]
	   then 
		mysql -e "update test.$id set sum=sum+'$aa' where name='$id'"&>/dev/null
		echo "充值成功"
	   else
		echo "充值金额必须为50的整数倍"
	   fi	
	   echo "输入1返回主菜单，2退出"
	   read snum
	;;
	"3") echo "*******************消费*******************"
	   echo "请输入消费金额"
	   read bb
	   mysql -e "update test.$id set sum=sum-'$bb' where name='$id'" &>/dev/null
	   echo "消费成功"
           echo "输入1返回主菜单，2退出"
           read snum
	;;
	esac
	return $snum
}
i=0
while [ $i -ge 0  ] 
do
	start
	case $num in
	"1") register
	     sleep 1
	     i=$(($i+1))
	;;
	"2") for ((j=0;j<=2;j++))
	     do
		login
		if [ $? -eq 1 ]
     	    	then
			home
			while  [ 1 ]
			do
				if [ $snum -eq 1 ]
				then
					home
				else if [ $snum -eq 2 ]
				     then 
						exit
				     fi
				fi
			done
			break
		fi
	     done
	;;
	"3") exit
	;;
	esac
done
