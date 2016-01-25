#!/bin/bash

current_ip=`ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d : -f2 | awk '{print $1}'`

if [ -f ~/tools/ip.txt ]; then
    old_ip=`cat ~/tools/ip.txt`
    if [ "${old_ip}" = "${current_ip}" ]; then
        exit
    fi
fi

# mail me
echo "$current_ip `date "+%Y-%m-%d %H:%M:%S"`" | mail -v -s "`hostname` ip update" huangb14@mails.tsinghua.edu.cn 1>>~/tools/mail.log 2>&1
echo $current_ip > ~/tools/ip.txt

