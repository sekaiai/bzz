#!/usr/bin/env bash
[[ -f /root/bee_watcher.sh ]] && echo "已存在监听脚本" && exit 1
echo "*/5 * * * * root /root/bee_watcher.sh" >> /etc/crontab
cat > /root/bee_watcher.sh <<'EOF'
#!/usr/bin/env bash
cntFile=".showcnt.txt"
if [ ! -f $cntFile ]; then
echo "未运行step1！"
exit
fi
tCnt=`cat $cntFile`
for ((i=1; i<=tCnt; i ++))
do
lsof -i:$((1534+$i))
if [ $? -ne 0 ]
then
screen -x -S bee$i -p 0 -X stuff "bee start --config node${i}.yaml"
screen -x -S bee$i -p 0 -X stuff $'\n'
echo "第$i个节点已启动。"
sleep 2
fi
done
EOF
echo "已创建监听脚本"
chmod 777 /root/bee_watcher.sh
