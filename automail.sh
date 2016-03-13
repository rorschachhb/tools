#!/bin/bash

# Check if the ip of this machine has changed since last time.
# If the ip is changed, mail me.
# I usually add this script to crontab.

current_ip=`ifconfig | grep 'inet addr:' | grep -v '127.0.0.1' | cut -d : -f2 | awk '{print $1}'`

if [ -f /tmp/ip.txt ]; then
    old_ip=`cat /tmp/ip.txt`
    if [ "${old_ip}" = "${current_ip}" ]; then
        exit
    fi
fi

# mail me
echo "$current_ip `date "+%Y-%m-%d %H:%M:%S"`" | mail -v -s "`hostname` ip update" huangb14@mails.tsinghua.edu.cn 1>>/tmp/mail.log 2>&1
echo $current_ip > /tmp/ip.txt

