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
echo "│                                              Made By https://github.com/Fansirsqi/qinglong-install-script    │";
echo "╚──────────────────────────────────────────────────────────────────────────────────────────────────────────────╝";



# 检查是否为root用户
require_root() {
    if [ "$(id -u)" == "0" ]; then
        echo "✓ 您是root用户，将继续运行脚本。"
    else
        echo "X 您需要root权限来运行此脚本。"
        exit 1
    fi
}

# 设置DNS
set_dns() {
    if [[ -f /etc/resolv.conf ]] && [[ ! -L /etc/resolv.conf ]]; then
        cp /etc/resolv.conf /etc/resolv.conf.bak
        echo "已备份 /etc/resolv.conf 至 /etc/resolv.conf.bak"
    fi

    echo "nameserver 223.5.5.5" >/etc/resolv.conf
    echo "配置阿里DNS"

    echo "nameserver 114.114.114.114" >>/etc/resolv.conf
    echo "配置腾讯DNS"
}

# 备份和配置软件源
configure_sources() {
    cp /etc/apt/sources.list /etc/apt/sources.list.bak
    echo "备份 /etc/apt/sources.list 至 /etc/apt/sources.list.bak"

    printf "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse\n" >/etc/apt/sources.list
    printf "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse\n" >>/etc/apt/sources.list
    printf "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse\n" >>/etc/apt/sources.list

}

# 安装和配置青龙
install_qinglong() {

    # 更新软件源
    apt update -y

    # 设置时区
    apt install -y --no-install-recommends tzdata
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "设置时区完成"

    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

    apt install -y --no-install-recommends nodejs npm && echo "Node.js 安装完成"

    apt install -y --no-install-recommends sqlite3 && echo "SQLite3 安装完成"

    apt install -y --no-install-recommends nginx-full && echo "Nginx 安装完成"
    # 安装依赖
    apt install -y --no-install-recommends unzip openssl jq libssl-dev openssh-server libpango1.0-dev perl libpixman-1-dev procps python3-pip python3-dev login wget autoconf automake git

    # 配置pip
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

    # 升级pip和setuptools
    python3 -m pip install --upgrade pip setuptools -i https://pypi.tuna.tsinghua.edu.cn/simple

    # 配置git
    git config --global user.email "qinglong@users.noreply.github.com"
    git config --global user.name "qinglong"
    git config --global http.postBuffer 524288000

    # 安装青龙
    rm -rf /ql /static
    git clone --depth=1 -b debian https://gitee.com/whyour/qinglong.git /ql
    git clone --depth=1 -b debian https://gitee.com/whyour/qinglong-static.git /static

    # 安装npm依赖
    npm --registry https://registry.npmmirror.com i -g pnpm@8.3.1 pm2 tsx
    pnpm config set -g registry=https://registry.npmmirror.com
    cd /ql && pnpm install --prod

    # 配置青龙
    cp -f .env.example .env
    chmod 777 /ql/shell/*.sh /ql/docker/*.sh
    mkdir -p /ql/static
    cp -rf /static/* /ql/static

    # 配置环境变量
    printf "export PNPM_HOME=/root/.local/share/pnpm\n" >>/root/.bashrc
    printf "PATH=\$PATH:/root/.local/share/pnpm:/root/.local/share/pnpm/global/5/node_modules\n" >>/root/.bashrc
    printf "NODE_PATH=\$NODE_PATH:/root/.local/share/pnpm/global/5/node_modules\n" >>/root/.bashrc

    source /root/.bashrc
    source /ql/shell/share.sh
    fix_config
    npm_install_2 /ql/data/scripts

    # 修改配置文件
    sed -i 's/var\/log\/nginx\/error.log/dev\/null/g' /ql/docker/nginx.conf
    sed -i 's/nginx -s reload 2>\/dev\/null || nginx -c \/etc\/nginx\/nginx.conf/pm2 start \"nginx -c \/etc\/nginx\/nginx.conf\"/' /ql/docker/docker-entrypoint.sh
    sed -i 's/pip3 install/pip3 install --no-cache/g' /ql/static/build/data/dependence.js

    # 启动服务
    service cron start

    # 启动青龙
    cd /ql && /ql/docker/docker-entrypoint.sh
}

# 主函数
main() {
    require_root
    set_dns
    configure_sources
    install_qinglong
}

# Trap信号处理
trap 'echo "中断脚本..."; exit 1' SIGINT SIGTERM

# 执行主函数
main

# 脚本结束
