#!/bin/bash

current_ip=`/sbin/ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d : -f2 | awk '{print $1}'`

if [ -f /home/bo/tools/ip.txt ]; then
    old_ip=`cat /home/bo/tools/ip.txt`
    if [ "${old_ip}" = "${current_ip}" ]; then
        exit
    fi
fi

# mail me
echo "$current_ip `date "+%Y-%m-%d %H:%M:%S"`" | mailx -v -s "lab-pc ip update" huangb14@mails.tsinghua.edu.cn 1>>/home/bo/tools/mail.log 2>&1
echo $current_ip > /home/bo/tools/ip.txt

