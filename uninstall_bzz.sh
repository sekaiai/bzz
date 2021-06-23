uninstall() {
processId=`ps -ef|grep bee|grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $processId
do
  kill -9 $i
done
tCnt=`cat .showcnt.txt` && for ((i=1; i<=tCnt; i ++))
do
screen -S bee$i -X quit
done
screen -wipe
apt -y remove bee
apt autoremove
cd /root
rm -f bee_watcher.sh step1.sh step2.sh step3.sh cashout*.sh node*.yaml .showcnt.txt update_bee.sh epFile.txt add_watcher.sh 
rm -rf /var/lib/bee /etc/lib/bee /root/keys 
sed -i '/cashout/d' /etc/crontab
sed -i '/bee_watcher.sh/d' /etc/crontab
#sed -i '/-Shn/d' /etc/profile
}

echo -e "警告：请确保私钥已妥善保管。开始卸载？\e[93m[Y/n]\e[0m"
read choose
case $choose in
	[Yy])	
		uninstall
		sleep 2
		rm $0
		;;
	*)
		echo "已取消卸载。"
		;;
	esac
