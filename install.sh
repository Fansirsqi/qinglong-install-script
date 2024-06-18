#!/bin/bash

echo "╔──────────────────────────────────────────────────────────────────────────────────────────────────────────────╗";
echo "│                                                                                                              │";
echo "│                    ██████╗ ██╗███╗   ██╗ ██████╗ ██╗      ██████╗ ███╗   ██╗ ██████╗                         │";
echo "│                   ██╔═══██╗██║████╗  ██║██╔════╝ ██║     ██╔═══██╗████╗  ██║██╔════╝                         │";
echo "│                   ██║   ██║██║██╔██╗ ██║██║  ███╗██║     ██║   ██║██╔██╗ ██║██║  ███╗                        │";
echo "│                   ██║▄▄ ██║██║██║╚██╗██║██║   ██║██║     ██║   ██║██║╚██╗██║██║   ██║                        │";
echo "│                   ╚██████╔╝██║██║ ╚████║╚██████╔╝███████╗╚██████╔╝██║ ╚████║╚██████╔╝                        │";
echo "│                    ╚══▀▀═╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝                         │";
echo "│                                                                                                              │";
echo "│   ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗           ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗   │";
echo "│   ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║           ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝   │";
echo "│   ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗███████╗██║     ██████╔╝██║██████╔╝   ██║      │";
echo "│   ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ╚════╝╚════██║██║     ██╔══██╗██║██╔═══╝    ██║      │";
echo "│   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗      ███████║╚██████╗██║  ██║██║██║        ██║      │";
echo "│   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝      ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝      │";
echo "│                                                                      Made By@https://github.com/Fansirsqi    │";
echo "╚──────────────────────────────────────────────────────────────────────────────────────────────────────────────╝";

require_root() {
    if [ "$(id -u)" == "0" ]; then
        # 如果这里是root用户，执行后续命令
        echo "✅您是root用户，将继续运行脚本。"
    else
        echo "❌您需要root权限来运行此脚本。"
        exit 1
    fi
}

require_root

set_dns() {
    # 检查 /etc/resolv.conf 是否存在且不是符号链接
    if [[ -f /etc/resolv.conf ]] && [[ ! -L /etc/resolv.conf ]]; then
        # 备份原始的 resolv.conf 文件
        cp /etc/resolv.conf /etc/resolv.conf.bak
        echo "已备份 /etc/resolv.conf 至 /etc/resolv.conf.bak"
    fi
    
    # 替换
    echo "nameserver 223.5.5.5" >/etc/resolv.conf
    echo "配置阿里DNS✅"
    
    # 添加腾讯 DNS 服务器
    echo "nameserver 114.114.114.114" >>/etc/resolv.conf
    echo "配置腾讯DNS✅"
}

set_dns

cp /etc/apt/sources.list /etc/apt/sources.list.bak && echo "备份 /etc/apt/sources.list 至 /etc/apt/sources.list.bak"
cat >/etc/apt/sources.list <<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
EOF

apt update -y

groupadd -g 3001 aid_bt
groupadd -g 3002 aid_bt_net
groupadd -g 3003 aid_inet
groupadd -g 3004 aid_net_raw
groupadd -g 3005 aid_admin
usermod -a -G aid_bt,aid_bt_net,aid_inet,aid_net_raw,aid_admin root

sudo apt-get install -y tzdata
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "设置时区完成"

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

apt-get install -y nodejs && echo "Node.js 安装完成"

apt-get install -y sqlite3 && echo "SQLite3 安装完成"

apt-get install -y nginx-full && echo "Nginx 安装完成"

apt-get install -y unzip openssl jq libssl-dev openssh-server libpango1.0-dev perl libpixman-1-dev procps python3-pip python3-dev login wget autoconf automake git && echo "其他依赖安装完成"

pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && echo "pip镜像源设置完成"

python3 -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && echo "pip升级完成"

python3 -m pip install --upgrade setuptools -i https://pypi.tuna.tsinghua.edu.cn/simple && echo "setuptools升级完成"

# service ssh start

ssh-keygen -A

git config --global user.email "qinglong@users.noreply.github.com"
git config --global user.name "qinglong"
git config --global http.postBuffer 524288000

rm -rf /ql && echo "青龙目录已删除"
rm -rf /static && echo "青龙静态资源目录已删除"

git clone --depth=1 -b debian https://gitee.com/whyour/qinglong.git /ql && echo "青龙代码拉取完成"
git clone --depth=1 -b debian https://gitee.com/whyour/qinglong-static.git /static && echo "青龙静态资源拉取完成"

npm --registry https://registry.npmmirror.com i -g pnpm@8.3.1 pm2 tsx && echo "青龙基础依赖安装完成"
pnpm config set -g registry=https://registry.npmmirror.com && echo "pnpm镜像源设置完成"
cd /ql && pnpm install --prod && echo "青龙npm依赖安装完成"

cp -f .env.example .env && echo "青龙环境变量配置完成"
chmod 777 /ql/shell/*.sh && echo "青龙脚本权限设置完成"
chmod 777 /ql/docker/*.sh && echo "青龙docker脚本权限设置完成"
mkdir -p /ql/static
cp -rf /static/* /ql/static && echo "青龙静态资源安装完成"

cp /root/.bashrc /root/.bashrc.bak && echo "备份 /root/.bashrc 至 /root/.bashrc.bak"
cat >>/root/.bashrc <<EOF
export PNPM_HOME=/root/.local/share/pnpm \
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/share/pnpm:/root/.local/share/pnpm/global/5/node_modules:\$PNPM_HOME \
NODE_PATH=/usr/local/bin:/usr/local/pnpm-global/5/node_modules:/usr/local/lib/node_modules:/root/.local/share/pnpm/global/5/node_modules \
LANG=C.UTF-8 \
SHELL=/bin/bash \
PS1='\u@\h:\w\\$ ' \
QL_DIR=/ql \
QL_BRANCH=debian
EOF

source /root/.bashrc
source /ql/shell/share.sh
fix_config
# cp /ql/sample/package.json /ql/data/scripts
npm_install_2 /ql/data/scripts

sed -i 's/var\/log\/nginx\/error.log/dev\/null/g' /ql/docker/nginx.conf

sed -i 's/nginx -s reload 2>\/dev\/null || nginx -c \/etc\/nginx\/nginx.conf/pm2 start \"nginx -c \/etc\/nginx\/nginx.conf\"/' /ql/docker/docker-entrypoint.sh

sed -i 's/pip3 install/pip3 install --no-cache/g' /ql/static/build/data/dependence.js

service cron start

cd /ql && /ql/docker/docker-entrypoint.sh
