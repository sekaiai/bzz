#语雀的教程是crontab -e无需指定用户名，照抄时候忘记补上了
sed -i 's#/root/cashout#root /root/cashout#g' /etc/crontab
service cron reload
