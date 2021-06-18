#!/usr/bin/env bash
cntFile=".showcnt.txt"
epFile="epFile.txt"
bee_url=https://github.com/ethersphere/bee/releases/download

if [ ! -f $cntFile ]; then
  echo "首次使用脚本，进行初始化……"
  echo "安装系统依赖包"
  yum update
  yum install -y epel-release
  yum install -y screen jq wget net-tools tree chrony
  echo "同步时间"
  systemctl start chronyd.service && systemctl enable chronyd.service


  wget -O cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/cashout.sh && chmod 777 cashout.sh
  wget https://raw.githubusercontent.com/sekaiai/bzz/centos/step2.sh && chmod 777 step2.sh
  wget https://raw.githubusercontent.com/sekaiai/bzz/centos/step3.sh && chmod 777 step3.sh

  # 安装 bee-clef
  wget https://github.com/ethersphere/bee-clef/releases/download/v0.4.12/bee-clef_0.4.12_arm64.rpm
  sudo rpm -i bee-clef_0.4.12_arm64.rpm

  # 安装 bee
  # wget ${bee_url}/v0.6.2/bee_0.6.2_amd64.rpm
  # sudo rpm -i bee_0.6.2_amd64.rpm && sudo chown -R bee:bee /var/lib/bee
  # 安装bee
  if ! type bee >/dev/null 2>&1; then
    # 安装版本控制，都是安装amd64版本
    bee_version=$1
    if [ -z ${bee_version} ]; then
      echo "缺少bee版本号，请确认后重新尝试"
      exit 2
    fi
    wget ${bee_url}/v${bee_version}/bee_${bee_version}_amd64.rpm
    sudo rpm -i bee_${bee_version}_amd64.rpm
  fi
  echo -n "bee 已安装版本: "


  echo "0" > $cntFile
  chmod +rw $cntFile
  sed -i 's/10000000000000000/1/g' cashout.sh
  echo "请输入swap-endpoint链接，如https://goerli.infura.io/v3/12ecf******************:"
  read ep
  echo "${ep}" > $epFile
fi

if [ $# == 1 ]; then
  if [ $1 == "resetcnt" ]; then
  echo "0" > $cntFile
  fi
fi
ep=`cat $epFile`
tCnt=`cat $cntFile`
let tCnt++
echo $tCnt > $cntFile
echo "    这是第 $tCnt 次创建节点"
echo "    若需更改endpoint，请自行修改epFile.txt"
cat>node${tCnt}.yaml<<EOF
api-addr: :$((1534+${tCnt}))
#config: /root/node${tCnt}.yaml
data-dir: /var/lib/bee/node${tCnt}
cache-capacity: "2000000"
block-time: "15"
bootnode:
- /dnsaddr/bootnode.ethswarm.org
debug-api-addr: :$((1634+${tCnt}))
#debug-api-addr: 127.0.0.1:$((1634+${tCnt}))
debug-api-enable: true
p2p-addr: :$((1734+${tCnt}))
password-file: /var/lib/bee/password
swap-initial-deposit: "10000000000000000"
verbosity: 5
swap-endpoint: ${ep}
full-node: true
welcome-message: "欢迎来到无产阶级社群，MY NAME IS DADAGUAI WECHAT:dislike_diss"
EOF
cp cashout.sh cashout${tCnt}.sh
sed -i "s/1635/$((1634+${tCnt}))/g" cashout${tCnt}.sh
echo "    第${tCnt}个节点等待接水中,node${tCnt}.yaml文件已生成至当前目录"
echo "    请等候bee与以太坊后端同步完毕后接水，然后按Ctrl+C"
echo "    之后可用./step1.sh再次运行此脚本部署更多节点"
echo "    部署完所有节点后运行step2.sh开始正式挖矿"
bee start --config node${tCnt}.yaml
