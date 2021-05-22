#!/usr/bin/env bash
cntFile=".showcnt.txt"
epFile="epFile.txt"
if [ ! -f $cntFile ]; then
echo "未运行step1！"
exit
fi
tCnt=`cat $cntFile`
ep=`cat $epFile`
processId=`ps -ef|grep bee|grep -v grep|grep -v sh|grep -v PPID|awk '{ print $2}'`
for i in $processId
do
  kill -9 $i
done
echo "************************************************************"
for ((i=1; i<=tCnt; i ++))
do
screen -S bee$i -X quit
cat>node${i}.yaml<<EOF
api-addr: :$((1534+${i}))
data-dir: /var/lib/bee/node${i}
db-capacity: 20000000
debug-api-addr: :$((1634+${i}))
#debug-api-addr: 127.0.0.1:$((1634+${i}))
debug-api-enable: true
p2p-addr: :$((1734+${i}))
password-file: /var/lib/bee/password
swap-initial-deposit: "10000000000000000"
verbosity: 3
swap-endpoint: ${ep}
full-node: true
EOF
done
wget https://github.com/ethersphere/bee/releases/download/v0.6.1/bee_0.6.1_amd64.deb
sudo dpkg -i bee_0.6.0_amd64.deb
for ((i=1; i<=tCnt; i ++))
do
screen -dmS bee$i
screen -x -S bee$i -p 0 -X stuff "bee start --config node${i}.yaml"
screen -x -S bee$i -p 0 -X stuff $'\n'
echo "第$i个节点已启动。"
done
screen -wipe
screen -ls
