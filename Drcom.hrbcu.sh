#!/bin/sh /etc/rc.common
START=99
start()
{
    server="182.61.200.6";
    # 用自己的学号替换123456
    user_account="123456";
    # 用自己的密码替换123456
    user_password="123456";
    # 如果你跟我一样刷的是AC2100。那么ip和mac可以不用动，如果是其他路由器，请根据自身情况修改
    # 路由器wan口ip
    wlan_user_ip=`ifconfig eth0.2|grep 'inet addr'|awk -F'[ :]' '{print $13}'`;
    # 路由器wan口mac
    wlan_user_mac=`ifconfig eth0.2|grep 'HWaddr'|awk -F'[ :]' '{print tolower($10$11$12$13$14$15)}'`;
    url="http://172.17.100.10:801/eportal/portal/login?callback=dr1003&login_method=1&user_account="$user_account"&user_password="$user_password"&wlan_user_ip="$wlan_user_ip"&wlan_user_mac="$wlan_user_mac;
    while true
    do
        ping -c 2 $server;
        if [ $? != 0 ];
        then            
            login_log=$(wget $url --header="Connection: keep-alive" --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36 Edg/89.0.774.50" -q -O -);
            dt=`date +"%F %T"`;
            echo $dt >> /login_drcom.log;
            echo $login_log >> /login_drcom.log;
        fi
    done
}