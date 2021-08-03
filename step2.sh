#!/usr/bin/env bash
ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
cntFile=".showcnt.txt"
if [ ! -f $cntFile ]; then
echo "未运行step1！"
exit
fi

tCnt=`cat $cntFile`
for ((i=1; i<=tCnt; i ++))
do
screen -dmS bee$i
echo "beev3为无产阶级社区&MingCash贡献的掉线重启脚本，您正启动第$i个节点"
screen -x -S ant$i -p 0 -X stuff "ant $((1634+${i})) 'start --config node${i}.yaml'"
screen -x -S bee$i -p 0 -X stuff $'\n'
echo "第$i个节点已启动。"
sleep 2
done
