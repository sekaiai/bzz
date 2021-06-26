#!/bin/bash
i=0
while true
do
    res=`ps -ef | grep "./$1 $3" | grep -v grep | wc -l`
    if [ $res -eq 0 ]
    then
        i=0
	echo "启动命令 ./$1 $3";
	./$1 $3
    fi    
    result_code=`curl -I -m 10 -o /dev/null -s -w %{http_code} http://127.0.0.1:$2/health`
    if [ ${result_code} -ne 200 ]
    then
        i=$(($i+1))
        echo "掉线了 重启计数 ${i}  i=12重启";
		if [ ${i} -eq 12 ]
		then
			`ps -efww|grep './work101 .*1639' |grep -v grep|cut -c 9-15|xargs kill -9`
			./$1 $3
			i=0
		fi	
    fi
    sleep 5s
done
