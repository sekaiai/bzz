tCnt=`cat .showcnt.txt`
for ((i=1; i<=tCnt; i ++))
do
sed -i 's#/root/cashout#root /root/cashout#g' /etc/crontab
done
echo "已修复root用户的自动兑现问题。"
