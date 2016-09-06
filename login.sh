#!/bin/bash

# This script handles login/logout in Tsinghua University
# Usage 1: ./login.sh login username passwd
# Usage 2: ./login.sh logout
# Note that using this script will save your password in bash history
# but it's fine as long as it's your personal computer

if [ "$#" -eq "0" ]; then
	parse=invalid
elif [ "$1" == "login" ]; then
	if [ "$#" -lt "3" ]; then
		parse=invalid
	else
		parse=log_in
	fi
elif [ "$1" == "logout" ]; then
	parse=log_out
else
	parse=invalid
fi

if [ "$parse" == "invalid" ]; then
	echo "usage 1: ./login.sh login username passwd"
	echo "usage 2: ./login.sh logout"
	exit 1
elif [ "$parse" == "log_out" ]; then
	logged=`curl -s http://net.tsinghua.edu.cn/do_login.php -d "action=logout"`;
	echo $logged
elif [ "$parse" == "log_in" ]; then
	username=$2
	passwd=$3
	passwd_md5=`echo -n $passwd | md5sum | awk '{print $1}'`

	logged=`curl -s http://net.tsinghua.edu.cn/do_login.php -d "action=check_online"`;
	echo $logged
	if [ "$logged" == "not_online" ]; then
		logged1=`curl -s http://net.tsinghua.edu.cn/do_login.php -d "action=login&username=${username}&password={MD5_HEX}${passwd_md5}&ac_id=1"`;
		if [ "$logged1" != "" ]; then
		  echo $logged1;
		fi
	fi
fi
